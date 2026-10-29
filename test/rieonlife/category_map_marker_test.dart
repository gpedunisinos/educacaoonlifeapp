import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/widgets/category_map_marker.dart';
import 'package:unisinos_usp_app/widgets/category_icon_picker.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

CategoryModel category(
  String name, {
  String? icon,
  String type = CategoryType.geographic,
}) => CategoryModel(
  id: 1,
  name: name,
  type: type,
  colorHex: '#21B6A8',
  metadataTags: '',
  iconCode: icon,
);

void main() {
  test(
    'configured symbols survive API roundtrip; unknown and old codes have safe defaults',
    () {
      expect(categoryMapIconKey(category('Sensor IoT')), 'sensor');
      expect(categoryMapIconKey(category('Planta')), 'leaf');
      expect(categoryMapIconKey(category('Pesquisador')), 'researcher');
      expect(categoryMapIconKey(category('Outros')), 'other');
      expect(
        categoryMapIconKey(category('Nova categoria', type: CategoryType.data)),
        'book',
      );
      expect(
        categoryMapIconKey(category('Nova categoria', icon: 'invalid')),
        'pin',
      );
      expect(categoryMapIconKey(null), 'pin');
      expect(
        categoryMapIconKey(
          category('Planta', icon: Icons.sensors.codePoint.toString()),
        ),
        'sensor',
      );
      final configured = CategoryModel.fromJson(
        category('Planta', icon: 'water').toJson(),
      );
      expect(categoryMapIconKey(configured), 'water');
    },
  );
  testWidgets(
    'visual picker preserves legacy values and changes the stored identifier on mobile',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = TextEditingController(text: 'legacy-code');
      await tester.pumpWidget(
        MaterialApp(
          theme: spaceRecordTheme(),
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: CategoryIconPicker(
                controller: controller,
                name: 'Planta',
                type: CategoryType.geographic,
                color: Colors.green,
              ),
            ),
          ),
        ),
      );
      expect(controller.text, 'legacy-code');
      expect(
        tester.widget<CategoryMapMarker>(find.byType(CategoryMapMarker)).icon,
        Icons.eco_outlined,
      );
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Água').last);
      await tester.tap(find.text('Água').last);
      await tester.pumpAndSettle();
      expect(controller.text, 'water');
      expect(
        tester.widget<CategoryMapMarker>(find.byType(CategoryMapMarker)).icon,
        Icons.water_drop_outlined,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
}
