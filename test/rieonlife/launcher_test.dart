import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/locker_service.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_launcher.dart';

class LocalUser extends UserController {
  @override
  @override
  Future<void> chooseMode(String mode, {bool navigate = true}) async {
    user.value = AuthUser.fromJson({
      ...user.value!.toJson(),
      'usage_mode': mode,
    });
  }

  // This fake intentionally avoids preferences and network initialization.
  // ignore: must_call_super
  void onInit() {}
}

class EmptyLocker extends LockerService {
  @override
  Future<void> load() async {}
}

void main() {
  testWidgets(
    'global shortcuts open and close Locker without losing the origin',
    (tester) async {
      Get.testMode = true;
      Get.put<AiAssistantContextService>(AiAssistantContextService());
      Get.put<AiAssistantController>(
        AiAssistantController()..hasLoadedHistory.value = true,
      );
      Get.put<LockerService>(EmptyLocker());
      final user = Get.put<UserController>(LocalUser());
      user.user.value = const AuthUser(
        id: 1,
        name: 'Teste',
        email: 'test@example.org',
        token: 'local',
        usageMode: 'explorer',
      );
      AiAssistantLauncher.activeRoute.value = '/home';
      AiAssistantLauncher.modeOverlayBlocked.value = false;
      await tester.pumpWidget(
        GetMaterialApp(
          routingCallback: AiAssistantLauncher.didNavigate,
          getPages: [
            GetPage(
              name: '/home',
              page: () => const Scaffold(body: Text('Página de origem')),
            ),
            GetPage(
              name: '/choose_mode',
              page: () => const Scaffold(body: Text('Escolha de modo')),
            ),
          ],
          initialRoute: '/home',
          builder: (context, child) =>
              Overlay.wrap(child: AiAssistantLauncher(child: child!)),
        ),
      );
      await tester.pump();
      expect(find.text('Explorador'), findsOneWidget);
      expect(find.text('Educação OnLIFE'), findsOneWidget);
      await tester.pumpAndSettle();
      final modeButton = tester.widget<TextButton>(
        find.byWidgetPredicate(
          (widget) => widget is TextButton && widget.focusNode != null,
        ),
      );
      modeButton.focusNode!.requestFocus();
      await tester.pump();
      await tester.pumpAndSettle();
      expect(modeButton.focusNode!.hasFocus, isTrue);
      expect(
        find.textContaining(
          'Explorador: explore pistas e referências',
          findRichText: true,
        ),
        findsWidgets,
      );
      modeButton.focusNode!.unfocus();
      await tester.pumpAndSettle();

      Get.to(() => const Scaffold(body: Text('Outra tela')));
      await tester.pumpAndSettle();
      expect(find.text('Outra tela'), findsOneWidget);
      expect(tester.takeException(), isNull);
      Get.back();
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Abrir IAraeté e Locker'));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Locker'));
      await tester.pumpAndSettle();
      expect(find.text('Seu Locker'), findsOneWidget);
      expect(find.text('Página de origem'), findsOneWidget);
      await tester.tap(find.byTooltip('Fechar Locker'));
      await tester.pumpAndSettle();
      expect(find.text('Seu Locker'), findsNothing);
      expect(find.text('Página de origem'), findsOneWidget);
      await tester.tap(find.byTooltip('Abrir IAraeté e Locker'));
      await tester.pump();
      await tester.tap(find.text('IAraeté'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byTooltip('Fechar IAraeté'), findsOneWidget);
      expect(find.byTooltip('Abrir IAraeté e Locker'), findsNothing);
      await tester.tap(find.byTooltip('Fechar IAraeté'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byTooltip('Abrir IAraeté e Locker'), findsOneWidget);
      await tester.tap(find.text('Explorador'));
      await tester.pumpAndSettle();
      expect(find.text('Escolha de modo'), findsNothing);
      expect(find.text('Página de origem'), findsOneWidget);
      expect(find.text('Inventor'), findsOneWidget);
      expect(Get.currentRoute, '/home');
      AiAssistantLauncher.modeOverlayBlocked.value = true;
      await tester.pump();
      expect(find.text('Inventor'), findsNothing);
      AiAssistantLauncher.modeOverlayBlocked.value = false;
      await tester.pump();
      expect(find.text('Inventor'), findsOneWidget);
      AiAssistantLauncher.activeRoute.value = '/living_clues/update';
      await tester.pump();
      expect(find.text('Inventor'), findsNothing);

      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      Get.reset();
    },
  );
}
