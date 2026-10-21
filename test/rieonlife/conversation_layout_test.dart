import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_chat_controller.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_chat_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_message_model.dart';
import 'package:unisinos_usp_app/models/chat_message_model.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/models/living_clue_chat_message_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_chat_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_chat_screen.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_panel.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';

class PreviewAssistant extends AiAssistantController {
  final sent = <String>[];
  @override
  Future<void> ensureHistoryLoaded() async {}
  @override
  Future<void> sendMessage(String value) async {
    sent.add(value);
  }
}

class PreviewAgent extends ChatTemplateChatController {
  final sent = <String>[];
  @override
  // ignore: must_call_super
  void onInit() {}
  @override
  Future<void> sendMessage(String content) async {
    sent.add(content);
  }
}

class PreviewClue extends LivingClueChatController {
  final sent = <String>[];
  int clears = 0;
  @override
  // ignore: must_call_super
  void onInit() {}
  @override
  Future<void> sendMessage(String content) async {
    sent.add(content);
  }

  @override
  Future<void> clearMessages() async {
    clears++;
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(AiAssistantContextService());
  });
  tearDown(Get.reset);

  for (final size in [
    const Size(1280, 800),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    testWidgets('agent and clue conversations preserve history and fit $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final agent = PreviewAgent()..hasMore.value = false;
      agent.template.value = ChatTemplateModel(
        id: 1,
        name:
            'Agente com um nome muito extenso para explorar conexões e territórios',
        description:
            'Uma descrição longa que deve permanecer dentro do cabeçalho e preservar espaço para a conversa.',
      );
      agent.messages.add(
        ChatMessageModel(
          text: 'Histórico do agente preservado.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      Get.put<ChatTemplateChatController>(agent);
      await tester.pumpWidget(
        const GetMaterialApp(home: ChatTemplateChatScreen()),
      );
      await tester.pump();
      expect(find.text('Histórico do agente preservado.'), findsOneWidget);
      expect(find.byType(SpaceConversationSurface), findsOneWidget);
      expect(tester.takeException(), isNull);
      agent.isSending.value = true;
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Próxima pergunta');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pump();
      expect(agent.sent, isEmpty);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Próxima pergunta',
      );
      agent.isSending.value = false;
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send_rounded));
      expect(agent.sent, ['Próxima pergunta']);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      final clue = PreviewClue()..hasMore.value = false;
      clue.livingClue.value = LivingClueModel(
        id: 1,
        categoryId: 1,
        name: 'Pista com um título extenso para testar a sala de diálogo',
      );
      clue.messages.add(
        LivingClueChatMessageModel(
          text: 'Histórico exclusivo da pista.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      Get.put<LivingClueChatController>(clue);
      await tester.pumpWidget(
        const GetMaterialApp(home: LivingClueChatScreen()),
      );
      await tester.pump();
      expect(find.text('Histórico exclusivo da pista.'), findsOneWidget);
      expect(find.text('Histórico do agente preservado.'), findsNothing);
      expect(find.byTooltip('Limpar conversa'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'Iarete fits mobile keyboard and does not lose a draft while sending',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final assistant = PreviewAssistant();
      assistant.messages.add(
        AiAssistantMessageModel(
          role: 'assistant',
          content: 'Mensagem anterior preservada.',
          createdAt: DateTime.now(),
        ),
      );
      Get.put<AiAssistantController>(assistant);
      await tester.pumpWidget(
        const GetMaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: AiAssistantPanel(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Mensagem anterior preservada.'), findsOneWidget);
      expect(find.byTooltip('Fechar Iareté'), findsOneWidget);
      expect(tester.takeException(), isNull);
      assistant.isSending.value = true;
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'Rascunho para depois');
      await tester.testTextInput.receiveAction(TextInputAction.send);
      expect(assistant.sent, isEmpty);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Rascunho para depois',
      );
      assistant.isSending.value = false;
      await tester.pump();
      await tester.tap(find.text('Enviar'));
      expect(assistant.sent, ['Rascunho para depois']);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    },
  );

  testWidgets('cancel clearing the clue conversation preserves its history', (
    tester,
  ) async {
    final clue = PreviewClue()..hasMore.value = false;
    clue.livingClue.value = LivingClueModel(
      id: 1,
      categoryId: 1,
      name: 'Pista',
    );
    Get.put<LivingClueChatController>(clue);
    await tester.pumpWidget(const GetMaterialApp(home: LivingClueChatScreen()));
    await tester.pump();
    await tester.tap(find.byTooltip('Limpar conversa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(clue.clears, 0);
  });
}
