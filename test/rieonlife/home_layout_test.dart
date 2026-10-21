import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/screens/home_screen.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/themes/app_theme.dart';
import 'package:unisinos_usp_app/widgets/app_page_viewport.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';

class HomeTestUser extends UserController {
  @override
  // No network/session initialization is needed to render the home.
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  for (final width in [390.0, 1920.0]) {
    testWidgets(
      'home keeps a single background and readable menu at $width px',
      (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(Get.reset);
        final controller = Get.put<UserController>(HomeTestUser());
        controller.user.value = const AuthUser(
          id: 1,
          name: 'Admin',
          email: 'local@example.com',
          token: 'local',
          usageMode: 'inventor',
          profile: 40,
        );
        Get.put(AiAssistantContextService());
        await tester.pumpWidget(
          GetMaterialApp(
            theme: AppTheme.theme,
            builder: (context, child) => AppPageViewport(child: child!),
            home: HomeScreen(),
          ),
        );
        await tester.pump();
        expect(find.byType(StarfieldBackground), findsOneWidget);
        expect(find.byType(CidigScenicBackground), findsOneWidget);
        expect(tester.getSize(find.byType(StarfieldBackground)).width, width);
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(
          scaffold.backgroundColor ?? AppTheme.theme.scaffoldBackgroundColor,
          Colors.transparent,
        );
        final categories = tester.getRect(find.text('Categorias'));
        final clues = tester.getRect(find.text('Pistas'));
        if (width < 700) {
          expect(clues.top, greaterThan(categories.bottom));
        } else {
          expect(clues.top, categories.top);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
