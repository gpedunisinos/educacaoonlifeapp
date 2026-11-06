import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/participant_chat/participant_chat_service.dart';
import 'package:unisinos_usp_app/widgets/participant_chat_panel.dart';

final sampleConversation = <String, dynamic>{
  'id': 'conversation-1',
  'name': 'Bruna',
  'activity': 'Explorando pistas',
  'online': true,
  'preview': 'Olá',
  'unread': 1,
  'updated_at': '2026-10-21T12:00:00Z',
};

class ChatApiFixture extends ParticipantChatApi {
  bool fail = false;
  final sends = <String>[];
  final clients = <String>[];
  int reads = 0;
  final stored = <Map<String, dynamic>>[
    {
      'id': 1,
      'conversation_id': 'conversation-1',
      'text': 'Olá 😊',
      'own': false,
      'created_at': '2026-10-21T12:00:00Z',
    },
  ];
  @override
  Future<Map<String, dynamic>> inbox(int offset) async => {
    'conversations': [sampleConversation],
    'has_more': false,
    'unread': reads > 0 ? 0 : 1,
  };
  @override
  Future<Map<String, dynamic>> open(String participant) async =>
      sampleConversation;
  @override
  Future<Map<String, dynamic>> messages(String id, {int? before}) async => {
    'messages': List.of(stored),
    'has_more': false,
  };
  @override
  Future<Map<String, dynamic>> send(
    String id,
    String text,
    String clientID,
  ) async {
    clients.add(clientID);
    if (fail) throw Exception('offline');
    sends.add(text);
    final row = <String, dynamic>{
      'id': stored.length + 1,
      'conversation_id': id,
      'text': text,
      'own': true,
      'created_at': '2026-10-21T12:01:00Z',
    };
    stored.add(row);
    return row;
  }

  @override
  Future<void> read(String id, int through) async {
    reads++;
  }
}

const account = AuthUser(
  id: 1,
  name: 'Ana',
  email: 'synthetic@example.test',
  token: 'test',
);
void main() {
  test(
    'confirmed block updates the open conversation even outside the first page',
    () {
      final chat = ParticipantChatService(api: ChatApiFixture());
      final conversation = ParticipantConversation.fromJson(sampleConversation);
      chat.active.value = conversation;
      chat.conversations.add(conversation);
      chat.confirmOwnBlock(conversation.id, blocked: true);
      expect(chat.active.value!.blocked, isTrue);
      expect(chat.active.value!.blockedByMe, isTrue);
      expect(chat.conversations.single.blocked, isTrue);
      chat.confirmOwnBlock(conversation.id, blocked: false);
      expect(chat.active.value!.blocked, isFalse);
      chat.onClose();
    },
  );
  testWidgets(
    'blocked conversations disable sending and hide messages from the blocked participant',
    (tester) async {
      final api = ChatApiFixture();
      final chat = ParticipantChatService(api: api);
      chat.account = account;
      final conversation = ParticipantConversation.fromJson({
        ...sampleConversation,
        'blocked': true,
        'blocked_by_me': false,
      });
      chat.active.value = conversation;
      chat.texts.add(ParticipantText.fromJson(api.stored.first));
      await chat.loadMessages();
      expect(chat.texts, isEmpty);
      expect(await chat.send('Não deve ser enviada'), isFalse);
      expect(api.sends, isEmpty);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ParticipantChatPanel(service: chat)),
        ),
      );
      await tester.pump();
      expect(
        find.text('As mensagens desta conversa não estão disponíveis.'),
        findsOneWidget,
      );
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      expect(find.byTooltip('Desbloquear conversa'), findsNothing);
      chat.onClose();
    },
  );
  testWidgets(
    'conversation sends text and emoji, keeps draft on failure and retries without duplication',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final api = ChatApiFixture(),
          service = ParticipantChatService(api: ChatApiFixture());
      final chat = ParticipantChatService(api: api);
      chat.setAccount(account);
      chat.panelOpen = true;
      await chat.openParticipant('opaque-peer');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 520,
              height: 800,
              child: ParticipantChatPanel(service: chat),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Bruna'), findsOneWidget);
      expect(find.text('Olá 😊'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Vamos explorar');
      await tester.tap(find.byTooltip('Escolher emoji'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('🚀'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        contains('🚀'),
      );
      api.fail = true;
      await tester.tap(find.byTooltip('Enviar mensagem'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Seu texto foi mantido'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isNotEmpty,
      );
      api.fail = false;
      await tester.tap(find.byTooltip('Enviar mensagem'));
      await tester.pumpAndSettle();
      expect(api.sends, hasLength(1));
      expect(api.clients[0], api.clients[1]);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
      await chat.loadMessages();
      await tester.pumpAndSettle();
      expect(chat.texts.length, 2);
      chat.setAccount(null);
      await tester.pumpAndSettle();
      expect(find.text('Entre na plataforma para conversar.'), findsOneWidget);
      expect(find.text('Olá 😊'), findsNothing);
      expect(chat.drafts, isEmpty);
      chat.onClose();
      service.onClose();
    },
  );
  testWidgets(
    'mobile inbox and conversation remain usable with keyboard area',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 280);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final api = ChatApiFixture(),
          chat = ParticipantChatService(api: ChatApiFixture());
      chat.setAccount(account);
      await chat.refreshInbox();
      chat.panelOpen = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: ParticipantChatPanel(service: chat)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bruna'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Mensagem pelo teclado ✨');
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(chat.texts.last.text, 'Mensagem pelo teclado ✨');
      expect(tester.takeException(), isNull);
      chat.onClose();
      expect(api.reads, 0);
    },
  );
}
