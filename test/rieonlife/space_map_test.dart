import 'package:unisinos_usp_app/models/environmental_layer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';
import 'package:unisinos_usp_app/controllers/living_clue/environmental_layers_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_map_screen.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/locker_service.dart';
import 'location_picker_test.dart' show OfflineTiles;

class MapUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class MapData extends LivingClueMapController {
  int boundsLoads = 0;
  int scans = 0;
  String query = '';
  @override
  Future<void> loadByBounds(LatLngBounds bounds) async {
    boundsLoads++;
  }

  @override
  Future<void> searchGlobal(String search) async {
    query = search;
  }

  @override
  Future<void> searchAround(LatLng center, double radiusMeters) async {
    scans++;
  }
}

class MapLayers extends EnvironmentalLayersController {
  @override
  Future<void> load() async {}
}

void main() {
  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({
      'living_clue_map_tutorial_seen': true,
    });
    Get.put<UserController>(MapUser()).user.value = const AuthUser(
      id: 1,
      name: 'Teste',
      email: 'test@example.com',
      token: 'test',
      profile: 10,
      usageMode: 'inventor',
    );
    Get.put<AiAssistantContextService>(AiAssistantContextService());
    Get.put(LockerService());
    Get.put<EnvironmentalLayersController>(MapLayers()).layers.add(
      EnvironmentalLayerModel.fromJson({
        'id': 'vegetacao',
        'name': 'Vegetação de teste',
        'tile_url': 'https://example.invalid/{z}/{x}/{y}.png',
        'available': true,
        'legend': [
          {'label': 'Cobertura vegetal', 'color': '#68AB98'},
        ],
      }),
    );
  });
  tearDown(Get.reset);
  testWidgets('explorer can consult the map without authoring actions', (
    tester,
  ) async {
    Get.find<UserController>().user.value = const AuthUser(
      id: 1,
      name: 'Teste',
      email: 'test@example.com',
      token: 'test',
      profile: 10,
      usageMode: 'explorer',
    );
    Get.put<LivingClueMapController>(MapData());
    await tester.pumpWidget(
      GetMaterialApp(home: LivingClueMapScreen(tileProvider: OfflineTiles())),
    );
    await tester.pumpAndSettle();
    expect(find.byTooltip('Criar pista por ponto'), findsNothing);
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (w) =>
                  w is IconButton && w.tooltip == 'Reposicionar pista no mapa',
            ),
          )
          .onPressed,
      isNull,
    );
    expect(
      tester
          .widget<IconButton>(
            find.byWidgetPredicate(
              (w) => w is IconButton && w.tooltip == 'Criar conexão no mapa',
            ),
          )
          .onPressed,
      isNull,
    );
    expect(find.byTooltip('Usar minha localização'), findsOneWidget);
    await tester.tap(find.byTooltip('Ajuda do mapa'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('IARETÉ / GUIA DO MAPA'), findsOneWidget);
    expect(find.text('1/5'), findsOneWidget);
    await tester.tap(find.text('Pular'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  for (final fromCockpit in [true, false]) {
    testWidgets('map returns to cockpit with existing scene: $fromCockpit', (
      tester,
    ) async {
      Get.put<LivingClueMapController>(MapData());
      final cockpitKey = GlobalKey();
      await tester.pumpWidget(
        GetMaterialApp(
          initialRoute: fromCockpit ? '/space' : '/living_clues/map',
          getPages: [
            GetPage(
              name: '/space',
              page: () => Scaffold(
                key: cockpitKey,
                body: TextButton(
                  onPressed: () => Get.toNamed('/living_clues/map'),
                  child: const Text('Abrir mapa'),
                ),
              ),
            ),
            GetPage(
              name: '/living_clues/map',
              page: () => LivingClueMapScreen(tileProvider: OfflineTiles()),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      final existing = cockpitKey.currentContext;
      if (fromCockpit) {
        await tester.tap(find.text('Abrir mapa'));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Voltar ao cockpit'));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/space');
      if (fromCockpit) expect(cockpitKey.currentContext, same(existing));
      expect(find.text('Abrir mapa'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  for (final width in [390.0, 1280.0]) {
    testWidgets('map console preserves controls and marker actions at $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, width < 700 ? 844 : 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final data = Get.put<LivingClueMapController>(MapData()) as MapData;
      data.livingClues.add(
        LivingClueModel(
          id: 1,
          name: 'Pista de teste',
          categoryId: 1,
          latitude: -29.718,
          longitude: -51.143,
          description: 'Uma pista do território.',
        ),
      );
      await tester.pumpWidget(
        GetMaterialApp(home: LivingClueMapScreen(tileProvider: OfflineTiles())),
      );
      await tester.pumpAndSettle();
      expect(find.text('TERRA / EXPLORAÇÃO'), findsOneWidget);
      expect(data.boundsLoads, greaterThan(0));
      final map = tester.widget<FlutterMap>(find.byType(FlutterMap));
      final oldZoom = map.mapController!.camera.zoom;
      await tester.tap(find.byTooltip('Aproximar mapa'));
      await tester.pumpAndSettle();
      expect(map.mapController!.camera.zoom, greaterThan(oldZoom));
      await tester.tap(find.byTooltip('Afastar mapa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sonar'));
      await tester.pumpAndSettle();
      expect(data.scans, 1);
      await tester.enterText(find.byType(TextField), 'território');
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
      expect(data.query, 'território');
      if (width < 700) {
        tester.view.viewInsets = const FakeViewPadding(bottom: 300);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        tester.view.resetViewInsets();
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byTooltip('Limpar pesquisa'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('map-clue-1')));
      await tester.pumpAndSettle();
      expect(find.text('Pista de teste'), findsOneWidget);
      expect(find.text('Ver pista'), findsOneWidget);
      expect(find.text('Editar'), findsOneWidget);
      await tester.tap(find.text('Mover no mapa'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Reposicionando Pista de teste'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Cancelar reposicionamento'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Criar conexão no mapa'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Modo nova conexão'), findsOneWidget);
      await tester.tap(find.byTooltip('Cancelar nova conexão'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Camadas ambientais'));
      await tester.pumpAndSettle();
      expect(find.text('Desativar todas'), findsOneWidget);
      await tester.ensureVisible(find.byType(Switch));
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(
        Get.find<EnvironmentalLayersController>().enabledIds,
        contains('vegetacao'),
      );
      Get.back();
      await tester.pumpAndSettle();
      expect(find.text('Cobertura vegetal'), findsOneWidget);
      await tester.tap(find.byTooltip('Ajuda do mapa'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('IARETÉ / GUIA DO MAPA'), findsOneWidget);
      expect(find.text('Raio do sonar'), findsNothing);
      await tester.tap(find.text('Próximo'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Raio do sonar'), findsOneWidget);
      await tester.tap(find.text('Pular'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
