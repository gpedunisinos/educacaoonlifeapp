import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/environmental_context_card.dart';
import 'package:unisinos_usp_app/models/environmental_context_model.dart';

void main() {
  testWidgets('fontes longas e estruturadas cabem em uma tela estreita', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: EnvironmentalContextCard(
              context: EnvironmentalContextModel(
                status: 'completed',
                sources: {
                  'cobertura_vegetal':
                      'colecao-2025-com-uma-versao-e-identificador-bastante-longos',
                  'altitude': {'provedor': 'Fonte de dados', 'versao': '2025'},
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Fontes e versões'));
    await tester.pumpAndSettle();
    expect(find.text('Cobertura Vegetal'), findsOneWidget);
    expect(find.text('Provedor: Fonte de dados\nVersao: 2025'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('oferece análise quando o contexto ainda não existe', (
    tester,
  ) async {
    var retryCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EnvironmentalContextCard(
            context: null,
            onRetry: () => retryCalled = true,
          ),
        ),
      ),
    );

    expect(
      find.text('O contexto deste território ainda não foi analisado.'),
      findsOneWidget,
    );
    expect(find.text('Analisar agora'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text('Analisar agora'));
    expect(retryCalled, isTrue);
  });
}
