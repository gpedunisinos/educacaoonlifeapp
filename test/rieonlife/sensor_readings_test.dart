import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/models/sensor_reading_model.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_show_screen.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/widgets/clue_sensor_readings.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/locker_service.dart';

SensorReadingModel reading(int id, {String? payload}) => SensorReadingModel(
  id: id,
  livingClueId: 72,
  receivedAt: DateTime.utc(2026, 10, 28, 14, 30),
  contentType: 'application/json',
  payloadRaw:
      payload ??
      '{"Temperatura":24.5,"CO2":420,"unidades":{"Temperatura":"°C","CO2":"ppm"},"dados_ficticios":true}',
);
Widget panel(
  List<SensorReadingModel> readings, {
  Future<void> Function()? refresh,
  bool busy = false,
  String? error,
}) => MaterialApp(
  theme: spaceRecordTheme(),
  home: Scaffold(
    body: SingleChildScrollView(
      child: ClueSensorReadings(
        readings: readings,
        onRefresh: refresh ?? () async {},
        refreshing: busy,
        error: error,
      ),
    ),
  ),
);

class _User extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class _Source extends LivingClueRecordSource {
  int loads = 0;
  bool fail = false;
  final items = <SensorReadingModel>[reading(1)];
  @override
  Future<LivingClueModel> clue(int id) async {
    loads++;
    if (fail) throw Exception('offline');
    return LivingClueModel(
      id: 72,
      name: 'Pista de sensores',
      categoryId: 1,
      sensorReadings: List.of(items),
    );
  }

  @override
  Future<List<ClueConnectionModel>> connections(int id) async => [];
}

void main() {
  test('API observations are parsed without leaking into clue writes', () {
    final clue = LivingClueModel.fromJson({
      'id': 72,
      'name': 'Pista',
      'category_id': 1,
      'sensor_readings': [
        {
          'id': '41',
          'living_clue_id': 72,
          'created_at': '2026-10-28T14:30:00Z',
          'content_type': 'application/json',
          'payload_raw': '{"Temperatura":24.5,"unidades":{"Temperatura":"°C"}}',
        },
        null,
        'legacy',
      ],
    });
    expect(clue.sensorReadings.single.id, 41);
    expect(clue.sensorReadings.single.units['Temperatura'], '°C');
    expect(
      clue.sensorReadings.single.receivedAt,
      DateTime.utc(2026, 10, 28, 14, 30),
    );
    expect(clue.toJson().containsKey('sensor_readings'), isFalse);
    expect(
      LivingClueModel.fromJson({
        'id': 1,
        'name': 'Pista',
        'category_id': 1,
      }).sensorReadings,
      isEmpty,
    );
  });
  for (final size in [
    const Size(390, 844),
    const Size(844, 390),
    const Size(1280, 800),
  ]) {
    testWidgets('latest reading, provided units and history fit $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        panel([
          reading(1, payload: '{"Temperatura":20}'),
          reading(3),
          reading(2, payload: '{"Temperatura":23}'),
        ]),
      );
      await tester.pump();
      expect(find.text('ÚLTIMA LEITURA RECEBIDA'), findsOneWidget);
      expect(find.text('24.5 °C'), findsOneWidget);
      expect(find.text('420 ppm'), findsOneWidget);
      expect(
        find.text('Dados sinalizados como fictícios pelo dispositivo'),
        findsOneWidget,
      );
      final previous = find.text('Leituras anteriores (2)');
      await tester.ensureVisible(previous);
      await tester.tap(previous);
      await tester.pumpAndSettle();
      expect(find.text('Registro #2'), findsWidgets);
      expect(find.text('Registro #1'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('raw JSON and text remain readable and copied exactly', (
    tester,
  ) async {
    const raw = '<sensor>temperatura=20</sensor>\ntexto de origem';
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData')
          copied = (call.arguments as Map)['text'] as String;
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(panel([reading(4, payload: raw)]));
    expect(find.text(raw), findsOneWidget);
    await tester.tap(find.text('Ver dados completos'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Copiar dados'));
    await tester.tap(find.text('Copiar dados'));
    await tester.pump();
    expect(copied, raw);
    expect(tester.takeException(), isNull);
  });
  testWidgets('empty, failure and in-progress states preserve refresh access', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      panel(
        [],
        refresh: () async {
          calls++;
        },
      ),
    );
    expect(
      find.text('Nenhuma leitura de sensor recebida para esta pista.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Atualizar leituras'));
    expect(calls, 1);
    await tester.pumpWidget(
      panel([reading(1)], busy: true, error: 'Falha ao atualizar'),
    );
    expect(find.text('24.5 °C'), findsOneWidget);
    expect(find.text('Falha ao atualizar'), findsOneWidget);
    expect(
      tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'record shortcut reaches sensors; refresh fetches new observations and keeps data on failure',
    (tester) async {
      Get.testMode = true;
      Get.put<UserController>(_User()).user.value = const AuthUser(
        id: 1,
        name: 'Teste',
        email: 'test@example.com',
        token: 'test',
        profile: 10,
        usageMode: 'explorer',
      );
      Get.put(LockerService());
      addTearDown(Get.reset);
      final source = _Source();
      await tester.pumpWidget(
        GetMaterialApp(home: LivingClueShowScreen(clueId: 72, source: source)),
      );
      await tester.pump();
      await tester.pump();
      await tester.tap(find.byTooltip('Ver leituras dos sensores'));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      final update = find.text('Atualizar leituras');
      await tester.ensureVisible(update);
      source.items.add(
        reading(
          2,
          payload: '{"Temperatura":26,"unidades":{"Temperatura":"°C"}}',
        ),
      );
      await tester.tap(update);
      await tester.pump();
      await tester.pump();
      expect(find.text('26 °C'), findsOneWidget);
      expect(source.loads, 2);
      source.fail = true;
      await tester.ensureVisible(update);
      await tester.tap(update);
      await tester.pump();
      await tester.pump();
      expect(find.text('26 °C'), findsOneWidget);
      expect(
        find.textContaining('Os registros já carregados foram preservados'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
    },
  );
}
