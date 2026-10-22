// Run only against scripts/run-integrations-preview.py and synthetic records.
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:unisinos_usp_app/webclients/file_webclient.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';

import 'package:unisinos_usp_app/main.dart' as app;

void main() {
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
    'Android: native persistence, attachments, metadata and administrative flows',
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

      final api = EconectivaApi();
      final clues = LivingClueWebclient();
      final stamp = DateTime.now().millisecondsSinceEpoch;
      final name = 'Pista Android sintética $stamp';
      Future<void> backToShip() async {
        Get.until((route) => route.settings.name == '/space');
        await tester.pump(const Duration(seconds: 1));
      }

      Finder field(String name) => find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is ManagementInput && w.hintText == name,
        ),
        matching: find.byType(TextFormField),
      );
      Get.toNamed(
        '/living_clues/create',
        arguments: {
          'categoryId': 1,
          'categoryName': 'Laboratório de integrações',
          'metadataTags': 'observacao',
        },
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.enterText(field('Nome'), name);
      await tester.enterText(
        field('Observacao'),
        'Registro sintético escrito no Android.',
      );
      tester.testTextInput.hide();
      final save = find.byWidgetPredicate(
        (w) => w is ActionButton && w.title == 'Salvar',
      );
      await tester.ensureVisible(save);
      await tester.tap(save);
      await until(
        tester,
        () => RegExp(r'^/living_clues/[0-9]+$').hasMatch(Get.currentRoute),
        'save clue',
      );
      final id = int.parse(Get.currentRoute.split('/').last);
      final saved = await clues.fetchById(id);
      expect(saved.name, name);
      expect(
        saved.metadata?['observacao'],
        'Registro sintético escrito no Android.',
      );
      expect(saved.hasLocation, isFalse);
      debugPrint('AUDIT clue created through the native form');
      await backToShip();

      Get.toNamed('/living_clues/update?id=$id');
      await until(
        tester,
        () => field('Nome').evaluate().isNotEmpty,
        'load editor',
      );
      await tester.enterText(field('Nome'), '$name revisada');
      tester.testTextInput.hide();
      final update = find.byWidgetPredicate(
        (w) => w is ActionButton && w.title == 'Atualizar',
      );
      await tester.ensureVisible(update);
      await tester.tap(update);
      await tester.pump(const Duration(seconds: 2));
      expect((await clues.fetchById(id)).name, '$name revisada');
      debugPrint('AUDIT clue edited and read back from the API');
      await backToShip();

      final original = await clues.fetchById(1);
      saved.name = '$name integrações';
      saved.description = original.description;
      saved.descriptionDelta = original.descriptionDelta;
      saved.metadata = {
        'observacao': 'Preservada',
        'future_key': {'v': 2, 'opaque': true},
        'praticas_inventivas': {'future_option': true},
      };
      await clues.update(saved);
      Get.toNamed('/living_clues/update?id=$id');
      await until(
        tester,
        () => field('Nome').evaluate().isNotEmpty,
        'rich editor',
      );
      await tester.enterText(field('Nome'), '$name integrações revisadas');
      tester.testTextInput.hide();
      await tester.ensureVisible(update);
      await tester.tap(update);
      await tester.pump(const Duration(seconds: 2));
      final rich = await clues.fetchById(id);
      expect(
        jsonDecode(rich.descriptionDelta!),
        jsonDecode(original.descriptionDelta!),
      );
      expect(rich.metadata?['future_key'], {'v': 2, 'opaque': true});
      debugPrint(
        'AUDIT native editor preserved video, agents, nodes, external integrations and unknown metadata',
      );
      await backToShip();

      final files = FileWebclient();
      final bytes = Uint8List.fromList(
        utf8.encode('Arquivo sintético Android 🌎 $stamp'),
      );
      final attachment = await files.upload(
        FileModel(
          id: 0,
          extension: 'txt',
          name: 'android-$stamp.txt',
          bytes: bytes,
          size: bytes.length,
          livingClueId: id,
        ),
      );
      expect(attachment.id, greaterThan(0));
      expect(
        (await files.fetch(livingClueId: id)).any((f) => f.id == attachment.id),
        isTrue,
      );
      final url = await files.access(attachment.id);
      final download = await http.get(url);
      expect(download.statusCode, 200);
      expect(download.bodyBytes, bytes);
      Get.toNamed('/living_clues/$id');
      await tester.pump(const Duration(seconds: 3));
      debugPrint('AUDIT_CAPTURE attachment-reader');
      await tester.pump(const Duration(seconds: 2));
      await backToShip();
      await files.delete(attachment.id);
      expect(
        (await files.fetch(livingClueId: id)).any((f) => f.id == attachment.id),
        isFalse,
      );
      debugPrint(
        'AUDIT native multipart upload, authorized download and delete passed',
      );

      Get.toNamed('/living_clues/connect', arguments: rich);
      await tester.pump(const Duration(seconds: 2));
      expect(find.text(rich.name), findsWidgets);
      expect(tester.takeException(), isNull);
      await backToShip();

      // Exercise each administrative endpoint using the same authenticated
      // transport as the native forms, then open the saved record in its form.
      final created = <String, int>{};
      final payloads = <String, Map<String, dynamic>>{
        'categories': {
          'name': 'Categoria Android $stamp',
          'type': 'experiencia',
          'color_hex': '#9CE7DF',
          'metadata_tags': 'observacao',
        },
        'node_types': {'name': 'Tipo Android $stamp', 'color': '#9CE7DF'},
        'connection_types': {
          'name': 'Relação Android $stamp',
          'stroke_style': 'solid',
          'is_directional': false,
        },
        'chat_templates': {
          'name': 'Agente Android $stamp',
          'description': 'Validação sintética',
          'system_instruction': 'Responda apenas a testes sintéticos.',
        },
      };
      for (final entry in payloads.entries) {
        final response = Map<String, dynamic>.from(
          await api.write('POST', '/${entry.key}', entry.value),
        );
        final data =
            response[entry.key == 'chat_templates'
                ? 'chat_template'
                : entry.key == 'node_types'
                ? 'node_type'
                : 'data'] ??
            response;
        final item = Map<String, dynamic>.from(data as Map);
        final record = item['id'] as int;
        created[entry.key] = record;
        await api.write('PUT', '/${entry.key}/$record', {
          ...entry.value,
          'name': '${entry.value['name']} revisada',
        });
        Get.toNamed('/${entry.key}/update?id=$record');
        await tester.pump(const Duration(seconds: 2));
        expect(tester.takeException(), isNull, reason: entry.key);
        await backToShip();
        debugPrint('AUDIT native CRUD and edit screen: ${entry.key}');
      }
      Get.toNamed('/living_clues/map');
      await tester.pump(const Duration(seconds: 3));
      final map = Get.find<LivingClueMapController>();
      await map.searchGlobal('Pista de demonstração do mapa');
      expect(map.livingClues.any((c) => c.id == 2), isTrue);
      expect(map.errorMessage.value, isNull);
      debugPrint('AUDIT native map search loaded georeferenced clues');
      await backToShip();
      final users = Get.find<UserController>();
      await users.chooseMode('explorer', navigate: false);
      expect(Get.currentRoute, '/space');
      expect(users.user.value?.usageMode, 'explorer');
      await users.chooseMode('inventor', navigate: false);
      expect(users.user.value?.usageMode, 'inventor');
      debugPrint(
        'AUDIT native mode switch persisted without replacing the cockpit',
      );
      for (final entry in created.entries.toList().reversed) {
        await api.write('DELETE', '/${entry.key}/${entry.value}');
      }
      await clues.delete(id);
      expect(tester.takeException(), isNull);
      debugPrint('AUDIT synthetic workflow records cleaned up');
    },
    timeout: const Timeout(Duration(minutes: 12)),
  );
}
