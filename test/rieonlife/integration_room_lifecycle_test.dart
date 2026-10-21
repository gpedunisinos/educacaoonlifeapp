import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/clue_integration.dart';
import 'package:unisinos_usp_app/widgets/clue_integrations.dart';
import 'package:unisinos_usp_app/widgets/integration_frame.dart';

const world = ClueIntegration(
  provider: 'framevr',
  url: 'https://framevr.io/test-world',
);

void main() {
  tearDown(Get.reset);
  testWidgets(
    'expanded content identifies its provider and restores the originating clue context',
    (tester) async {
      Get.testMode = true;
      final service = Get.put(AiAssistantContextService());
      final origin = AiAssistantScreenContext(
        screenName: 'Pista',
        route: '/',
        stage: 'leitura',
        goal: 'ler',
        references: {'living_clue_id': 17},
      );
      service.registerProvider('/', () => origin);
      await tester.pumpWidget(
        GetMaterialApp(
          home: const Scaffold(body: Text('Pista de origem')),
          routingCallback: (routing) =>
              service.setCurrentRoute(routing?.current ?? ''),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.text('Pista de origem'));
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) =>
              ClueIntegrationRoom(block: world, originContext: origin),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        service.resolveCurrentContext().screenName,
        'FrameVR — conteúdo da pista',
      );
      expect(service.resolveCurrentContext().references['living_clue_id'], 17);
      expect(
        service.resolveCurrentContext().filledFields['provedor'],
        'FrameVR',
      );
      service.registerProvider(
        '/other-clue',
        () => AiAssistantScreenContext(
          screenName: 'Outra pista',
          route: '/other-clue',
          stage: 'leitura',
          goal: 'ler',
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: '/other-clue'),
          builder: (_) => const Scaffold(body: Text('Outra pista')),
        ),
      );
      await tester.pumpAndSettle();
      expect(service.resolveCurrentContext().screenName, 'Outra pista');
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(
        service.resolveCurrentContext().screenName,
        'FrameVR — conteúdo da pista',
      );
      expect(service.resolveCurrentContext().references['living_clue_id'], 17);
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(service.resolveCurrentContext().screenName, 'Pista');
    },
  );

  testWidgets(
    'reentry and origin controls fit a narrow screen with a long title',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const narrow = ClueIntegration(
        provider: 'framevr',
        url: 'https://framevr.io/test-world',
        title:
            'Ambiente de demonstração com um título bastante extenso para a tela',
      );
      await tester.pumpWidget(
        const MaterialApp(home: ClueIntegrationRoom(block: narrow)),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await tester.pumpAndSettle();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('Entrar novamente').hitTestable(), findsOneWidget);
      expect(find.text('Abrir na origem').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a world is removed behind another route and requires explicit reentry',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ClueIntegrationRoom(block: world)),
      );
      expect(
        find.byType(IntegrationFrame, skipOffstage: false),
        findsOneWidget,
      );
      final context = tester.element(find.byType(ClueIntegrationRoom));
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Outra pista')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(IntegrationFrame, skipOffstage: false), findsNothing);
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(find.text('Ambiente encerrado'), findsOneWidget);
      expect(find.byType(IntegrationFrame), findsNothing);
      await tester.tap(find.text('Entrar novamente'));
      await tester.pumpAndSettle();
      expect(find.byType(IntegrationFrame), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'hiding the application disposes the world without automatically reconnecting',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ClueIntegrationRoom(block: world)),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      await tester.pumpAndSettle();
      expect(find.byType(IntegrationFrame, skipOffstage: false), findsNothing);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('Entrar novamente'), findsOneWidget);
      expect(find.byType(IntegrationFrame), findsNothing);
      await tester.tap(find.text('Entrar novamente'));
      await tester.pumpAndSettle();
      expect(find.byType(IntegrationFrame), findsOneWidget);
    },
  );

  testWidgets(
    'external handoff closes the embedded world even when launch fails',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ClueIntegrationRoom(block: world)),
      );
      await tester.tap(find.text('Abrir na origem'));
      await tester.pumpAndSettle();
      expect(find.byType(IntegrationFrame, skipOffstage: false), findsNothing);
      expect(find.text('Entrar novamente'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'covering an ordinary presentation preserves its reading instance',
    (tester) async {
      const presentation = ClueIntegration(
        provider: 'genially',
        url: 'https://view.genially.com/639889b6dec2450018531041',
      );
      await tester.pumpWidget(
        const MaterialApp(home: ClueIntegrationRoom(block: presentation)),
      );
      final context = tester.element(find.byType(ClueIntegrationRoom));
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const Scaffold(body: Text('Outra tela')),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(IntegrationFrame, skipOffstage: false),
        findsOneWidget,
      );
      Navigator.of(context).pop();
      await tester.pumpAndSettle();
      expect(find.text('Ambiente encerrado'), findsNothing);
      expect(find.byType(IntegrationFrame), findsOneWidget);
    },
  );
}
