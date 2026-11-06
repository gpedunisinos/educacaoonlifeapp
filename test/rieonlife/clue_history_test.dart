import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/clue_participation.dart';

void main() {
  testWidgets('creation and edits show their actual event labels and authors', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ClueEditHistory(
              clueId: 12,
              fetchEvents: (offset) async {
                calls++;
                return [
                  {
                    'event_type': 'updated',
                    'description': 'Pista editada',
                    'author': {'name': 'Pesquisadora'},
                    'created_at': '2026-11-06T12:00:00Z',
                  },
                  {
                    'event_type': 'created',
                    'description': 'Pista criada',
                    'author': {'name': 'Autoria não registrada'},
                    'created_at': '2026-11-05T12:00:00Z',
                  },
                ];
              },
            ),
          ),
        ),
      ),
    );
    expect(calls, 0);
    await tester.tap(find.text('Histórico da pista'));
    await tester.pumpAndSettle();
    expect(find.text('Pista criada'), findsOneWidget);
    expect(find.text('Pista editada'), findsOneWidget);
    expect(find.textContaining('Autoria não registrada'), findsOneWidget);
    expect(calls, 1);
  });
  testWidgets(
    'failed history request does not masquerade as an empty history',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClueEditHistory(
              clueId: 12,
              fetchEvents: (_) async => throw StateError('offline'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Histórico da pista'));
      await tester.pumpAndSettle();
      expect(find.text('Histórico indisponível.'), findsOneWidget);
      expect(find.text('Nenhum evento registrado.'), findsNothing);
      expect(find.text('Carregar histórico'), findsOneWidget);
    },
  );
}
