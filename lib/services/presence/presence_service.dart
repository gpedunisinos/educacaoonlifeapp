import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'presence_connection.dart';
import 'presence_wire.dart';

String presenceSection(String route) {
  final path = Uri.tryParse(route)?.path ?? '';
  if (path == '/living_clues/map') return 'earth';
  if (path.startsWith('/space/research') || path.startsWith('/living_clues'))
    return 'research';
  if (path.startsWith('/nodes') || path.startsWith('/node_links'))
    return 'observatory';
  if (path.startsWith('/space/agents') || path.startsWith('/chat_templates'))
    return 'agents';
  if (path == '/space' || path == '/home') return 'cockpit';
  return 'platform';
}

class PresencePerson {
  PresencePerson(this.id, this.name, this.destination, this.activity);
  final String id, name, destination, activity;
  static PresencePerson? parse(dynamic value) {
    if (value is! Map) return null;
    final id = value['id'],
        name = value['name'],
        destination = value['destination'],
        activity = value['activity'];
    if (id is! String ||
        id.length > 64 ||
        name is! String ||
        name.length > 80 ||
        destination is! String ||
        ![
          'cockpit',
          'earth',
          'research',
          'observatory',
          'agents',
        ].contains(destination) ||
        activity is! String ||
        activity.length > 80)
      return null;
    return PresencePerson(id, name, destination, activity);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'destination': destination,
    'activity': activity,
  };
}

class PresenceService extends GetxService {
  PresenceService({
    PresenceConnection Function(Uri)? connect,
    this.endpoint,
    this.supported = kIsWeb,
  }) : connect = connect ?? openPresenceConnection;
  final PresenceConnection Function(Uri) connect;
  final Uri? endpoint;
  final bool supported;
  final privateEvents = StreamController<Map<String, dynamic>>.broadcast();
  final participants = <PresencePerson>[].obs;
  final available = false.obs;
  String self = '';
  AuthUser? account;
  Worker? userWatch;
  PresenceConnection? wire;
  StreamSubscription<String>? messages;
  StreamSubscription<bool>? visibility;
  StreamSubscription<void>? interactions;
  Timer? heartbeat, retry, authTimeout;
  int generation = 0, version = -1, attempt = 0;
  String section = 'platform';
  DateTime lastMessage = DateTime.now();
  bool disposed = false;
  void attach(UserController users) {
    userWatch = ever(users.user, setAccount);
    setAccount(users.user.value);
  }

  void setAccount(AuthUser? next) {
    if (next?.id == account?.id && next?.token == account?.token) return;
    disconnect(bye: true);
    account = next;
    participants.clear();
    self = '';
    attempt = 0;
    if (next != null && next.token.isNotEmpty && supported) start();
  }

  void route(String route) {
    if (route.isEmpty) return;
    final next = presenceSection(route);
    if (next == section) return;
    section = next;
    sendState(interacted: true);
  }

  Uri get uri {
    final client = WebClient.instance;
    return endpoint ??
        Uri(
          scheme: client.scheme == 'https' ? 'wss' : 'ws',
          host: client.host,
          port: client.port,
          path: '/api/presence',
        );
  }

  Future<void> start() async {
    if (disposed || account == null || wire != null || !supported) return;
    final current = ++generation;
    try {
      final socket = connect(uri);
      wire = socket;
      messages = socket.messages.listen(
        (raw) {
          if (current == generation) receive(raw);
        },
        onError: (_) {
          if (current == generation) failed();
        },
        onDone: () {
          if (current == generation) failed();
        },
      );
      visibility = socket.visibility.listen((visible) {
        sendState(interacted: visible);
        if (visible) privateEvents.add({"type": "resume"});
      });
      interactions = socket.interactions.listen((_) {
        if (socket.visible) sendState(interacted: true);
      });
      await socket.ready.timeout(const Duration(seconds: 10));
      if (current != generation || disposed || account == null) return;
      socket.send(jsonEncode({'type': 'auth', 'token': account!.token}));
      authTimeout = Timer(const Duration(seconds: 10), () {
        if (!available.value) failed();
      });
    } catch (_) {
      if (current == generation) failed();
    }
  }

  void receive(String raw) {
    try {
      final data = jsonDecode(raw);
      if (data is! Map) return;
      lastMessage = DateTime.now();
      if (data['type'] == 'alive') return;
      if (data['type'] == 'chat' && data['conversation_id'] is String) {
        privateEvents.add({
          'type': 'chat',
          'conversation_id': data['conversation_id'],
        });
        return;
      }
      final nextVersion = data['version'];
      if (nextVersion is! int || nextVersion < version) return;
      if (data['type'] == 'snapshot') {
        if (data['self'] is! String || data['participants'] is! List) return;
        self = data['self'];
        participants.assignAll(
          (data['participants'] as List)
              .map(PresencePerson.parse)
              .whereType<PresencePerson>(),
        );
        version = nextVersion;
        final first = !available.value;
        available.value = true;
        attempt = 0;
        authTimeout?.cancel();
        if (first) {
          privateEvents.add({'type': 'reconnected'});
          sendState(interacted: true);
          heartbeat?.cancel();
          heartbeat = Timer.periodic(const Duration(seconds: 20), (_) {
            if (DateTime.now().difference(lastMessage).inSeconds > 70) {
              failed();
              return;
            }
            sendState(heartbeat: true);
          });
        }
      } else if (data['type'] == 'update' &&
          available.value &&
          nextVersion > version) {
        if (nextVersion != version + 1) {
          failed();
          return;
        }
        final merged = {for (final p in participants) p.id: p};
        for (final id in data['removed'] as List? ?? []) {
          merged.remove(id);
        }
        for (final raw in data['participants'] as List? ?? []) {
          final p = PresencePerson.parse(raw);
          if (p != null) merged[p.id] = p;
        }
        participants.assignAll(merged.values);
        version = nextVersion;
      }
    } catch (_) {
      failed();
    }
  }

  void interact() {
    if (wire?.visible == true) sendState(interacted: true);
  }

  void sendState({bool interacted = false, bool heartbeat = false}) {
    if (!available.value || wire == null) return;
    wire!.send(
      jsonEncode({
        'type': heartbeat ? 'heartbeat' : 'state',
        'destination': section,
        'visible': wire!.visible,
        'interacted': interacted,
      }),
    );
  }

  void failed() {
    if (disposed) return;
    disconnect();
    if (account != null && supported) {
      final seconds = min(30, 1 << min(attempt++, 5));
      retry = Timer(
        Duration(milliseconds: seconds * 1000 + Random().nextInt(700)),
        start,
      );
    }
  }

  void disconnect({bool bye = false}) {
    generation++;
    retry?.cancel();
    heartbeat?.cancel();
    authTimeout?.cancel();
    if (bye && available.value) wire?.send('{"type":"bye"}');
    messages?.cancel();
    visibility?.cancel();
    interactions?.cancel();
    wire?.close();
    wire = null;
    version = -1;
    available.value = false;
  }

  Map<String, dynamic> get sceneState => {
    'available': available.value,
    'self': self,
    'participants': available.value
        ? participants.map((p) => p.toJson()).toList()
        : <dynamic>[],
  };
  @override
  void onClose() {
    disposed = true;
    userWatch?.dispose();
    disconnect(bye: true);
    privateEvents.close();
    super.onClose();
  }
}
