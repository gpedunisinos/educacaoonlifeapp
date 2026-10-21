import 'package:unisinos_usp_app/screens/living_clue/living_clue_show_screen.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/locker_service.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/widgets/living_clue_description_view.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/screens/space/clue_research_room_screen.dart';
import 'package:unisinos_usp_app/screens/space/clue_moon_hologram.dart';

class CluesFake extends ClueResearchSource {
  bool fail = false;
  final lateResult = Completer<List<LivingClueModel>>();
  final items = List.generate(
    43,
    (i) => LivingClueModel(
      id: i + 1,
      name: 'Pista $i',
      categoryId: 1,
      description: i == 42 ? 'Memória distante' : 'Vivência do território $i',
    ),
  );
  @override
  Future<LivingClueModel> clue(int id) async {
    if (fail) throw Exception('offline');
    return items.firstWhere((clue) => clue.id == id);
  }

  @override
  Future<List<LivingClueModel>> search(String query, int offset) async {
    if (fail) throw Exception('offline');
    if (query == 'lenta') return lateResult.future;
    return items
        .where(
          (p) => '${p.name} ${p.description}'.toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .skip(offset)
        .take(20)
        .toList();
  }
}

class ResearchUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class RecordFake extends LivingClueRecordSource {
  RecordFake(this.source);
  final CluesFake source;
  @override
  Future<LivingClueModel> clue(int id) => source.clue(id);
  @override
  Future<List<ClueConnectionModel>> connections(int id) async => [];
}

Widget app(CluesFake source) => GetMaterialApp(
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
  home: ClueResearchRoomScreen(source: source),
  getPages: [
    GetPage(
      name: '/living_clues/type_select',
      page: () => Scaffold(
        body: TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Concluir criação de teste'),
        ),
      ),
    ),
    GetPage(
      name: '/living_clues/:id',
      page: () => LivingClueShowScreen(source: RecordFake(source)),
    ),
    GetPage(
      name: '/space/research/:id',
      page: () => LivingClueShowScreen(
        source: RecordFake(source),
        clueId: int.parse(Get.parameters['id']!),
        initialClue: Get.arguments is LivingClueModel
            ? Get.arguments as LivingClueModel
            : null,
      ),
    ),
  ],
);
void main() {
  setUp(() {
    Get.testMode = true;
    Get.put<UserController>(ResearchUser()).user.value = const AuthUser(
      id: 1,
      name: 'Teste',
      email: 'test@example.com',
      token: 'test',
      profile: 10,
      usageMode: 'inventor',
    );
    Get.put(LockerService());
  });
  tearDown(Get.reset);
  testWidgets('inventor starts clue creation and explorer cannot', (
    tester,
  ) async {
    final source = CluesFake();
    await tester.pumpWidget(app(source));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nova pista'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/living_clues/type_select');
    await tester.tap(find.text('Concluir criação de teste'));
    await tester.pumpAndSettle();
    expect(find.byType(ClueResearchRoomScreen), findsOneWidget);
    final user = Get.find<UserController>();
    user.user.value = const AuthUser(
      id: 1,
      name: 'Teste',
      email: 'test@example.com',
      token: 'test',
      profile: 10,
      usageMode: 'explorer',
    );
    await tester.pumpAndSettle();
    expect(find.text('Criar pista'), findsNothing);
    expect(find.text('Nova pista'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'selection highlights its moon card and detail returns to same search and selection',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(app(CluesFake()));
      await tester.pumpAndSettle();
      final firstSlot = tester
          .widget<ClueMoonHologram>(find.byType(ClueMoonHologram))
          .slot;
      await tester.tap(find.text('Pista 1'));
      await tester.pumpAndSettle();
      final moon = tester.widget<ClueMoonHologram>(
        find.byType(ClueMoonHologram),
      );
      expect(moon.title, 'Pista 1');
      expect(moon.slot, isNot(firstSlot));
      await tester.enterText(find.byType(TextField), 'distante');
      await tester.pumpAndSettle();
      expect(
        tester.widget<ClueMoonHologram>(find.byType(ClueMoonHologram)).title,
        'Pista 42',
      );
      await tester.tap(find.text('Abrir pista'));
      await tester.pumpAndSettle();
      expect(find.text('Abrir registro completo'), findsNothing);
      expect(find.byType(LivingClueShowScreen), findsOneWidget);
      expect(find.text('Relações com outras pistas'), findsOneWidget);
      expect(find.text('Localização'), findsOneWidget);
      expect(find.text('Conversa com a pista viva'), findsOneWidget);
      expect(find.byTooltip('Salvar no Locker'), findsOneWidget);
      expect(find.byTooltip('Editar'), findsOneWidget);
      expect(Get.currentRoute, '/space/research/43');
      expect(find.byType(ClueMoonHologram), findsNothing);
      expect(find.text('Memória distante', findRichText: true), findsWidgets);
      await tester.tap(find.text('Voltar à lista'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'distante',
      );
      expect(
        tester.widget<ClueMoonHologram>(find.byType(ClueMoonHologram)).title,
        'Pista 42',
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'detail loads directly by id without a moon and retries failures',
    (tester) async {
      final source = CluesFake();
      await tester.pumpWidget(app(source));
      await tester.pumpAndSettle();
      source.fail = true;
      Get.toNamed('/space/research/43');
      await tester.pumpAndSettle();
      expect(find.text('Tentar novamente'), findsOneWidget);
      expect(find.byType(ClueMoonHologram), findsNothing);
      source.fail = false;
      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();
      expect(find.text('Memória distante', findRichText: true), findsOneWidget);
      expect(
        tester
            .getSize(
              find.byWidgetPredicate((w) => w is LivingClueDescriptionView),
            )
            .width,
        greaterThan(600),
      );
    },
  );
  testWidgets('legacy clue links use the same complete ship record', (
    tester,
  ) async {
    final source = CluesFake();
    await tester.pumpWidget(app(source));
    await tester.pumpAndSettle();
    Get.toNamed('/living_clues/43');
    await tester.pumpAndSettle();
    expect(find.byType(LivingClueShowScreen), findsOneWidget);
    expect(find.text('EC–01 / ARQUIVO DE PISTAS'), findsOneWidget);
    expect(find.text('Relações com outras pistas'), findsOneWidget);
    expect(find.text('Abrir registro completo'), findsNothing);
    expect(find.byType(ClueMoonHologram), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('pagination, empty search, clear and stale responses', (
    tester,
  ) async {
    final source = CluesFake();
    await tester.pumpWidget(app(source));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Mais pistas'),
      500,
      scrollable: find.descendant(
        of: find.byType(ListView),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.ensureVisible(find.text('Mais pistas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mais pistas'));
    await tester.pumpAndSettle();
    expect(find.textContaining('40 pistas carregadas'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'lenta');
    await tester.pump(const Duration(milliseconds: 301));
    await tester.enterText(find.byType(TextField), 'distante');
    await tester.pumpAndSettle();
    source.lateResult.complete([source.items.first]);
    await tester.pumpAndSettle();
    expect(
      tester.widget<ClueMoonHologram>(find.byType(ClueMoonHologram)).title,
      'Pista 42',
    );
    await tester.enterText(find.byType(TextField), 'inexistente');
    await tester.pumpAndSettle();
    expect(find.textContaining('Nenhuma pista encontrada'), findsOneWidget);
    expect(
      tester.widget<ClueMoonHologram>(find.byType(ClueMoonHologram)).slot,
      isNull,
    );
    await tester.tap(find.byTooltip('Limpar busca'));
    await tester.pumpAndSettle();
    expect(find.textContaining('20 pistas carregadas'), findsOneWidget);
  });
  testWidgets('mobile search, detail and failure recovery fit', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final source = CluesFake()..fail = true;
    await tester.pumpWidget(app(source));
    await tester.pumpAndSettle();
    expect(find.text('Tentar novamente'), findsOneWidget);
    source.fail = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.view.resetViewInsets();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Abrir pista'));
    await tester.pumpAndSettle();
    expect(find.text('Voltar à lista'), findsOneWidget);
    expect(find.byType(ClueMoonHologram), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
