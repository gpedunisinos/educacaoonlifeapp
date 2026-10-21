import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'presence_connection.dart';

PresenceConnection openPresenceConnection(Uri uri) => _BrowserPresence(uri);

class _BrowserPresence implements PresenceConnection {
  _BrowserPresence(Uri uri) : socket = web.WebSocket(uri.toString()) {
    opened = ((web.Event e) {
      if (!opening.isCompleted) opening.complete();
    }).toJS;
    message = ((web.MessageEvent e) {
      if (e.data.isA<JSString>()) incoming.add((e.data as JSString).toDart);
    }).toJS;
    ended = ((web.Event e) {
      if (!opening.isCompleted)
        opening.completeError(StateError('Canal indisponível'));
      incoming.close();
    }).toJS;
    changed = ((web.Event e) {
      changes.add(visible);
    }).toJS;
    interacted = ((web.Event e) {
      if (DateTime.now().difference(lastInteraction).inSeconds >= 2) {
        lastInteraction = DateTime.now();
        actions.add(null);
      }
    }).toJS;
    socket.addEventListener('open', opened);
    socket.addEventListener('message', message);
    socket.addEventListener('close', ended);
    socket.addEventListener('error', ended);
    web.document.addEventListener('visibilitychange', changed);
    web.document.addEventListener('pointerdown', interacted);
    web.document.addEventListener('keydown', interacted);
  }
  final web.WebSocket socket;
  final opening = Completer<void>();
  final incoming = StreamController<String>();
  final changes = StreamController<bool>.broadcast();
  final actions = StreamController<void>.broadcast();
  DateTime lastInteraction = DateTime.fromMillisecondsSinceEpoch(0);
  late final JSFunction opened, message, ended, changed, interacted;
  bool closed = false;
  @override
  Future<void> get ready => opening.future;
  @override
  Stream<String> get messages => incoming.stream;
  @override
  bool get visible => !web.document.hidden;
  @override
  Stream<bool> get visibility => changes.stream;
  @override
  Stream<void> get interactions => actions.stream;
  @override
  void send(String data) {
    if (!closed && socket.readyState == web.WebSocket.OPEN)
      socket.send(data.toJS);
  }

  @override
  void close() {
    if (closed) return;
    closed = true;
    socket.removeEventListener('open', opened);
    socket.removeEventListener('message', message);
    socket.removeEventListener('close', ended);
    socket.removeEventListener('error', ended);
    web.document.removeEventListener('visibilitychange', changed);
    web.document.removeEventListener('pointerdown', interacted);
    web.document.removeEventListener('keydown', interacted);
    socket.close();
    incoming.close();
    changes.close();
    actions.close();
  }
}
