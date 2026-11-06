import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_update_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/screens/category/category_update_screen.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'management_test.dart' show user;

class _Category extends CategoryUpdateController {
  @override
  // ignore: must_call_super
  void onInit() {
    categoryId = 1;
  }
}

void main() {
  testWidgets(
    'late category load preserves legacy type and does not set state during build',
    (tester) async {
      Get.testMode = true;
      user(40);
      final controller = Get.put<CategoryUpdateController>(_Category());
      await tester.pumpWidget(
        const GetMaterialApp(home: CategoryUpdateScreen()),
      );
      controller.category.value = const CategoryModel(
        id: 1,
        name: 'Categoria anterior',
        type: 'experiencia',
        colorHex: '#9CE7DF',
        metadataTags: 'observacao',
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(find.text('experiencia'), findsOneWidget);
      final color = find.descendant(
        of: find.byWidgetPredicate(
          (w) =>
              w is ManagementInput &&
              (w.hintText ?? '').startsWith('Cor em hex'),
        ),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(color, '#EFBF79');
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      Get.reset();
    },
  );
}
