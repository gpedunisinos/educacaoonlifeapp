import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:unisinos_usp_app/main.dart' as app;
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';

// Requires an explicitly selected disposable local API/schema. Never runs against
// the application's default production endpoint.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
    'local native account, mode, Locker and rich clue',
    (tester) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await app.main();
      Future<void> until(bool Function() condition) async {
        for (var i = 0; i < 100 && !condition(); i++) {
          await tester.pump(const Duration(milliseconds: 200));
        }
        expect(condition(), isTrue);
      }

      await until(
        () =>
            Get.isRegistered<UserController>() && Get.currentRoute == '/login',
      );
      final user = Get.find<UserController>();
      await user.createAccount(
        name: 'Validação Android',
        email: 'android.${DateTime.now().microsecondsSinceEpoch}@example.test',
        password: 'Rieonlife-test-2026!',
      );
      await until(
        () =>
            Get.currentRoute == '/choose_mode' &&
            find.text('Inventor').evaluate().isNotEmpty,
      );
      expect(user.user.value!.usageMode, isNull);
      final choice = find.text('Inventor', skipOffstage: true);
      await tester.ensureVisible(choice);
      await tester.tap(choice);
      await until(
        () =>
            Get.currentRoute == '/home' &&
            find.byTooltip('Abrir Iareté e Locker').evaluate().isNotEmpty,
      );
      expect(user.user.value!.usageMode, 'inventor');
      await until(() => !Get.isSnackbarOpen);
      await tester.tap(find.byTooltip('Abrir Iareté e Locker'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Locker'));
      await until(() => find.text('Seu Locker').evaluate().isNotEmpty);
      expect(find.text('Guarde suas próximas descobertas'), findsOneWidget);
      await until(
        () =>
            find.byTooltip('Fechar Locker').hitTestable().evaluate().isNotEmpty,
      );
      await tester.tap(find.byTooltip('Fechar Locker'));
      await until(() => find.text('Seu Locker').evaluate().isEmpty);
      final api = EconectivaApi();
      final categories = await api.get('/categories');
      final clue = await api.write('POST', '/living_clues', {
        'name': 'Vivência Android sem localização',
        'category_id': categories[0]['id'],
        'description_delta': jsonEncode([
          {'insert': 'Descoberta em movimento\n'},
          {
            'insert': {'video': 'https://www.youtube.com/watch?v=M7lc1UVf-VE'},
          },
          {'insert': '\n'},
        ]),
      });
      Get.toNamed('/living_clues/${clue['id']}');
      await until(() => find.byType(YoutubePlayer).evaluate().isNotEmpty);
      expect(find.text('Vivência Android sem localização'), findsOneWidget);
      expect(find.text('Abrir vídeo original no YouTube'), findsOneWidget);
      expect(clue['latitude'], isNull);
      expect(clue['longitude'], isNull);
      expect(tester.takeException(), isNull);
    },
    skip: !const bool.fromEnvironment('RIEONLIFE_LOCAL_TEST'),
  );
}
