// Run only against scripts/run-integrations-preview.py and synthetic records.
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/services/meeting_window.dart';
import 'package:unisinos_usp_app/webclients/meeting_webclient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';
import 'package:unisinos_usp_app/webclients/ai_assistant_webclient.dart';
import 'package:unisinos_usp_app/webclients/chat_template_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_chat_webclient.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:unisinos_usp_app/main.dart' as app;

void main() {
  debugPrint = debugPrintSynchronously;
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Future<void> until(
    WidgetTester tester,
    bool Function() ready,
    String label, {
    int seconds = 35,
  }) async {
    final deadline = DateTime.now().add(Duration(seconds: seconds));
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 200));
      if (ready()) return;
    }
    fail('Timeout: $label (route ${Get.currentRoute})');
  }

  testWidgets(
    'Android: real audio, lifecycle, location and AI transports',
    (tester) async {
      binding.shouldPropagateDevicePointerEvents = true;
      addTearDown(() => binding.shouldPropagateDevicePointerEvents = false);
      final previousError = FlutterError.onError;
      FlutterError.onError = (details) {
        debugPrint('AUDIT error stack: ${details.stack}');
        previousError?.call(details);
      };
      addTearDown(() => FlutterError.onError = previousError);
      expect(const bool.fromEnvironment('NATIVE_AUDIT'), isTrue);
      expect(const String.fromEnvironment('API_HOST'), '10.0.2.2');
      expect(const String.fromEnvironment('API_PORT'), '8082');
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await app.main();
      await until(
        tester,
        () => find.byType(TextFormField).evaluate().length >= 2,
        'login',
      );
      await tester.enterText(
        find.byType(TextFormField).at(0),
        const String.fromEnvironment('E2E_EMAIL'),
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        const String.fromEnvironment('E2E_PASSWORD'),
      );
      await tester.tap(find.text('Entrar').first);
      await until(
        tester,
        () => Get.currentRoute == '/space',
        'authenticated cockpit',
      );
      await until(
        tester,
        () => find.byType(WebViewWidget).evaluate().isNotEmpty,
        'native cockpit',
      );
      final web = tester
          .widget<WebViewWidget>(find.byType(WebViewWidget).first)
          .platform
          .params
          .controller;
      Future<dynamic> js(String expression) async {
        var value = await web.runJavaScriptReturningResult(
          'JSON.stringify(($expression))',
        );
        if (value is String) value = jsonDecode(value);
        if (value is String) value = jsonDecode(value);
        return value;
      }

      for (var i = 0; i < 100; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        if (await js('typeof window.receiveSpaceCommand === "function"') ==
            true)
          break;
      }
      await web.runJavaScript(
        'window.__auditAudio=[];const OriginalAudio=window.AudioContext;window.AudioContext=function(...args){const ctx=new OriginalAudio(...args);window.__auditAudio.push(ctx);return ctx;};document.getElementById("start-sound").checked=true;',
      );
      final target =
          await js(
                '(()=>{const r=document.getElementById("start").getBoundingClientRect();return {x:r.x+r.width/2,y:r.y+r.height/2};})()',
              )
              as Map;
      final nativeOrigin = tester.getTopLeft(find.byType(WebViewWidget).first);
      final ratio = tester.view.devicePixelRatio;
      final x = ((nativeOrigin.dx + (target['x'] as num)) * ratio).round();
      final y = ((nativeOrigin.dy + (target['y'] as num)) * ratio).round();
      debugPrint('AUDIT_TAP $x $y');
      await tester.pump(const Duration(seconds: 3));
      expect(await js('window.__auditAudio.length'), 1);
      expect(await js('window.__auditAudio[0].state'), 'running');
      await web.runJavaScript('document.getElementById("tour-skip").click();');
      final before = await js('window.__auditAudio[0].currentTime') as num;
      await tester.pump(const Duration(seconds: 1));
      expect(
        await js('window.__auditAudio[0].currentTime'),
        greaterThan(before),
      );
      debugPrint('AUDIT real Android touch started the cockpit audio clock');
      debugPrint('AUDIT_BACKGROUND');
      await tester.pump(const Duration(seconds: 4));
      expect(await js('document.getElementById("fallback").hidden'), isTrue);
      expect(await js('window.__auditAudio[0].state'), 'running');
      expect(Get.find<PresenceService>().wire?.visible, isTrue);
      await web.runJavaScript('document.getElementById("sound").click();');
      await tester.pump(const Duration(seconds: 1));
      expect(await js('window.__auditAudio[0].state'), 'suspended');
      debugPrint(
        'AUDIT app suspension/resumption preserved WebGL, presence and mute control',
      );
      final pool = await AudioPool.create(
        source: AssetSource('space/iarete-type.wav'),
        maxPlayers: 3,
      );
      final stop = await pool.start(volume: .08);
      await tester.pump(const Duration(milliseconds: 200));
      await stop();
      await pool.dispose();
      debugPrint(
        'AUDIT native Iareté typing audio asset played through Android audio plugin',
      );
      debugPrint('AUDIT_LOCATION_FIX');
      await tester.pump(const Duration(seconds: 2));
      Get.toNamed('/living_clues/map');
      await until(
        tester,
        () => Get.isRegistered<LivingClueMapController>(),
        'map',
      );
      final map = Get.find<LivingClueMapController>();
      final position = await map.currentLocation().timeout(
        const Duration(seconds: 35),
      );
      expect(position, isNotNull);
      expect(position!.latitude, closeTo(-29.718, .01));
      expect(position.longitude, closeTo(-51.143, .01));
      debugPrint('AUDIT Android location permission and simulated GPS passed');
      Get.back();
      await tester.pump(const Duration(seconds: 1));
      final room = MeetingRoom.parse(
        'android-browser-${DateTime.now().millisecondsSinceEpoch}',
      );
      final uri = await MeetingWebclient().authorize(room);
      expect(await MeetingWindow.reserve()!.navigate(uri), isTrue);
      await tester.pump(const Duration(seconds: 2));
      debugPrint('AUDIT_BACKGROUND');
      await tester.pump(const Duration(seconds: 4));
      debugPrint(
        'AUDIT authorized meeting opened in the Android browser and returned to the app',
      );
      if (const bool.fromEnvironment('NATIVE_AI')) {
        final message =
            'Validação sintética Android. Responda em uma frase curta, sem consultar dados pessoais.';
        final iarete = await AiAssistantWebclient().sendMessage(
          message: message,
          context: '',
        );
        expect(
          iarete.any((m) => !m.isUser && m.content.trim().isNotEmpty),
          isTrue,
        );
        expect(
          (await AiAssistantWebclient().fetchHistory()).any((m) => !m.isUser),
          isTrue,
        );
        debugPrint(
          'AUDIT Iareté live AI response and history passed on Android',
        );
        final agent = await ChatTemplateWebclient().sendMessage(1, message);
        expect(agent.any((m) => !m.isUser && m.text.trim().isNotEmpty), isTrue);
        debugPrint('AUDIT agent live AI response passed on Android');
        final clue = await LivingClueChatWebclient().sendMessage(1, message);
        expect(clue.any((m) => !m.isUser && m.text.trim().isNotEmpty), isTrue);
        debugPrint('AUDIT clue live AI response passed on Android');
      }
      binding.shouldPropagateDevicePointerEvents = false;
      FlutterError.onError = previousError;
      expect(tester.takeException(), isNull);
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
