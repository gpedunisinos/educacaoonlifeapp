import 'package:unisinos_usp_app/controllers/user/user_index_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/screens/user/user_index_screen.dart';
import 'package:unisinos_usp_app/controllers/category/category_create_controller.dart';
import 'package:unisinos_usp_app/screens/category/category_create_screen.dart';
import 'package:unisinos_usp_app/controllers/connection_type/connection_type_create_controller.dart';
import 'package:unisinos_usp_app/screens/connection_type/connection_type_create_screen.dart';
import 'package:unisinos_usp_app/controllers/node_type/node_type_create_controller.dart';
import 'package:unisinos_usp_app/screens/node_type/node_type_create_screen.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_create_controller.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_create_screen.dart';
import 'package:unisinos_usp_app/controllers/user/user_create_controller.dart';
import 'package:unisinos_usp_app/screens/user/user_create_screen.dart';
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

class ManagementUsers extends UserIndexController {
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
  for (final mode in ['explorer', 'inventor']) {
    testWidgets('user actions respect $mode mode', (tester) async {
      user(40);
      Get.find<UserController>().user.value = AuthUser(
        id: 1,
        name: 'Teste',
        email: 'test@example.com',
        token: 'test',
        profile: 40,
        usageMode: mode,
      );
      Get.put<UserIndexController>(ManagementUsers()).users.add(
        UserModel(
          id: 2,
          name: 'Pessoa teste',
          email: 'person@example.com',
          profile: 10,
        ),
      );
      await tester.pumpWidget(const GetMaterialApp(home: UserIndexScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Pessoa teste'), findsOneWidget);
      expect(
        find.byTooltip('Novo usuário'),
        mode == 'inventor' ? findsOneWidget : findsNothing,
      );
      expect(
        find.byIcon(Icons.edit),
        mode == 'inventor' ? findsOneWidget : findsNothing,
      );
      expect(
        find.byIcon(Icons.delete_outline),
        mode == 'inventor' ? findsOneWidget : findsNothing,
      );
      expect(tester.takeException(), isNull);
    });
  }
  for (final width in [390.0, 1280.0]) {
    testWidgets('administrative forms remain usable at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      user(40);
      Get.put(CategoryCreateController());
      Get.put(ConnectionTypeCreateController());
      Get.put(NodeTypeCreateController());
      Get.put(ChatTemplateCreateController());
      Get.put(UserCreateController());
      for (final screen in <Widget>[
        const CategoryCreateScreen(),
        const ConnectionTypeCreateScreen(),
        const NodeTypeCreateScreen(),
        const ChatTemplateCreateScreen(),
        const UserCreateScreen(),
      ]) {
        await tester.pumpWidget(GetMaterialApp(home: screen));
        await tester.pumpAndSettle();
        expect(find.text('Voltar à lista'), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      }
    });
  }
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
      expect(find.text('Categorias'), findsWidgets);
      expect(find.text('Tipos de conexão'), findsWidgets);
      expect(find.text('Tipos de problemática'), findsWidgets);
      expect(find.text('Agentes de IA'), findsWidgets);
      expect(find.text('Usuários'), findsWidgets);
      expect(find.text('EM BREVE'), findsNothing);
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
      expect(find.text('Usuários'), findsNothing);
      expect(find.text('Agentes de IA'), findsNothing);
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
