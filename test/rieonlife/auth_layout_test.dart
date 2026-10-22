import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/routes/auth.dart';

class _User extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  for (final route in [
    '/login',
    '/create_account',
    '/recover_password',
    '/code_confirmation',
    '/create_password',
  ]) {
    for (final size in [const Size(411, 914), const Size(914, 360)]) {
      testWidgets(
        '$route remains readable at $size with the keyboard visible',
        (tester) async {
          Get.testMode = true;
          Get.put<UserController>(_User());
          tester.view.physicalSize = size;
          tester.view.devicePixelRatio = 1;
          tester.view.viewInsets = const FakeViewPadding(bottom: 180);
          addTearDown(() {
            tester.view.resetPhysicalSize();
            tester.view.resetDevicePixelRatio();
            tester.view.resetViewInsets();
            Get.reset();
          });
          await tester.pumpWidget(
            GetMaterialApp(
              getPages: authRoutes(),
              home: const SizedBox.shrink(),
            ),
          );
          Get.toNamed(route, arguments: 'synthetic-code');
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          await tester.pump();
        },
      );
    }
  }
}
