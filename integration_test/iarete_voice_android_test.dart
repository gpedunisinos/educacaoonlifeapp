// Isolated native audio validation. Provider replies and chat are synthetic;
// microphone capture, permissions and WAV playback use the real Android plugins.
import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_message_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/iarete_voice/voice_api.dart';
import 'package:unisinos_usp_app/services/iarete_voice/voice_conversation.dart';
import 'package:unisinos_usp_app/services/iarete_voice/voice_devices.dart';
import 'package:unisinos_usp_app/services/ship_audio_preferences.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_panel.dart';

Uint8List _tone() {
  final data = ByteData(32000);
  for (var i = 0; i < 16000; i++) {
    data.setInt16(
      i * 2,
      (math.sin(i * 2 * math.pi * 440 / 16000) * 2000).round(),
      Endian.little,
    );
  }
  return pcmToVoiceWav(data.buffer.asUint8List());
}

class _Api implements VoiceApi {
  int transcribed = 0, spoken = 0;
  @override
  Future<String> transcribe(Uint8List wav) async {
    expect(wav.length, greaterThan(16044));
    transcribed++;
    return 'Como conhecer a Lua de Pistas?';
  }

  @override
  Future<Uint8List> speech(int messageId) async {
    spoken++;
    return _tone();
  }

  @override
  void close() {}
}

class _Assistant extends AiAssistantController {
  @override
  Future<void> ensureHistoryLoaded() async {}
  @override
  Future<AiAssistantMessageModel?> sendWithResult(String value) async {
    messages.add(
      AiAssistantMessageModel(
        role: 'user',
        content: value,
        createdAt: DateTime.now(),
      ),
    );
    final reply = AiAssistantMessageModel(
      id: 10,
      role: 'assistant',
      content:
          'Conecte-se à Lua de Pistas para conhecer as pistas cadastradas.',
      createdAt: DateTime.now(),
    );
    messages.add(reply);
    return reply;
  }
}

void main() {
  debugPrint = debugPrintSynchronously;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'Iarete records, reviews, sends, speaks and interrupts on Android',
    (tester) async {
      expect(const bool.fromEnvironment('NATIVE_AUDIT'), isTrue);
      Get.testMode = true;
      SharedPreferences.setMockInitialValues({});
      await ShipAudioPreferences.setEnabled(true);
      Get.put(AiAssistantContextService());
      final assistant = Get.put<AiAssistantController>(_Assistant());
      final api = _Api();
      final voice = VoiceConversation(
        sendText: assistant.sendWithResult,
        api: api,
      );
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: AiAssistantPanel(voice: voice),
          ),
        ),
      );
      Future<void> frames(int n) async {
        for (var i = 0; i < n; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      await frames(10);
      debugPrint('AUDIT_MIC_PERMISSION');
      await frames(15);
      await tester.tap(find.text('Falar com Iareté'));
      await frames(30);
      expect(voice.stage, VoiceStage.recording);
      debugPrint('AUDIT_CAPTURE voice-recording');
      await frames(12);
      await tester.tap(find.text('Parar e revisar'));
      await frames(10);
      expect(voice.stage, VoiceStage.review);
      expect(voice.recording!.length, greaterThan(16044));
      expect(api.transcribed, 0);
      debugPrint('AUDIT native microphone PCM captured and review kept local');
      debugPrint('AUDIT_CAPTURE voice-review');
      await frames(5);
      await tester.tap(find.byTooltip('Ouvir gravação'));
      await frames(4);
      expect(voice.playing, isTrue);
      await voice.stopPlayback();
      await tester.tap(find.text('Enviar áudio'));
      await frames(3);
      expect(api.transcribed, 1);
      expect(api.spoken, 1);
      expect(assistant.messages.length, 2);
      expect(voice.playing, isTrue);
      debugPrint('AUDIT native WAV reply playback active (synthetic provider)');
      debugPrint('AUDIT_CAPTURE voice-reply');
      for (var i = 0; i < 60 && voice.playing; i++) {
        await frames(1);
      }
      expect(voice.playing, isFalse);
      await voice.speak(10, manual: true);
      await frames(2);
      expect(voice.playing, isTrue);
      await voice.setEnabled(false);
      expect(voice.playing, isFalse);
      await tester.tap(find.text('Falar com Iareté'));
      await frames(12);
      expect(voice.stage, VoiceStage.recording);
      await tester.tap(find.text('Cancelar'));
      await frames(3);
      expect(voice.recording, isNull);
      expect(api.transcribed, 1);
      await tester.pumpWidget(const SizedBox());
      await frames(3);
      Get.reset();
      expect(tester.takeException(), isNull);
      debugPrint(
        'AUDIT voice native capture preview reply mute cancel close passed',
      );
    },
  );
}
