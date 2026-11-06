import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/widgets/iarete_reply.dart';

void main() {
  testWidgets('new reply reveals bursts, can skip, and history never types', (
    tester,
  ) async {
    var ticks = 0;
    Widget reply(bool animate, {bool reduced = false}) => MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: reduced),
        child: Scaffold(
          body: IareteReply(
            text: 'Olá 🌎! Vamos explorar juntos.',
            animate: animate,
            onType: () => ticks++,
            builder: (text) => Text(text, key: const Key('reply')),
          ),
        ),
      ),
    );
    await tester.pumpWidget(reply(true));
    expect(tester.widget<Text>(find.byKey(const Key('reply'))).data, '');
    await tester.pump(const Duration(milliseconds: 24));
    expect(tester.widget<Text>(find.byKey(const Key('reply'))).data, 'Olá');
    expect(ticks, 1);
    await tester.tap(find.text('Exibir resposta completa'));
    await tester.pump();
    expect(find.text('Olá 🌎! Vamos explorar juntos.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(ticks, 1);
    await tester.pumpWidget(reply(false));
    expect(find.text('Olá 🌎! Vamos explorar juntos.'), findsOneWidget);
    expect(find.text('Exibir resposta completa'), findsNothing);
    expect(ticks, 1);
    await tester.pumpWidget(reply(true, reduced: true));
    expect(find.text('Olá 🌎! Vamos explorar juntos.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    expect(ticks, 1);
  });

  testWidgets('closing a reply cancels pending sound and reveals', (
    tester,
  ) async {
    var ticks = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: IareteReply(
          text: 'Uma resposta longa para revelar',
          animate: true,
          onType: () => ticks++,
          builder: Text.new,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 24));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
    expect(ticks, 1);
    expect(tester.takeException(), isNull);
  });
}
