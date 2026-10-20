import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/screens/space/space_screen.dart';
import 'package:unisinos_usp_app/screens/space/space_view.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_launcher.dart';
import 'package:unisinos_usp_app/widgets/app_page_viewport.dart';

class SpaceTestUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  testWidgets(
    'cockpit opens allowed routes, pauses and resumes the same scene',
    (tester) async {
      Get.testMode = true;
      debugDefaultTargetPlatformOverride = TargetPlatform.linux;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      addTearDown(Get.reset);
      final user = Get.put<UserController>(SpaceTestUser());
      user.user.value = const AuthUser(
        id: 1,
        name: 'Explorador',
        email: 'test@example.com',
        token: 'test',
        profile: 40,
        usageMode: 'explorer',
      );
      Get.put(AiAssistantContextService());
      await tester.pumpWidget(
        GetMaterialApp(
          home: const SpaceScreen(),
          getPages: [
            GetPage(
              name: '/living_clues/map',
              page: () => Scaffold(
                body: TextButton(
                  onPressed: Get.back,
                  child: const Text('Voltar à nave'),
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pump();
      final view = tester.widget<SpaceView>(find.byType(SpaceView));
      final commands = <Map<String, dynamic>>[];
      final subscription = view.commands.listen(commands.add);
      addTearDown(subscription.cancel);
      view.onMessage({'type': 'ready'});
      await tester.pump();
      expect(commands.last['destinations'], contains('earth'));
      final count = commands.length;
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      await tester.pump();
      expect(
        commands.length,
        count,
        reason: 'iframe focus must not pause the scene',
      );
      view.onMessage({'type': 'open', 'destination': 'untrusted-route'});
      await tester.pump();
      expect(find.text('Voltar à nave'), findsNothing);
      view.onMessage({'type': 'open', 'destination': 'earth'});
      await tester.pumpAndSettle();
      expect(find.text('Voltar à nave'), findsOneWidget);
      expect(Get.arguments, {'fromSpace': true});
      expect(commands.last['type'], 'pause');
      await tester.tap(find.text('Voltar à nave'));
      await tester.pumpAndSettle();
      expect(tester.widget<SpaceView>(find.byType(SpaceView)), same(view));
      expect(commands.last, {'type': 'resume', 'returned': true});
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      debugDefaultTargetPlatformOverride = null;
    },
  );

  testWidgets('map and cockpit use full width without replacing route state', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(() => AiAssistantLauncher.activeRoute.value = '');
    AiAssistantLauncher.activeRoute.value = '/home';
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: AppPageViewport(child: SizedBox.expand(key: key)),
      ),
    );
    final element = key.currentContext;
    expect(tester.getSize(find.byKey(key)).width, 1040);
    for (final route in ['/space', '/living_clues/map', '/space', '/home']) {
      AiAssistantLauncher.activeRoute.value = route;
      await tester.pump();
      expect(key.currentContext, same(element));
      expect(
        tester.getSize(find.byKey(key)).width,
        route == '/home' ? 1040 : 1440,
      );
    }
    await tester.pumpWidget(const SizedBox.shrink());
    debugDefaultTargetPlatformOverride = null;
  });
}
