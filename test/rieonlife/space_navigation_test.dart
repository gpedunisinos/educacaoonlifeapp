import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
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
  Completer<void>? saveGate;
  bool failMode = false;
  int saves = 0;
  bool? didNavigate;
  @override
  Future<void> chooseMode(String mode, {bool navigate = true}) async {
    saves++;
    didNavigate = navigate;
    if (saveGate != null) await saveGate!.future;
    if (failMode) throw Exception('offline');
    user.value = AuthUser.fromJson({
      ...user.value!.toJson(),
      'usage_mode': mode,
    });
  }

  @override
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  testWidgets('cockpit opens allowed routes, pauses and resumes the same scene', (
    tester,
  ) async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    addTearDown(Get.reset);
    final user = SpaceTestUser();
    Get.put<UserController>(user);
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
            name: '/space/agents',
            page: () => Scaffold(
              body: TextButton(
                onPressed: Get.back,
                child: const Text('Sair da câmara'),
              ),
            ),
          ),
          GetPage(
            name: '/space/research',
            page: () => Scaffold(
              body: TextButton(
                onPressed: Get.back,
                child: const Text('Sair da pesquisa'),
              ),
            ),
          ),
          GetPage(
            name: '/choose_mode',
            page: () => Scaffold(
              body: TextButton(
                onPressed: Get.back,
                child: const Text('Voltar do modo'),
              ),
            ),
          ),
          GetPage(
            name: '/management',
            page: () => Scaffold(
              body: TextButton(
                onPressed: Get.back,
                child: const Text('Sair da gestão'),
              ),
            ),
          ),
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
    expect(commands.last['destinations'], isNot(contains('connections')));
    expect(commands.last['management'], isTrue);
    expect(commands.last['tutorialSeen'], isFalse);
    expect(commands.last['mode'], 'explorer');
    view.onMessage({'type': 'tutorial-complete', 'version': 1});
    await tester.pumpAndSettle();
    expect(
      (await SharedPreferences.getInstance()).getBool('space_tutorial_v1_1'),
      isTrue,
    );
    view.onMessage({'type': 'ready'});
    await tester.pumpAndSettle();
    expect(commands.last['tutorialSeen'], isTrue);
    final originalUser = user.user.value;
    user.user.value = const AuthUser(
      id: 2,
      name: 'Outra pessoa',
      email: 'other@example.com',
      token: 'test',
      profile: 40,
      usageMode: 'explorer',
    );
    view.onMessage({'type': 'ready'});
    await tester.pumpAndSettle();
    expect(commands.last['tutorialSeen'], isFalse);
    user.user.value = originalUser;

    // A mode change saves in place, rejects duplicates, and keeps failures recoverable.
    final originalScene = tester.widget<SpaceView>(find.byType(SpaceView));
    user.saveGate = Completer<void>();
    view.onMessage({'type': 'change-mode', 'mode': 'inventor'});
    view.onMessage({'type': 'change-mode', 'mode': 'inventor'});
    await tester.pump();
    expect(user.saves, 1);
    expect(user.user.value!.usageMode, 'explorer');
    user.saveGate!.complete();
    await tester.pumpAndSettle();
    expect(user.didNavigate, isFalse);
    expect(user.user.value!.canAuthor, isTrue);
    expect(commands.last, {
      'type': 'mode-state',
      'mode': 'inventor',
      'error': null,
      'announce': true,
    });
    expect(
      tester.widget<SpaceView>(find.byType(SpaceView)),
      same(originalScene),
    );
    user.saveGate = null;
    user.failMode = true;
    view.onMessage({'type': 'change-mode', 'mode': 'explorer'});
    await tester.pumpAndSettle();
    expect(user.user.value!.usageMode, 'inventor');
    expect(commands.last['error'], isNotNull);
    expect(commands.last['announce'], isFalse);
    user.failMode = false;
    view.onMessage({'type': 'change-mode', 'mode': 'explorer'});
    await tester.pumpAndSettle();
    expect(user.user.value!.canAuthor, isFalse);
    final saves = user.saves;
    view.onMessage({'type': 'change-mode', 'mode': 'administrator'});
    await tester.pumpAndSettle();
    expect(user.saves, saves);
    expect(
      tester.widget<SpaceView>(find.byType(SpaceView)),
      same(originalScene),
    );

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
    expect(commands.last, {
      'type': 'resume',
      'returned': true,
      'audioEnabled': true,
    });
    view.onMessage({'type': 'open', 'destination': 'connections'});
    await tester.pumpAndSettle();
    expect(find.text('Sair da gestão'), findsNothing);
    view.onMessage({'type': 'management'});
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/management');
    expect(find.text('Sair da gestão'), findsOneWidget);
    await tester.tap(find.text('Sair da gestão'));
    await tester.pumpAndSettle();
    expect(tester.widget<SpaceView>(find.byType(SpaceView)), same(view));
    view.onMessage({'type': 'open', 'destination': 'research'});
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/space/research');
    await tester.tap(find.text('Sair da pesquisa'));
    await tester.pumpAndSettle();
    expect(tester.widget<SpaceView>(find.byType(SpaceView)), same(view));
    view.onMessage({'type': 'open', 'destination': 'agents'});
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/space/agents');
    await tester.tap(find.text('Sair da câmara'));
    await tester.pumpAndSettle();
    expect(tester.widget<SpaceView>(find.byType(SpaceView)), same(view));
    view.onMessage({'type': 'exit'});
    await tester.pumpAndSettle();
    expect(find.text('Conta'), findsOneWidget);
    expect(find.text('Modo Explorador'), findsOneWidget);
    expect(find.text('Sair da conta'), findsOneWidget);
    expect(commands.last['type'], 'pause');
    await tester.tap(find.byTooltip('Fechar conta'));
    await tester.pumpAndSettle();
    expect(tester.widget<SpaceView>(find.byType(SpaceView)), same(view));
    expect(commands.last, {
      'type': 'resume',
      'returned': true,
      'audioEnabled': true,
    });
    await tester.tap(find.byTooltip('Conta e modo de navegação'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar seletor no console de bordo'));
    await tester.pumpAndSettle();
    expect(find.text('Voltar do modo'), findsNothing);
    expect(commands.any((command) => command['type'] == 'focus-mode'), isTrue);
    expect(tester.widget<SpaceView>(find.byType(SpaceView)), same(view));
    expect(commands.last, {
      'type': 'resume',
      'returned': true,
      'audioEnabled': true,
    });
    expect(find.byTooltip('Voltar aos módulos'), findsNothing);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    debugDefaultTargetPlatformOverride = null;
  });

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
    for (final route in [
      '/space',
      '/management',
      '/management/connections',
      '/living_clues/map',
      '/space',
      '/home',
    ]) {
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
  testWidgets('agent conversation keeps the global shortcut away from send', (
    tester,
  ) async {
    Get.testMode = true;
    addTearDown(Get.reset);
    addTearDown(() => AiAssistantLauncher.activeRoute.value = '');
    final user = SpaceTestUser();
    Get.put<UserController>(user);
    user.user.value = const AuthUser(
      id: 1,
      name: 'Explorador',
      email: 'test@example.com',
      token: 'test',
      profile: 40,
      usageMode: 'explorer',
    );
    AiAssistantLauncher.activeRoute.value = '/space/agents/8';
    await tester.pumpWidget(
      GetMaterialApp(
        home: AiAssistantLauncher(
          child: const Scaffold(body: Text('Canal do agente')),
        ),
      ),
    );
    await tester.pump();
    expect(find.byTooltip('Abrir IAraeté e Locker'), findsNothing);
    AiAssistantLauncher.activeRoute.value = '/space/agents';
    await tester.pump();
    expect(find.byTooltip('Abrir IAraeté e Locker'), findsOneWidget);
  });
}
