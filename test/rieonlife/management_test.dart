import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/screens/management/management_home_screen.dart';
import 'package:unisinos_usp_app/screens/space/connections_room_screen.dart';

class ManagementUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

void user(int profile) {
  Get.put<UserController>(ManagementUser()).user.value = AuthUser(
    id: 1,
    name: 'Teste',
    email: 'test@example.com',
    token: 'test',
    profile: profile,
    usageMode: 'inventor',
  );
}

final items = [
  RoomConnection(
    ClueConnectionModel(
      id: 1,
      sourceClueId: 1,
      targetClueId: 2,
      connectionTypeId: 1,
      strength: 3,
      evidence: 'Memória do rio',
    ),
    'Rio',
    'Escola',
    'Pertencimento',
  ),
];
Widget app(Future<List<RoomConnection>> Function() loader) => GetMaterialApp(
  home: const ManagementHomeScreen(),
  getPages: [
    GetPage(
      name: '/management/connections',
      page: () => ConnectionsRoomScreen(management: true, loader: loader),
    ),
    GetPage(
      name: '/management/connections/:id',
      page: () => ConnectionsRoomScreen(
        management: true,
        connectionId: int.parse(Get.parameters['id']!),
        initialConnection: Get.arguments is RoomConnection
            ? Get.arguments as RoomConnection
            : null,
        loader: loader,
      ),
    ),
  ],
);
void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);
  testWidgets(
    'central opens connections, searches and keeps state after detail',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      user(40);
      await tester.pumpWidget(app(() async => items));
      await tester.pumpAndSettle();
      expect(find.text('Organização da pesquisa'), findsWidgets);
      await tester.tap(find.text('Abrir conexões'));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/management/connections');
      await tester.enterText(find.byType(TextField), 'Rio');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Rio → Escola'));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/management/connections/1');
      expect(find.text('Memória do rio'), findsOneWidget);
      await tester.tap(find.text('Voltar à lista'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Rio',
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'regular user sees relations without administration placeholders',
    (tester) async {
      user(10);
      await tester.pumpWidget(app(() async => items));
      await tester.pumpAndSettle();
      expect(find.text('Conexões entre pistas'), findsOneWidget);
      expect(find.text('Pessoas'), findsNothing);
      expect(find.text('Inteligências'), findsNothing);
    },
  );
  testWidgets('mobile central uses drawer and connection loading can retry', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    user(40);
    var failed = true;
    await tester.pumpWidget(
      app(() async {
        if (failed) throw Exception('offline');
        return items;
      }),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Menu de gestão'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Conexões'));
    await tester.pumpAndSettle();
    expect(find.text('Tentar novamente'), findsOneWidget);
    failed = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(find.text('Rio → Escola'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
