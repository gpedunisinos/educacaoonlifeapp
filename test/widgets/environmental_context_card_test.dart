import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/environmental_context_card.dart';

void main() {
  testWidgets('oferece análise quando o contexto ainda não existe',
      (tester) async {
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

    expect(find.text('O contexto deste território ainda não foi analisado.'),
        findsOneWidget);
    expect(find.text('Analisar agora'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.text('Analisar agora'));
    expect(retryCalled, isTrue);
  });
}
