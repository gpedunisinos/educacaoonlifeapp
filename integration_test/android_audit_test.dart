// Run only against scripts/run-integrations-preview.py and synthetic records.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:unisinos_usp_app/main.dart' as app;

void main() {
  debugPrint = debugPrintSynchronously;
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
    'Android: login, real WebView cockpit and native module routes',
    (tester) async {
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
        'native WebView',
      );
      final view = tester
          .widget<WebViewWidget>(find.byType(WebViewWidget).first)
          .platform
          .params
          .controller;
      bool loaded = false;
      for (var i = 0; i < 80; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        final raw = await view.runJavaScriptReturningResult(
          'JSON.stringify({ready:typeof window.receiveSpaceCommand === "function",title:document.title,error:document.getElementById("fallback")?.hidden === false})',
        );
        var value = raw is String ? jsonDecode(raw) : raw;
        if (value is String) value = jsonDecode(value);
        if (value is Map && value['ready'] == true) {
          loaded = true;
          debugPrint('AUDIT cockpit ready: $value');
          break;
        }
      }
      expect(
        loaded,
        isTrue,
        reason: 'Bundled scene must load in the Android WebView',
      );
      await view.runJavaScript(
        'document.getElementById("start-sound").checked=false;document.getElementById("start").click();',
      );
      await tester.pump(const Duration(seconds: 2));
      debugPrint('AUDIT cockpit started');

      // Real bridge and real WebGL scene: startup, tutorial, destination selection,
      // flight completion and return from each module without replacing the scene.
      Future<dynamic> js(String code) async {
        var value = await view.runJavaScriptReturningResult(
          'JSON.stringify(($code))',
        );
        if (value is String) value = jsonDecode(value);
        if (value is String) value = jsonDecode(value);
        return value;
      }

      await view.runJavaScript('document.getElementById("tour-skip").click();');
      expect(await js('document.getElementById("fallback").hidden'), isTrue);
      await until(
        tester,
        () => Get.find<PresenceService>().available.value,
        'native WebSocket',
      );
      debugPrint('AUDIT native presence connected');
      for (final destination in [
        'earth',
        'research',
        'observatory',
        'agents',
      ]) {
        await view.runJavaScript(
          'document.querySelector("[data-destination=$destination]").click();',
        );
        final previous = Get.find<PresenceService>().section;
        await tester.pump(const Duration(milliseconds: 350));
        expect(
          Get.find<PresenceService>().section,
          previous,
          reason: 'Selecting a destination must not travel',
        );
        await view.runJavaScript(
          'document.getElementById("navigate").click();',
        );
        await tester.pump(const Duration(seconds: 1));
        expect(Get.find<PresenceService>().section, 'cockpit');
        if (destination != 'earth') {
          await view.runJavaScript('document.getElementById("skip").click();');
        }
        await until(
          tester,
          () => Get.find<PresenceService>().section == destination,
          'arrival at $destination',
        );
        await tester.pump(const Duration(seconds: 1));
        expect(
          await js('document.getElementById("local-name").textContent'),
          isNotEmpty,
        );
        debugPrint('AUDIT_CAPTURE cockpit-$destination');
        await tester.pump(const Duration(seconds: 2));
        await view.runJavaScript(
          'document.getElementById("local-open").click();',
        );
        await until(
          tester,
          () => Get.currentRoute != '/space',
          'open module $destination',
        );
        await tester.pump(const Duration(seconds: 2));
        expect(
          tester.takeException(),
          isNull,
          reason: 'module $destination must lay out without errors',
        );
        debugPrint('AUDIT bridge opened $destination at ${Get.currentRoute}');
        debugPrint('AUDIT_CAPTURE module-$destination');
        await tester.pump(const Duration(seconds: 2));
        Get.back();
        await until(
          tester,
          () => Get.currentRoute == '/space',
          'return from $destination',
        );
        await tester.pump(const Duration(seconds: 1));
        expect(Get.find<PresenceService>().section, destination);
      }
      debugPrint('AUDIT all four flights and module returns passed');
      final routes = <String, Object?>{
        '/space/research': null,
        '/space/research/1': null,
        '/space/agents': null,
        '/space/agents/1': null,
        '/living_clues': null,
        '/living_clues/map': null,
        '/living_clues/1': null,
        '/living_clues/1/chat': null,
        '/living_clues/type_select': null,
        '/living_clues/pre_create': {
          'categoryId': 1,
          'categoryName': 'Laboratório de integrações',
          'metadataTags': 'observacao',
        },
        '/living_clues/map/create': null,
        '/living_clues/create': {
          'categoryId': 2,
          'categoryName': 'Vivência de Cidadania Digital',
          'metadataTags': 'cidade,praticas_inventivas,metodologias_inventivas',
        },
        '/living_clues/update?id=1': null,
        '/living_clues/connect': await LivingClueWebclient().fetchById(1),
        '/nodes/graph': null,
        '/management': null,
        '/management/connections': null,
        '/management/connections/1': null,
        '/categories': null,
        '/categories/create': null,
        '/categories/update?id=1': null,
        '/connection_types': null,
        '/connection_types/create': null,
        '/connection_types/update?id=1': null,
        '/nodes': null,
        '/nodes/create': null,
        '/nodes/update?id=1': null,
        '/node_types': null,
        '/node_types/create': null,
        '/node_types/update?id=1': null,
        '/node_links': null,
        '/node_links/create': null,
        '/node_links/update?id=1': null,
        '/clue_connections': null,
        '/clue_connections/create': null,
        '/clue_connections/update?id=1': null,
        '/chat_templates': null,
        '/chat_templates/create': null,
        '/chat_templates/update?id=1': null,
        '/chat_templates/chat?id=1': null,
        '/users': null,
        '/users/create': null,
        '/users/update?id=2': null,
      };
      final errors = <String>[];
      for (final entry in routes.entries) {
        debugPrint('AUDIT open ${entry.key}');
        Get.toNamed(
          entry.key,
          arguments: entry.value,
          preventDuplicates: false,
        );
        for (var frame = 0; frame < 18; frame++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
        Object? error;
        while ((error = tester.takeException()) != null) {
          errors.add('${entry.key}: $error');
        }
        debugPrint('AUDIT rendered ${entry.key} at ${Get.currentRoute}');
        if ([
          '/living_clues/update?id=1',
          '/management',
          '/space/agents/1',
          '/nodes/graph',
        ].contains(entry.key)) {
          debugPrint(
            'AUDIT_CAPTURE route-${entry.key.replaceAll(RegExp(r"[^a-zA-Z0-9]"), "-")}',
          );
          await tester.pump(const Duration(seconds: 2));
        }
        if (Get.isDialogOpen == true) Get.back();
        Get.until((route) => route.settings.name == '/space');
        await tester.pump(const Duration(seconds: 1));
      }
      expect(errors, isEmpty, reason: errors.join('\n'));
      final problem = tester.takeException();
      expect(problem, isNull);
    },
    timeout: const Timeout(Duration(minutes: 15)),
  );
}
