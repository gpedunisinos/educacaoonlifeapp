import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/widgets/clue_alias_field.dart';
import 'package:unisinos_usp_app/widgets/clue_suggestions.dart';

class FakeDiscovery extends ClueDiscoverySource {
  var dismissed = false;
  String? reviewed;
  @override
  Future<Map<String, dynamic>> load(int id) async => {
    'status': 'ready',
    'suggestions': dismissed
        ? []
        : [
            {
              'id': 9,
              'target_clue_id': 2,
              'target_clue': {
                'id': 2,
                'name': 'Unisinos',
                'category': {'name': 'Instituição'},
              },
              'reason': 'Referência explícita a Unisinos. Confirme a entidade.',
              'evidence': 'Estudei na Unisinos.',
            },
          ],
    'aliases': [
      if (reviewed == null)
        {
          'id': 3,
          'name': 'Nome curto',
          'status': 'pending',
          'evidence': 'Nome completo (Nome curto)',
        },
    ],
    'unresolved': [],
  };
  @override
  Future<void> dismiss(int id, int suggestion) async {
    dismissed = true;
  }

  @override
  Future<void> reviewAlias(int id, int alias, String status) async {
    reviewed = status;
  }
}

void main() {
  final clue = LivingClueModel(id: 1, name: 'Pessoa', categoryId: 1);
  testWidgets(
    'review pre-fills the existing form without creating a connection',
    (tester) async {
      Get.testMode = true;
      addTearDown(Get.reset);
      final source = FakeDiscovery();
      Map? args;
      await tester.pumpWidget(
        GetMaterialApp(
          getPages: [
            GetPage(
              name: '/living_clues/connect',
              page: () {
                args = Get.arguments as Map;
                return const Scaffold(body: Text('Formulário de revisão'));
              },
            ),
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: ClueSuggestions(
                clue: clue,
                canAuthor: true,
                source: source,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Unisinos'), findsOneWidget);
      await tester.ensureVisible(find.text('Revisar conexão'));
      await tester.tap(find.text('Revisar conexão'));
      await tester.pumpAndSettle();
      expect(args?['model'], same(clue));
      expect(args?['targetId'], 2);
      expect(args?['evidence'], 'Estudei na Unisinos.');
      expect(source.dismissed, isFalse);
      expect(source.reviewed, isNull);
      Get.back();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('inventor can dismiss and confirm pending names', (tester) async {
    final source = FakeDiscovery();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ClueSuggestions(clue: clue, canAuthor: true, source: source),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Dispensar'));
    await tester.tap(find.text('Dispensar'));
    await tester.pumpAndSettle();
    expect(source.dismissed, isTrue);
    await tester.ensureVisible(find.text('Confirmar nome'));
    await tester.tap(find.text('Confirmar nome'));
    await tester.pumpAndSettle();
    expect(source.reviewed, 'approved');
    await tester.pumpWidget(const SizedBox.shrink());
  });
  testWidgets(
    'explorer sees evidence but cannot modify aliases or connections',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ClueSuggestions(
                clue: clue,
                canAuthor: false,
                source: FakeDiscovery(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Unisinos'), findsOneWidget);
      expect(find.text('Revisar conexão'), findsNothing);
      expect(find.text('Confirmar nome'), findsNothing);
      expect(find.text('Dispensar'), findsNothing);
    },
  );
  testWidgets(
    'alias field preserves semicolon names and rejects excessive entries',
    (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: form,
              child: ClueAliasField(controller: controller),
            ),
          ),
        ),
      );
      controller.text = 'Unisinos; Nome extenso';
      expect(form.currentState!.validate(), isTrue);
      expect(parseClueAliases(controller.text), ['Unisinos', 'Nome extenso']);
      controller.text = List.generate(21, (i) => 'Nome $i').join(';');
      expect(form.currentState!.validate(), isFalse);
    },
  );
  test('model preserves aliases and omission stays backwards compatible', () {
    final model = LivingClueModel.fromJson({
      'id': 1,
      'name': 'Nome',
      'category_id': 1,
      'aliases': [
        {'name': 'Alternativo', 'status': 'approved'},
        {'name': 'Pendente', 'status': 'pending'},
      ],
    });
    expect(model.aliasNames, ['Alternativo']);
    expect(model.toJson()['alias_names'], ['Alternativo']);
    expect(clue.toJson().containsKey('alias_names'), isFalse);
  });
}
