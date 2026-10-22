import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'presence_connection.dart';

PresenceConnection openPresenceConnection(Uri uri) =>
    NativePresenceConnection(uri);

/// Native sockets use the same authenticated protocol as the web. A lifecycle
/// observer reports suspension; no GPS or application content is transmitted.
class NativePresenceConnection
    with WidgetsBindingObserver
    implements PresenceConnection {
  NativePresenceConnection(Uri uri) {
    WidgetsBinding.instance.addObserver(this);
    GestureBinding.instance.pointerRouter.addGlobalRoute(_pointer);
    HardwareKeyboard.instance.addHandler(_key);
    _open(uri);
  }
  static const origin = String.fromEnvironment(
    'PRESENCE_ORIGIN',
    defaultValue: 'https://plataforma.atopos.spotec.app',
  );
  final _opening = Completer<void>();
  final _incoming = StreamController<String>();
  final _visibility = StreamController<bool>.broadcast();
  final _interactions = StreamController<void>.broadcast();
  WebSocket? _socket;
  StreamSubscription<dynamic>? _subscription;
  bool _closed = false;
  DateTime _lastInteraction = DateTime.fromMillisecondsSinceEpoch(0);
  Future<void> _open(Uri uri) async {
    try {
      final socket = await WebSocket.connect(
        uri.toString(),
        headers: {'Origin': origin},
      ).timeout(const Duration(seconds: 10));
      if (_closed) {
        await socket.close();
        return;
      }
      _socket = socket;
      _subscription = socket.listen(
        (data) {
          if (data is String && !_closed) _incoming.add(data);
        },
        onError: (Object error) {
          if (!_closed) _incoming.addError(error);
        },
        onDone: () {
          if (!_closed && !_incoming.isClosed) _incoming.close();
        },
      );
      if (!_opening.isCompleted) _opening.complete();
    } catch (error, stack) {
      if (!_opening.isCompleted) _opening.completeError(error, stack);
    }
  }

  void _interaction() {
    if (_closed ||
        !visible ||
        DateTime.now().difference(_lastInteraction).inSeconds < 2)
      return;
    _lastInteraction = DateTime.now();
    _interactions.add(null);
  }

  void _pointer(PointerEvent event) {
    if (event is PointerDownEvent) _interaction();
  }

  bool _key(KeyEvent event) {
    if (event is KeyDownEvent) _interaction();
    return false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_closed) _visibility.add(visible);
  }

  @override
  Future<void> get ready => _opening.future;
  @override
  Stream<String> get messages => _incoming.stream;
  @override
  Stream<bool> get visibility => _visibility.stream;
  @override
  Stream<void> get interactions => _interactions.stream;
  @override
  bool get visible {
    final state = WidgetsBinding.instance.lifecycleState;
    return state == null ||
        state == AppLifecycleState.resumed ||
        state == AppLifecycleState.inactive;
  }

  @override
  void send(String data) {
    if (!_closed && _socket?.readyState == WebSocket.open) _socket!.add(data);
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;
    WidgetsBinding.instance.removeObserver(this);
    GestureBinding.instance.pointerRouter.removeGlobalRoute(_pointer);
    HardwareKeyboard.instance.removeHandler(_key);
    _subscription?.cancel();
    _socket?.close();
    if (!_incoming.isClosed) _incoming.close();
    _visibility.close();
    _interactions.close();
  }
}
