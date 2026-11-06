import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
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
Widget roomApp(Future<List<RoomConnection>> Function() loader) =>
    GetMaterialApp(
      home: ConnectionsRoomScreen(loader: loader),
      getPages: [
        GetPage(
          name: '/space/connections/:id',
          page: () => ConnectionsRoomScreen(
            connectionId: int.parse(Get.parameters['id']!),
            initialConnection: Get.arguments as RoomConnection,
          ),
        ),
      ],
    );
void main() {
  setUp(() => Get.testMode = true);
  tearDown(() => Get.reset());
  testWidgets(
    'list opens a separate detail route and preserves search on return',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final entries = [
        connection(1, 'Rio', 'Território', 'Observação do rio'),
        connection(2, 'Escola', 'Comunidade', 'Encontro na escola'),
      ];
      await tester.pumpWidget(roomApp(() async => entries));
      await tester.pumpAndSettle();
      expect(find.text('2 / 2 CONEXÕES'), findsOneWidget);
      expect(find.text('VÍNCULO SELECIONADO'), findsNothing);
      expect(find.text('Encontro na escola'), findsNothing);
      await tester.enterText(find.byType(TextField), 'escola');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Escola → Comunidade'));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/space/connections/2');
      expect(find.text('Encontro na escola'), findsOneWidget);
      expect(find.text('Detalhes da conexão'), findsOneWidget);
      await tester.tap(find.text('Voltar à lista'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'escola',
      );
      expect(find.text('1 / 2 CONEXÕES'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'rio');
      await tester.pumpAndSettle();
      expect(find.text('Rio → Território'), findsOneWidget);
      expect(find.text('Escola → Comunidade'), findsNothing);
      expect(find.text('1 / 2 CONEXÕES'), findsOneWidget);
    },
  );
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
  testWidgets('mobile opens a full detail screen in the same room', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      roomApp(
        () async => [connection(1, 'Rio', 'Território', 'Evidência móvel')],
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rio → Território'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/space/connections/1');
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text('Detalhes da conexão'), findsOneWidget);
    expect(find.text('Evidência móvel'), findsOneWidget);
    await tester.tap(find.text('Voltar à lista'));
    await tester.pumpAndSettle();
    expect(find.text('Rio → Território'), findsOneWidget);
  });
  testWidgets('detail screen loads by id without a list snapshot', (
    tester,
  ) async {
    var requests = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: ConnectionsRoomScreen(
          connectionId: 7,
          loader: () async {
            requests++;
            return [connection(7, 'Praça', 'Bairro', 'Evidência direta')];
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Detalhes da conexão'), findsOneWidget);
    expect(find.text('Evidência direta'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.byTooltip('Atualizar conexões'));
    await tester.pumpAndSettle();
    expect(requests, 2);
  });
  testWidgets('returning from details preserves list scroll position', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      roomApp(
        () async => List.generate(
          25,
          (i) => connection(i + 1, 'Origem $i', 'Destino $i', 'Evidência $i'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final list = find.byType(ListView);
    await tester.scrollUntilVisible(
      find.text('Origem 20 → Destino 20'),
      400,
      scrollable: find.descendant(of: list, matching: find.byType(Scrollable)),
    );
    final offset = tester.widget<ListView>(list).controller!.offset;
    expect(offset, greaterThan(0));
    await tester.tap(find.text('Origem 20 → Destino 20'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/space/connections/21');
    await tester.tap(find.text('Voltar à lista'));
    await tester.pumpAndSettle();
    expect(tester.widget<ListView>(list).controller!.offset, offset);
  });
}
