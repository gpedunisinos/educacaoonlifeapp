import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/connection_type_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/widgets/clue_connections_list.dart';

List<ClueConnectionModel> connections(int count) => List.generate(
  count,
  (i) => ClueConnectionModel(
    id: i + 1,
    sourceClueId: 7,
    targetClueId: 100 + i,
    connectionTypeId: 1,
    connectionType: ConnectionTypeModel(id: 1, name: 'Autor de'),
    targetClue: LivingClueModel(
      id: 100 + i,
      name: i == count - 1 ? 'Educação em conexão' : 'Artigo $i',
      categoryId: 16,
    ),
  ),
);

Widget app(List<ClueConnectionModel> items, {ValueChanged<int>? onOpen}) =>
    MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SingleChildScrollView(
          child: ClueConnectionsList(
            clueId: 7,
            connections: items,
            itemBuilder: (_, connection) => ListTile(
              title: Text(connection.targetClue!.name),
              onTap: () => onOpen?.call(connection.targetClueId),
            ),
          ),
        ),
      ),
    );

void main() {
  testWidgets('up to five relationships need no search or expansion', (
    tester,
  ) async {
    await tester.pumpWidget(app(connections(5)));
    expect(find.byType(ListTile), findsNWidgets(5));
    expect(find.byType(TextField), findsNothing);
    expect(find.textContaining('Ver todas'), findsNothing);
  });

  testWidgets('six relationships start collapsed and can expand and collapse', (
    tester,
  ) async {
    await tester.pumpWidget(app(connections(6)));
    expect(find.byType(ListTile), findsNWidgets(5));
    expect(find.text('Educação em conexão'), findsNothing);
    await tester.tap(find.text('Ver todas (6)'));
    await tester.pumpAndSettle();
    expect(find.text('Educação em conexão'), findsOneWidget);
    await tester.ensureVisible(find.text('Recolher'));
    await tester.tap(find.text('Recolher'));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsNWidgets(5));
  });

  testWidgets(
    'search includes hidden entries, ignores accents and keeps opening',
    (tester) async {
      int? opened;
      await tester.pumpWidget(
        app(connections(110), onOpen: (id) => opened = id),
      );
      await tester.enterText(find.byType(TextField), 'CONEXAO educacao');
      await tester.pump();
      expect(find.text('Educação em conexão'), findsOneWidget);
      expect(find.text('1 de 110 relações encontradas'), findsOneWidget);
      await tester.tap(find.text('Educação em conexão'));
      expect(opened, 209);
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pump();
      expect(
        find.text('Nenhuma pista encontrada para esta pesquisa.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Limpar pesquisa'));
      await tester.pump();
      expect(find.byType(ListTile), findsNWidgets(5));
    },
  );

  testWidgets('large expanded list fits a narrow mobile viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(app(connections(110)));
    await tester.ensureVisible(find.text('Ver todas (110)'));
    await tester.tap(find.text('Ver todas (110)'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(ListTile).evaluate().length, lessThan(110));
  });
}
