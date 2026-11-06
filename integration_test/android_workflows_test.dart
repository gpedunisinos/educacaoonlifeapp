// Run only against scripts/run-integrations-preview.py and synthetic records.
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'dart:io' show WebSocket;
import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/services/participant_chat/participant_chat_service.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:unisinos_usp_app/webclients/file_webclient.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/webclients/meeting_webclient.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';

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

      await until(
        tester,
        () => find.byType(WebViewWidget).evaluate().isNotEmpty,
        'cockpit',
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
        'document.getElementById("start-sound").checked=true;document.getElementById("start").click();',
      );
      await tester.pump(const Duration(seconds: 2));
      for (var i = 0; i < 16; i++) {
        if (await js('document.getElementById("ship-tutorial").hidden') == true)
          break;
        final bounds =
            await js(
                  '(()=>{const r=document.getElementById("tour-card").getBoundingClientRect();return {left:r.left,top:r.top,right:r.right,bottom:r.bottom,width:innerWidth,height:innerHeight};})()',
                )
                as Map;
        expect(bounds['left'], greaterThanOrEqualTo(0));
        expect(bounds['top'], greaterThanOrEqualTo(0));
        expect(
          bounds['right'],
          lessThanOrEqualTo((bounds['width'] as num) + 1),
        );
        expect(
          bounds['bottom'],
          lessThanOrEqualTo((bounds['height'] as num) + 1),
        );
        if (i == 0) {
          debugPrint('AUDIT_CAPTURE tutorial-portrait');
          await tester.pump(const Duration(seconds: 2));
        }
        await web.runJavaScript(
          'document.getElementById("tour-next").click();',
        );
        await tester.pump(const Duration(milliseconds: 400));
      }
      expect(
        await js('document.getElementById("ship-tutorial").hidden'),
        isTrue,
      );
      debugPrint(
        'AUDIT native tutorial completed with every explanation inside viewport',
      );
      await web.runJavaScript(
        'document.querySelector("[data-destination=earth]").click();document.getElementById("navigate").click();',
      );
      await tester.pump(const Duration(seconds: 1));
      await web.runJavaScript('document.getElementById("skip").click();');
      await tester.pump(const Duration(seconds: 3));
      expect(
        await js(
          '(()=>{const p=document.getElementById("message");return p.scrollWidth <= p.clientWidth+1;})()',
        ),
        isTrue,
        reason: 'Iareté explanations must wrap within the phone console',
      );
      expect(
        await js('document.body.dataset.earthTexture'),
        'ready',
        reason: 'The real Earth texture must load in Android WebGL',
      );
      debugPrint('AUDIT_CAPTURE cockpit-portrait-final');
      await tester.pump(const Duration(seconds: 2));
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
      ]);
      await tester.pump(const Duration(seconds: 3));
      for (
        var i = 0;
        i < 40 && await js('innerWidth > innerHeight') != true;
        i++
      ) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      expect(await js('innerWidth > innerHeight'), isTrue);
      debugPrint('AUDIT_CAPTURE cockpit-landscape');
      await tester.pump(const Duration(seconds: 2));
      expect(
        await js('document.documentElement.scrollWidth <= innerWidth+1'),
        isTrue,
      );
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await tester.pump(const Duration(seconds: 3));
      for (
        var i = 0;
        i < 40 && await js('innerWidth < innerHeight') != true;
        i++
      ) {
        await tester.pump(const Duration(milliseconds: 250));
      }
      expect(await js('innerWidth < innerHeight'), isTrue);
      debugPrint(
        'AUDIT native orientation changes preserved the WebGL cockpit',
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
      await until(
        tester,
        () => field('Nome').evaluate().isNotEmpty,
        'native create form',
      );
      await tester.enterText(field('Nome'), name);
      await tester.enterText(
        field('Observacao'),
        'Registro sintético escrito no Android.',
      );
      FocusManager.instance.primaryFocus?.unfocus();
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
      FocusManager.instance.primaryFocus?.unfocus();
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
        'praticas_inventivas': ['niig', 'saigon'],
      };
      await clues.update(saved);
      Get.toNamed('/living_clues/update?id=$id');
      await until(
        tester,
        () => field('Nome').evaluate().isNotEmpty,
        'rich editor',
      );
      await tester.enterText(field('Nome'), '$name integrações revisadas');
      FocusManager.instance.primaryFocus?.unfocus();
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
      if (const bool.fromEnvironment('NATIVE_S3'))
        expect(attachment.storageProvider, 's3');
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
        (await http.get(url)).statusCode,
        404,
        reason: 'Deleted content must be removed from storage',
      );
      expect(
        (await files.fetch(livingClueId: id)).any((f) => f.id == attachment.id),
        isFalse,
      );
      debugPrint(
        'AUDIT native multipart upload, authorized download and delete passed (${attachment.storageProvider})',
      );

      Get.toNamed('/living_clues/connect', arguments: rich);
      await until(
        tester,
        () => find.text(rich.name).evaluate().isNotEmpty,
        'connection form source',
      );
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
        await until(
          tester,
          () => find.byType(ManagementInput).evaluate().isNotEmpty,
          'saved administrative form',
        );
        await tester.pump(const Duration(seconds: 1));
        expect(tester.takeException(), isNull, reason: entry.key);
        await backToShip();
        debugPrint('AUDIT native CRUD and edit screen: ${entry.key}');
      }
      Get.toNamed('/living_clues/map');
      await until(
        tester,
        () => Get.isRegistered<LivingClueMapController>(),
        'map controller',
      );
      await tester.pump(const Duration(seconds: 1));
      final map = Get.find<LivingClueMapController>();
      await map.searchGlobal('Pista de demonstração do mapa');
      expect(map.livingClues.any((c) => c.id == 2), isTrue);
      expect(map.errorMessage.value, isNull);
      debugPrint('AUDIT native map search loaded georeferenced clues');
      await backToShip();
      Get.toNamed('/nodes/graph?focus=2');
      await until(
        tester,
        () => find.text('Acesso à água — teste').evaluate().isNotEmpty,
        'selected problematic',
      );
      final graphSearch = find.byWidgetPredicate(
        (w) =>
            w is TextField &&
            (w.decoration?.hintText ?? '').contains('Buscar problemática'),
      );
      await tester.enterText(graphSearch, 'Acesso');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump(const Duration(milliseconds: 400));
      debugPrint('AUDIT_CAPTURE graph-selected');
      await tester.pump(const Duration(seconds: 2));
      expect(tester.takeException(), isNull);
      await backToShip();
      debugPrint(
        'AUDIT native graph loaded, selected and filtered a problematic',
      );
      final meeting = MeetingRoom.parse('android-sintetico-$stamp');
      final authorized = await MeetingWebclient().authorize(meeting);
      expect(authorized.queryParameters['jwt'], isNotEmpty);
      expect(meeting.uri.queryParameters.containsKey('jwt'), isFalse);
      debugPrint(
        'AUDIT meeting authorization passed on native authenticated transport',
      );
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
      final userApi = UserWebclient();
      final peer = await userApi.createUser(
        UserModel(
          id: 0,
          name: 'Par Android $stamp',
          email: 'android-$stamp@example.test',
          profile: 10,
          password: const String.fromEnvironment('E2E_PASSWORD'),
        ),
      );
      final loginResponse = await http.post(
        Uri.parse('http://10.0.2.2:8082/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': peer.email,
          'password': const String.fromEnvironment('E2E_PASSWORD'),
        }),
      );
      expect(loginResponse.statusCode, 200);
      final loginData = jsonDecode(loginResponse.body) as Map;
      final token =
          (loginData['token'] ?? loginData['plain_text_token']) as String;
      final peerSocket = await WebSocket.connect(
        'ws://10.0.2.2:8082/api/presence',
        headers: {'Origin': 'http://127.0.0.1:8773'},
      );
      final peerEvents = <Map>[];
      peerSocket.listen((data) {
        peerEvents.add(jsonDecode(data as String) as Map);
      });
      peerSocket.add(jsonEncode({'type': 'auth', 'token': token}));
      peerSocket.add(
        jsonEncode({
          'type': 'state',
          'destination': 'cockpit',
          'visible': true,
          'interacted': true,
        }),
      );
      final presence = Get.find<PresenceService>();
      await until(
        tester,
        () => peerEvents.any(
          (e) => e['type'] == 'snapshot' && e['self'] is String,
        ),
        'peer identity',
      );
      final peerId =
          peerEvents.firstWhere((e) => e['type'] == 'snapshot')['self']
              as String;
      await until(
        tester,
        () => presence.participants.any((p) => p.id == peerId),
        'synthetic peer presence',
      );
      final participant = presence.participants.firstWhere(
        (p) => p.id == peerId,
      );
      final chats = Get.find<ParticipantChatService>();
      await chats.openParticipant(participant.id);
      expect(chats.active.value, isNotNull);
      final text = 'Olá do Android 🌎✨ $stamp';
      expect(await chats.send(text), isTrue);
      final conversation = chats.active.value!.id;
      final peerHeaders = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      final history = await http.get(
        Uri.parse(
          'http://10.0.2.2:8082/api/me/conversations/$conversation/messages',
        ),
        headers: peerHeaders,
      );
      expect(history.statusCode, 200);
      expect(history.body, contains(text));
      final reply = 'Resposta sintética 🚀 $stamp';
      final sent = await http.post(
        Uri.parse(
          'http://10.0.2.2:8082/api/me/conversations/$conversation/messages',
        ),
        headers: peerHeaders,
        body: jsonEncode({'text': reply, 'client_id': const Uuid().v4()}),
      );
      expect(sent.statusCode, anyOf(200, 201));
      await chats.loadMessages();
      expect(chats.texts.any((t) => t.text == reply && !t.own), isTrue);
      final ownRegion = presence.section;
      peerSocket.add(
        jsonEncode({
          'type': 'state',
          'destination': 'research',
          'visible': true,
          'interacted': true,
        }),
      );
      await until(
        tester,
        () => presence.participants.any(
          (p) => p.id == participant.id && p.destination == 'research',
        ),
        'peer changed region',
      );
      expect(
        presence.section,
        ownRegion,
        reason: 'A peer trip must not move this ship',
      );
      await peerSocket.close();
      await userApi.deleteUser(peer.id);
      debugPrint(
        'AUDIT native participant chat sent text/emojis, received reply and preserved separate regions',
      );
      await clues.delete(id);
      expect(tester.takeException(), isNull);
      debugPrint('AUDIT synthetic workflow records cleaned up');
      for (final orientation in [
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
      ]) {
        await SystemChrome.setPreferredOrientations([orientation]);
        await tester.pump(const Duration(seconds: 2));
        for (final route in [
          '/choose_mode',
          '/create_account',
          '/recover_password',
          '/code_confirmation',
          '/create_password',
        ]) {
          Get.toNamed(
            route,
            arguments: route == '/create_password'
                ? 'synthetic-invalid-code'
                : null,
          );
          await tester.pump(const Duration(seconds: 1));
          expect(
            tester.takeException(),
            isNull,
            reason: '$route at $orientation',
          );
          await backToShip();
        }
      }
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      debugPrint(
        'AUDIT authentication and mode screens fit portrait and landscape',
      );
    },
    timeout: const Timeout(Duration(minutes: 12)),
  );
}
