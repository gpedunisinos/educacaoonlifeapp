import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/iarete_voice/voice_conversation.dart';
import 'package:unisinos_usp_app/services/ship_audio_preferences.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_panel.dart';
import 'voice_conversation_test.dart'
    show TestRecorder, TestVoiceApi, TestPlayer, voiceReply;

class _Assistant extends AiAssistantController {
  @override
  Future<void> ensureHistoryLoaded() async {}
}

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    await ShipAudioPreferences.setEnabled(false);
    Get.put(AiAssistantContextService());
    Get.put<AiAssistantController>(_Assistant());
  });
  tearDown(Get.reset);
  for (final size in [
    const Size(390, 844),
    const Size(844, 390),
    const Size(1280, 800),
  ]) {
    testWidgets('recording and review fit $size with readable actions', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final recorder = TestRecorder();
      final api = TestVoiceApi();
      var sends = 0;
      final voice = VoiceConversation(
        recorder: recorder,
        api: api,
        player: TestPlayer(),
        sendText: (_) async {
          sends++;
          return voiceReply();
        },
      );
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(body: AiAssistantPanel(voice: voice)),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Falar com Iareté'));
      await tester.pump();
      expect(find.text('Parar e revisar'), findsOneWidget);
      recorder.feed();
      await tester.pump();
      await tester.tap(find.text('Parar e revisar'));
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      });
      await tester.pump();
      expect(find.text('Enviar áudio'), findsOneWidget);
      expect(find.byTooltip('Ouvir gravação'), findsOneWidget);
      expect(api.transcriptions, 0);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Enviar áudio'));
      await tester.pump();
      await tester.pump();
      expect(sends, 1);
      expect(api.transcriptions, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    });
  }
}
