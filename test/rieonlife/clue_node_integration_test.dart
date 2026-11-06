import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/clue_integration.dart';
import 'package:unisinos_usp_app/models/node_model.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:unisinos_usp_app/widgets/clue_node_integration.dart';

class NodeChoices extends ClueNodeSource {
  final calls = <String>[];
  bool fail = false;
  @override
  Future<List<NodeModel>> search(String query, int offset) async {
    calls.add('$query:$offset');
    if (fail) throw Exception('offline');
    if (query == 'vazio') return [];
    if (query.isNotEmpty)
      return [
        NodeModel(
          id: 503,
          color: '#8EDBCB',
          nodeTypeId: 1,
          name: 'Problemática de território',
        ),
      ];
    return offset == 0
        ? List.generate(
            20,
            (i) => NodeModel(
              id: i + 1,
              color: '#8EDBCB',
              nodeTypeId: 1,
              name: 'Problemática ${i + 1}',
            ),
          )
        : [
            NodeModel(
              id: 21,
              color: '#8EDBCB',
              nodeTypeId: 1,
              name: 'Problemática 21',
            ),
          ];
  }
}

void main() {
  test(
    'internal node references roundtrip and reject arbitrary routes and schemes',
    () {
      const integration = ClueIntegration(
        provider: 'node',
        url: '/nodes/graph?focus=503',
        title: 'Problemática de território',
      );
      expect(integration.supported, isTrue);
      expect(integration.nodeId, 503);
      expect(integration.embedURI, isNull);
      expect(ClueIntegration.decode(integration.encode())!.nodeId, 503);
      for (final url in [
        '/nodes/graph?focus=0',
        '/nodes/graph?focus=-1',
        '/nodes/graph?focus=1/messages',
        '/nodes/graph?focus=1?token=x',
        '/nodes/graph?focus=1\n',
        'https://evil.test/nodes/graph?focus=1',
        'javascript:alert(1)',
        '/management',
      ]) {
        expect(
          ClueIntegration.validateURL('node', url),
          isNotNull,
          reason: url,
        );
      }
    },
  );
  testWidgets(
    'search, link, reopen, replace and remove preserve author text and other blocks',
    (tester) async {
      final source = NodeChoices();
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
                      onPressed: () => editClueNodeIntegration(
                        context,
                        controller,
                        source: source,
                      ),
                      child: const Text('Vincular'),
                    ),
                  ),
                  ClueNodeCards(controller: controller, source: source),
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
      await tester.tap(find.text('Problemática de território'));
      await tester.pumpAndSettle();
      expect(find.text('Trocar problemática'), findsOneWidget);
      expect(QuillDocumentUtils.plainText(controller), 'Descrição preservada');
      controller.document = QuillDocumentUtils.fromStored(
        delta: QuillDocumentUtils.encodeDelta(controller),
      );
      await tester.pumpAndSettle();
      expect(find.text('Problemática de território'), findsOneWidget);
      await tester.tap(find.text('Trocar problemática'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Problemática 1'));
      await tester.pumpAndSettle();
      expect(find.text('Problemática 1'), findsOneWidget);
      expect(
        QuillDocumentUtils.encodeDelta(controller),
        isNot(contains('/nodes/graph?focus=503')),
      );
      await tester.tap(find.text('Desvincular problemática'));
      await tester.pumpAndSettle();
      expect(find.text('Trocar problemática'), findsNothing);
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
      final source = NodeChoices()..fail = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showDialog<NodeModel>(
                  context: context,
                  builder: (_) => ClueNodePicker(source: source),
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
        find.text('Carregar mais problemáticas'),
        350,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Carregar mais problemáticas'));
      await tester.pumpAndSettle();
      expect(source.calls, contains(':20'));
      await tester.enterText(find.byType(TextField), 'vazio');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(
        find.text('Nenhuma problemática encontrada para esta pesquisa.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(ClueNodePicker), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('older search responses cannot replace newer results', (
    tester,
  ) async {
    final source = DelayedChoices();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ClueNodePicker(source: source)),
      ),
    );
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'atual');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    source.first.complete([
      NodeModel(
        id: 1,
        color: '#8EDBCB',
        nodeTypeId: 1,
        name: 'Resultado antigo',
      ),
    ]);
    await tester.pump();
    expect(find.text('Resultado antigo'), findsNothing);
    expect(find.text('Resultado atual'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets(
    'linked card opens the selected graph node and returns to the pista',
    (tester) async {
      Get.testMode = true;
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: '/pista',
          getPages: [
            GetPage(
              name: '/pista',
              page: () => const Scaffold(
                body: ClueNodeIntegrationCard(
                  block: ClueIntegration(
                    provider: 'node',
                    url: '/nodes/graph?focus=503',
                    title: 'Problemática vinculada',
                  ),
                ),
              ),
            ),
            GetPage(
              name: '/nodes/graph',
              page: () =>
                  Scaffold(body: Text('Rede ${Get.parameters['focus']}')),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Conectar-se à problemática'));
      await tester.pumpAndSettle();
      expect(find.text('Rede 503'), findsOneWidget);
      expect(Get.arguments, {'from_clue': true});
      Get.back();
      await tester.pumpAndSettle();
      expect(find.text('Problemática vinculada'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      Get.reset();
    },
  );
}

class DelayedChoices extends ClueNodeSource {
  final first = Completer<List<NodeModel>>();
  @override
  Future<List<NodeModel>> search(String query, int offset) => query.isEmpty
      ? first.future
      : Future.value([
          NodeModel(
            id: 2,
            color: '#8EDBCB',
            nodeTypeId: 1,
            name: 'Resultado atual',
          ),
        ]);
}
