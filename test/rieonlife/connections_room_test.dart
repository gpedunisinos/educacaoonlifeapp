import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/screens/space/connections_room_screen.dart';

RoomConnection connection(
  int id,
  String source,
  String target,
  String evidence,
) => RoomConnection(
  ClueConnectionModel(
    id: id,
    sourceClueId: id,
    targetClueId: id + 1,
    connectionTypeId: 1,
    strength: 3,
    evidence: evidence,
  ),
  source,
  target,
  'Relacionamento',
);
void main() {
  testWidgets('wall display searches real entries and selects details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final entries = [
      connection(1, 'Rio', 'Território', 'Observação do rio'),
      connection(2, 'Escola', 'Comunidade', 'Encontro na escola'),
    ];
    await tester.pumpWidget(
      MaterialApp(home: ConnectionsRoomScreen(loader: () async => entries)),
    );
    await tester.pumpAndSettle();
    expect(find.text('2 / 2 CONEXÕES'), findsOneWidget);
    await tester.tap(find.text('Escola → Comunidade'));
    await tester.pumpAndSettle();
    expect(find.text('Encontro na escola'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'rio');
    await tester.pumpAndSettle();
    expect(find.text('Rio → Território'), findsOneWidget);
    expect(find.text('Escola → Comunidade'), findsNothing);
    expect(find.text('1 / 2 CONEXÕES'), findsOneWidget);
  });
  testWidgets('room handles failure, retry and an empty collection', (
    tester,
  ) async {
    var fail = true;
    await tester.pumpWidget(
      MaterialApp(
        home: ConnectionsRoomScreen(
          loader: () async {
            if (fail) throw Exception('offline');
            return [];
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar as conexões.'), findsOneWidget);
    fail = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma conexão cadastrada.'), findsOneWidget);
  });
  testWidgets('mobile display opens connection details inside the room', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: ConnectionsRoomScreen(
          loader: () async => [
            connection(1, 'Rio', 'Território', 'Evidência móvel'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rio → Território'));
    await tester.pumpAndSettle();
    expect(find.text('Evidência móvel'), findsOneWidget);
  });
}
