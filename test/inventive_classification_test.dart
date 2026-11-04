import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/inventive/inventive_catalog.dart';
import 'package:unisinos_usp_app/widgets/inventive_classification_fields.dart';

void main() {
  test('catalog codes and references stay stable and independent', () {
    expect(InventiveCatalog.options(InventiveCatalog.practicesKey).length, 10);
    expect(
      InventiveCatalog.options(InventiveCatalog.methodologiesKey).length,
      3,
    );
    expect(InventiveCatalog.concepts.map((c) => c.code).toSet().length, 13);
    expect(InventiveCatalog.find(InventiveCatalog.practicesKey, 'pag'), isNull);
    for (final concept in InventiveCatalog.concepts) {
      expect(Uri.parse(concept.url).hasAuthority, isTrue);
    }
  });
  test('patch preserves all unconfigured metadata and JSON types', () {
    final original = <String, dynamic>{
      'cidade': 'Bom Princípio',
      'future': {
        'a': [1, 2],
      },
      'generic_list': ['a'],
      'praticas_inventivas': ['niig', 'future_code'],
      'metodologias_inventivas': 'antigo',
    };
    final saved = mergeClueMetadata(
      original,
      {'cidade': 'Porto Alegre', 'generic_list': '[a]'},
      {'praticas_inventivas': <String>[]},
    );
    expect(saved['cidade'], 'Porto Alegre');
    expect(saved['future'], original['future']);
    expect(saved['generic_list'], ['a']);
    expect(saved['praticas_inventivas'], isEmpty);
    expect(saved['metodologias_inventivas'], 'antigo');
    expect(original['praticas_inventivas'], ['niig', 'future_code']);
  });
  test('missing, null, arrays, unknown codes and legacy are distinguished', () {
    expect(InventiveCatalog.codes(null), isEmpty);
    expect(InventiveCatalog.isLegacy(null), isFalse);
    expect(InventiveCatalog.isLegacy(['niig']), isFalse);
    for (final value in [
      '[niig]',
      12,
      {'a': true},
      ['niig', 2],
    ]) {
      expect(InventiveCatalog.isLegacy(value), isTrue);
      expect(
        mergeClueMetadata(
          {'praticas_inventivas': value},
          {},
          {},
        )['praticas_inventivas'],
        value,
      );
    }
    expect(
      InventiveCatalog.label(InventiveCatalog.practicesKey, 'future'),
      'Classificação não reconhecida nesta versão',
    );
  });
  Future<void> mount(
    WidgetTester tester, {
    Map<String, dynamic> metadata = const {},
    List<String> enabled = InventiveCatalog.keys,
    void Function(String, dynamic)? onChanged,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: InventiveClassificationFields(
              metadata: metadata,
              enabledKeys: enabled,
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('classification cards align at a consistent size on mobile', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(
      tester,
      metadata: {
        'praticas_inventivas': ['saigon', 'niig'],
        'metodologias_inventivas': ['pag', 'bv'],
      },
    );
    final chips = find.byType(InputChip);
    expect(chips, findsNWidgets(4));
    final sizes = List.generate(4, (i) => tester.getSize(chips.at(i)));
    expect(sizes.map((size) => size.width).toSet(), hasLength(1));
    expect(sizes.map((size) => size.height).toSet(), hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'explanations and cancel never select; confirm returns an array',
    (tester) async {
      final changes = <String, dynamic>{};
      await mount(tester, onChanged: (key, value) => changes[key] = value);
      await tester.tap(find.text('Selecionar práticas'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.info_outline).first);
      await tester.pumpAndSettle();
      expect(find.textContaining('Prática que articula'), findsOneWidget);
      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pump();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(changes, isEmpty);
      await tester.tap(find.text('Selecionar práticas'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pump();
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();
      expect(changes, {
        'praticas_inventivas': ['saigon'],
      });
    },
  );
  testWidgets(
    'category without configuration still shows saved classification and clear is explicit',
    (tester) async {
      final changes = <String, dynamic>{};
      await mount(
        tester,
        enabled: [],
        metadata: {
          'praticas_inventivas': ['niig', 'future'],
        },
        onChanged: (k, v) => changes[k] = v,
      );
      expect(find.textContaining('NIIG —'), findsOneWidget);
      expect(
        find.text('Classificação não reconhecida nesta versão'),
        findsOneWidget,
      );
      await tester.tap(find.text('Selecionar práticas'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Limpar seleção'));
      await tester.pump();
      expect(changes, isEmpty);
      await tester.tap(find.text('Confirmar'));
      await tester.pumpAndSettle();
      expect(changes['praticas_inventivas'], <String>[]);
    },
  );
  testWidgets('explorer sees concept chips without edit controls', (
    tester,
  ) async {
    await mount(
      tester,
      metadata: {
        'metodologias_inventivas': ['pag'],
      },
    );
    expect(find.text('Metodologias'), findsOneWidget);
    expect(find.text('Selecionar metodologias'), findsNothing);
    expect(tester.widget<InputChip>(find.byType(InputChip)).onDeleted, isNull);
    await tester.tap(find.textContaining('PAG —'));
    await tester.pumpAndSettle();
    expect(find.text('Schlemmer, 2018'), findsOneWidget);
  });
  testWidgets('mobile wraps long tags and scrolls the complete catalog', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(
      tester,
      metadata: {
        'praticas_inventivas': InventiveCatalog.options(
          InventiveCatalog.practicesKey,
        ).map((c) => c.code).toList(),
      },
      onChanged: (k, v) {},
    );
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Selecionar práticas'), 200);
    await tester.tap(find.text('Selecionar práticas'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
