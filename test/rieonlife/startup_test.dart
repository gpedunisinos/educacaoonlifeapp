import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widgets_spo/utils.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';

void main() {
  test('both selected modes open home; first access requires a choice', () {
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
      expect(controller.modeHome, '/home');
      expect(controller.user.value!.canAuthor, mode == 'inventor');
    }
  });
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
