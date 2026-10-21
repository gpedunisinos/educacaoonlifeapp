import 'package:unisinos_usp_app/screens/splash_screen.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widgets_spo/utils.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';

class StartupUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {
    initialization = Future.value();
  }
}

void main() {
  test(
    'both selected modes open the cockpit; first access requires a choice',
    () {
      final controller = UserController();
      expect(controller.modeHome, '/choose_mode');
      for (final mode in ['explorer', 'inventor']) {
        controller.user.value = AuthUser(
          id: 1,
          name: 'Participant',
          email: 'test@example.com',
          token: 'local',
          usageMode: mode,
        );
        expect(controller.modeHome, '/space');
        expect(controller.user.value!.canAuthor, mode == 'inventor');
      }
    },
  );
  for (final mode in ['explorer', 'inventor', 'unset', 'signed-out']) {
    testWidgets('startup opens the correct entry for $mode', (tester) async {
      Get.testMode = true;
      addTearDown(Get.reset);
      final controller = Get.put<UserController>(StartupUser());
      if (mode != 'signed-out') {
        controller.user.value = AuthUser(
          id: 1,
          name: 'Teste',
          email: 'test@example.com',
          token: 'test',
          profile: 10,
          usageMode: mode == 'unset' ? null : mode,
        );
      }
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/splash',
          getPages: [
            GetPage(name: '/splash', page: () => const SplashScreen()),
            GetPage(
              name: '/space',
              page: () => const Scaffold(body: Text('Cockpit')),
            ),
            GetPage(
              name: '/choose_mode',
              page: () => const Scaffold(body: Text('Escolher modo')),
            ),
            GetPage(
              name: '/login',
              page: () => const Scaffold(body: Text('Login')),
            ),
            GetPage(
              name: '/home',
              page: () => const Scaffold(body: Text('Menu antigo')),
              middlewares: [AppRouteGuard(canActivate: (user) => user != null)],
            ),
          ],
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(
        Get.currentRoute,
        mode == 'signed-out'
            ? '/login'
            : mode == 'unset'
            ? '/choose_mode'
            : '/space',
      );
      expect(find.text('Menu antigo'), findsNothing);
      if (mode == 'explorer' || mode == 'inventor') {
        Get.offAllNamed('/home');
        await tester.pumpAndSettle();
        expect(Get.currentRoute, '/space');
        expect(find.text('Menu antigo'), findsNothing);
      }
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'a first startup does not navigate before the app navigator exists',
    (tester) async {
      PackageInfo.setMockInitialValues(
        appName: 'test',
        packageName: 'test',
        version: '1',
        buildNumber: '1',
        buildSignature: '',
      );
      SharedPreferences.setMockInitialValues({});
      await Util.initPrefs();
      final user = Get.put<UserController>(UserController());
      await user.initialization;
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
      expect(user.user.value, isNull);
      expect(tester.takeException(), isNull);
      Get.reset();
    },
  );
}
