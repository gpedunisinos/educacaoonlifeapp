import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/controllers/living_clue/environmental_layers_controller.dart';
import 'package:unisinos_usp_app/models/environmental_layer_model.dart';

class Catalog extends EnvironmentalLayersController {
  @override
  Future<void> load() async {}
}

void main() {
  test(
    'map entry prefers available satellite but permits manual switching',
    () async {
      final controller = Catalog();
      controller.layers.add(
        EnvironmentalLayerModel.fromJson({
          'id': 'satellite',
          'map_role': 'basemap',
          'available': true,
        }),
      );
      await controller.openWithSatellite();
      expect(controller.selectedExternalBaseMap?.id, 'satellite');
      controller.selectedBaseMapId.value = 'osm';
      expect(controller.selectedExternalBaseMap, isNull);
      await controller.openWithSatellite();
      expect(controller.selectedExternalBaseMap?.id, 'satellite');
    },
  );
  test('map stays usable when satellite is unavailable', () async {
    final controller = Catalog();
    controller.layers.add(
      EnvironmentalLayerModel.fromJson({
        'id': 'satellite',
        'map_role': 'basemap',
        'available': false,
      }),
    );
    await controller.openWithSatellite();
    expect(controller.selectedBaseMapId.value, 'osm');
  });
}
