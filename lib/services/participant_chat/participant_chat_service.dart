import 'dart:async';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';

class ParticipantConversation {
  ParticipantConversation._({
    required this.id,
    required this.name,
    required this.activity,
    required this.online,
    required this.blocked,
    required this.blockedByMe,
    required this.preview,
    required this.unread,
    required this.updatedAt,
  });
  ParticipantConversation.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      name = j['name'],
      activity = j['activity'],
      online = j['online'] == true,
      blocked = j['blocked'] == true,
      blockedByMe = j['blocked_by_me'] == true,
      preview = j['preview'] ?? '',
      unread = j['unread'] ?? 0,
      updatedAt = DateTime.tryParse(j['updated_at'] ?? '');
  final String id, name, activity, preview;
  final DateTime? updatedAt;
  final bool online;
  final bool blocked, blockedByMe;
  final int unread;

  ParticipantConversation withBlockState(bool blocked, bool blockedByMe) =>
      ParticipantConversation._(
        id: id,
        name: name,
        activity: activity,
        online: online,
        blocked: blocked,
        blockedByMe: blockedByMe,
        preview: preview,
        unread: unread,
        updatedAt: updatedAt,
      );
}

class ParticipantText {
  ParticipantText.fromJson(Map<String, dynamic> j)
    : id = j['id'],
      text = j['text'],
      own = j['own'] == true,
      createdAt = DateTime.tryParse(j['created_at'] ?? '')?.toLocal();
  final int id;
  final String text;
  final bool own;
  final DateTime? createdAt;
}

class ParticipantChatApi {
  final api = EconectivaApi();
  Future<Map<String, dynamic>> inbox(int offset) async =>
      Map<String, dynamic>.from(
        await api.get('/me/conversations', {'offset': '$offset'}),
      );
  Future<Map<String, dynamic>> open(String participant) async =>
      Map<String, dynamic>.from(
        await api.write('POST', '/me/conversations', {
          'participant': participant,
        }),
      );
  Future<Map<String, dynamic>> messages(String id, {int? before}) async =>
      Map<String, dynamic>.from(
        await api.get('/me/conversations/$id/messages', {
          if (before != null) 'before': '$before',
        }),
      );
  Future<Map<String, dynamic>> send(
    String id,
    String text,
    String clientID,
  ) async => Map<String, dynamic>.from(
    await api.write('POST', '/me/conversations/$id/messages', {
      'text': text,
      'client_id': clientID,
    }),
  );
  Future<void> read(String id, int through) async {
    await api.write('POST', '/me/conversations/$id/read', {'through': through});
  }
}

class ParticipantChatService extends GetxService {
  ParticipantChatService({ParticipantChatApi? api})
    : api = api ?? ParticipantChatApi();
  final ParticipantChatApi api;
  final conversations = <ParticipantConversation>[].obs;
  final texts = <ParticipantText>[].obs;
  final active = Rxn<ParticipantConversation>();
  final unread = 0.obs,
      loading = false.obs,
      loadingMessages = false.obs,
      sending = false.obs;
  final error = RxnString(), messageError = RxnString();
  final drafts = <String, String>{};
  final retries = <String, ({String text, String id})>{};
  bool moreInbox = false, moreMessages = false, panelOpen = false;
  int accountGeneration = 0, inboxGeneration = 0, messageGeneration = 0;
  AuthUser? account;
  PresenceService? presence;
  Worker? accountWatch;
  StreamSubscription<Map<String, dynamic>>? notifications;
  Timer? poll;
  bool disposed = false;
  void attach(UserController users, PresenceService p) {
    presence = p;
    accountWatch = ever(users.user, setAccount);
    setAccount(users.user.value);
    notifications = p.privateEvents.stream.listen((event) {
      refreshInbox();
      if (event['type'] != 'chat-read' &&
          panelOpen &&
          active.value != null &&
          (event['type'] != 'chat' ||
              event['conversation_id'] == active.value!.id))
        loadMessages();
    });
    poll = Timer.periodic(const Duration(seconds: 20), (_) {
      if (account == null || p.wire?.visible == false) return;
      refreshInbox();
      if (panelOpen && active.value != null) loadMessages();
    });
  }

  void setAccount(AuthUser? next) {
    if (next?.id == account?.id && next?.token == account?.token) return;
    accountGeneration++;
    inboxGeneration++;
    messageGeneration++;
    account = next;
    conversations.clear();
    texts.clear();
    active.value = null;
    drafts.clear();
    retries.clear();
    unread.value = 0;
    error.value = null;
    messageError.value = null;
    sending.value = false;
    loading.value = false;
    loadingMessages.value = false;
    if (next != null) refreshInbox();
  }

  Future<void> refreshInbox({bool more = false}) async {
    if (account == null || disposed) return;
    final request = ++inboxGeneration, epoch = accountGeneration;
    if (conversations.isEmpty) loading.value = true;
    try {
      final result = await api.inbox(more ? conversations.length : 0);
      if (disposed || epoch != accountGeneration || request != inboxGeneration)
        return;
      final rows = (result['conversations'] as List)
          .map(
            (j) =>
                ParticipantConversation.fromJson(Map<String, dynamic>.from(j)),
          )
          .toList();
      final all = [...conversations, ...rows];
      final merged = {for (final c in all) c.id: c}.values.toList()
        ..sort(
          (a, b) => (b.updatedAt ?? DateTime(1970)).compareTo(
            a.updatedAt ?? DateTime(1970),
          ),
        );
      conversations.assignAll(merged);
      moreInbox = result['has_more'] == true;
      unread.value = result['unread'] ?? 0;
      error.value = null;
      final selected = active.value;
      if (selected != null)
        for (final c in rows) {
          if (c.id == selected.id) {
            active.value = c;
            if (c.blocked && !c.blockedByMe) {
              messageGeneration++;
              texts.clear();
              loadingMessages.value = false;
            }
          }
        }
    } catch (_) {
      if (epoch == accountGeneration && request == inboxGeneration)
        error.value =
            'Não foi possível carregar as conversas. Tente novamente.';
    } finally {
      if (epoch == accountGeneration && request == inboxGeneration)
        loading.value = false;
    }
  }

  Future<void> openParticipant(String participant) async {
    final epoch = accountGeneration;
    loading.value = true;
    error.value = null;
    try {
      final result = await api.open(participant);
      if (disposed || epoch != accountGeneration) return;
      final c = ParticipantConversation.fromJson(result);
      conversations.removeWhere((item) => item.id == c.id);
      conversations.insert(0, c);
      await select(c);
    } catch (_) {
      if (epoch == accountGeneration)
        error.value =
            'Não foi possível abrir a conversa. O participante pode ter saído do espaço. Atualize a lista e tente novamente.';
    } finally {
      if (epoch == accountGeneration) loading.value = false;
    }
  }

  Future<void> select(ParticipantConversation c) async {
    messageGeneration++;
    active.value = c;
    texts.clear();
    messageError.value = null;
    moreMessages = false;
    await loadMessages();
  }

  void inbox() {
    messageGeneration++;
    active.value = null;
    texts.clear();
    messageError.value = null;
    refreshInbox();
  }

  void confirmOwnBlock(String conversationId, {required bool blocked}) {
    inboxGeneration++;
    for (var i = 0; i < conversations.length; i++) {
      if (conversations[i].id == conversationId) {
        conversations[i] = conversations[i].withBlockState(blocked, blocked);
      }
    }
    final current = active.value;
    if (current?.id == conversationId) {
      active.value = current!.withBlockState(blocked, blocked);
      messageError.value = null;
    }
  }

  Future<void> loadMessages({bool older = false}) async {
    final c = active.value;
    if (c == null || account == null || disposed) return;
    if (c.blocked && !c.blockedByMe) {
      texts.clear();
      return;
    }
    final epoch = accountGeneration, request = ++messageGeneration;
    if (texts.isEmpty) loadingMessages.value = true;
    try {
      final result = await api.messages(
        c.id,
        before: older && texts.isNotEmpty ? texts.first.id : null,
      );
      if (disposed ||
          epoch != accountGeneration ||
          request != messageGeneration ||
          active.value?.id != c.id)
        return;
      final rows = (result['messages'] as List)
          .map((j) => ParticipantText.fromJson(Map<String, dynamic>.from(j)))
          .toList();
      final all = older ? [...rows, ...texts] : [...texts, ...rows];
      final merged = {for (final m in all) m.id: m}.values.toList()
        ..sort((a, b) => a.id.compareTo(b.id));
      texts.assignAll(merged);
      if (older || texts.length <= 30)
        moreMessages = result['has_more'] == true;
      messageError.value = null;
      if (panelOpen && presence?.wire?.visible != false && texts.isNotEmpty) {
        await api.read(c.id, texts.last.id);
        if (epoch == accountGeneration) refreshInbox();
      }
    } catch (error) {
      if (epoch == accountGeneration) refreshInbox();
      if (epoch == accountGeneration &&
          request == messageGeneration &&
          error.toString().contains('O participante bloqueou esta conversa.')) {
        texts.clear();
        active.value = c.withBlockState(true, false);
        messageError.value = null;
      } else if (epoch == accountGeneration && request == messageGeneration)
        messageError.value =
            'Não foi possível carregar as mensagens. Tente novamente.';
    } finally {
      if (epoch == accountGeneration && request == messageGeneration)
        loadingMessages.value = false;
    }
  }

  Future<bool> send(String value) async {
    final c = active.value, text = value.trim();
    if (c == null ||
        account == null ||
        text.isEmpty ||
        text.runes.length > 2000 ||
        sending.value ||
        c.blocked)
      return false;
    final epoch = accountGeneration;
    final previous = retries[c.id];
    final clientID = previous?.text == text ? previous!.id : const Uuid().v4();
    retries[c.id] = (text: text, id: clientID);
    sending.value = true;
    messageError.value = null;
    try {
      final result = await api.send(c.id, text, clientID);
      if (disposed || epoch != accountGeneration) return false;
      retries.remove(c.id);
      drafts.remove(c.id);
      if (active.value?.id == c.id) {
        final m = ParticipantText.fromJson(result);
        texts.removeWhere((x) => x.id == m.id);
        texts.add(m);
        texts.sort((a, b) => a.id.compareTo(b.id));
      }
      refreshInbox();
      return true;
    } catch (_) {
      if (epoch == accountGeneration) refreshInbox();
      if (epoch == accountGeneration)
        messageError.value =
            'Não foi possível enviar. Seu texto foi mantido; aguarde um pouco e tente novamente.';
      return false;
    } finally {
      if (epoch == accountGeneration) sending.value = false;
    }
  }

  @override
  void onClose() {
    disposed = true;
    accountGeneration++;
    accountWatch?.dispose();
    notifications?.cancel();
    poll?.cancel();
    super.onClose();
  }
}
