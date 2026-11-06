import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/clue_integration.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:unisinos_usp_app/widgets/clue_agent_integration.dart';

class AgentChoices extends ClueAgentSource {
  final calls = <String>[];
  bool fail = false;
  @override
  Future<List<ChatTemplateModel>> search(String query, int offset) async {
    calls.add('$query:$offset');
    if (fail) throw Exception('offline');
    if (query == 'vazio') return [];
    if (query.isNotEmpty)
      return [
        ChatTemplateModel(
          id: 503,
          name: 'Agente de território',
          description: 'Pesquisa em território',
        ),
      ];
    return offset == 0
        ? List.generate(
            20,
            (i) => ChatTemplateModel(id: i + 1, name: 'Agente ${i + 1}'),
          )
        : [ChatTemplateModel(id: 21, name: 'Agente 21')];
  }
}

void main() {
  test(
    'internal agent references roundtrip and reject arbitrary routes and schemes',
    () {
      const integration = ClueIntegration(
        provider: 'agent',
        url: '/space/agents/503',
        title: 'Agente de território',
      );
      expect(integration.supported, isTrue);
      expect(integration.agentId, 503);
      expect(integration.embedURI, isNull);
      expect(ClueIntegration.decode(integration.encode())!.agentId, 503);
      for (final url in [
        '/space/agents/0',
        '/space/agents/-1',
        '/space/agents/1/messages',
        '/space/agents/1?token=x',
        '/space/agents/1\n',
        'https://evil.test/space/agents/1',
        'javascript:alert(1)',
        '/management',
      ]) {
        expect(
          ClueIntegration.validateURL('agent', url),
          isNotNull,
          reason: url,
        );
      }
    },
  );
  testWidgets(
    'search, link, reopen, replace and remove preserve author text and other blocks',
    (tester) async {
      final source = AgentChoices();
      final controller = QuillController.basic();
      controller.document.insert(0, 'Descrição preservada');
      controller.updateSelection(
        const TextSelection(baseOffset: 0, extentOffset: 9),
        ChangeSource.local,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Builder(
                    builder: (context) => TextButton(
                      onPressed: () => editClueAgentIntegration(
                        context,
                        controller,
                        source: source,
                      ),
                      child: const Text('Vincular'),
                    ),
                  ),
                  ClueAgentCards(controller: controller, source: source),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Vincular'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'território');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(source.calls, contains('território:0'));
      await tester.tap(find.text('Agente de território'));
      await tester.pumpAndSettle();
      expect(find.text('Trocar agente'), findsOneWidget);
      expect(QuillDocumentUtils.plainText(controller), 'Descrição preservada');
      controller.document = QuillDocumentUtils.fromStored(
        delta: QuillDocumentUtils.encodeDelta(controller),
      );
      await tester.pumpAndSettle();
      expect(find.text('Agente de território'), findsOneWidget);
      await tester.tap(find.text('Trocar agente'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Agente 1'));
      await tester.pumpAndSettle();
      expect(find.text('Agente 1'), findsOneWidget);
      expect(
        QuillDocumentUtils.encodeDelta(controller),
        isNot(contains('/space/agents/503')),
      );
      await tester.tap(find.text('Desvincular agente'));
      await tester.pumpAndSettle();
      expect(find.text('Trocar agente'), findsNothing);
      expect(QuillDocumentUtils.plainText(controller), 'Descrição preservada');
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  testWidgets(
    'picker supports pagination, empty results, retry and cancellation on mobile',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final source = AgentChoices()..fail = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<ChatTemplateModel>(
                  context: context,
                  builder: (_) => ClueAgentPicker(source: source),
                ),
                child: const Text('Abrir'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Abrir'));
      await tester.pumpAndSettle();
      source.fail = false;
      await tester.tap(
        find.text('Não foi possível carregar. Tentar novamente'),
      );
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Carregar mais agentes'),
        350,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Carregar mais agentes'));
      await tester.pumpAndSettle();
      expect(source.calls, contains(':20'));
      await tester.enterText(find.byType(TextField), 'vazio');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(
        find.text('Nenhum agente encontrado para esta pesquisa.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(ClueAgentPicker), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('older search responses cannot replace newer results', (
    tester,
  ) async {
    final source = DelayedChoices();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ClueAgentPicker(source: source)),
      ),
    );
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'atual');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    source.first.complete([ChatTemplateModel(id: 1, name: 'Resultado antigo')]);
    await tester.pump();
    expect(find.text('Resultado antigo'), findsNothing);
    expect(find.text('Resultado atual'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'linked card opens the selected platform conversation and returns to the pista',
    (tester) async {
      Get.testMode = true;
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/pista',
          getPages: [
            GetPage(
              name: '/pista',
              page: () => const Scaffold(
                body: ClueAgentIntegrationCard(
                  block: ClueIntegration(
                    provider: 'agent',
                    url: '/space/agents/503',
                    title: 'Agente vinculado',
                  ),
                ),
              ),
            ),
            GetPage(
              name: '/space/agents/:id',
              page: () =>
                  Scaffold(body: Text('Conversa ${Get.parameters['id']}')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Conectar-se ao agente'));
      await tester.pumpAndSettle();
      expect(find.text('Conversa 503'), findsOneWidget);
      expect(Get.arguments, {'from_clue': true});
      Get.back();
      await tester.pumpAndSettle();
      expect(find.text('Agente vinculado'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      Get.reset();
    },
  );
}

class DelayedChoices extends ClueAgentSource {
  final first = Completer<List<ChatTemplateModel>>();
  @override
  Future<List<ChatTemplateModel>> search(String query, int offset) =>
      query.isEmpty
      ? first.future
      : Future.value([ChatTemplateModel(id: 2, name: 'Resultado atual')]);
}
