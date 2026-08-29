import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/environmental_layer_model.dart';

void main() {
  test('converte catálogo ambiental com legenda e fonte', () {
    final layer = EnvironmentalLayerModel.fromJson({
      'id': 'biomes',
      'name': 'Biomas',
      'description': 'Limites',
      'tile_url': '/api/environmental_tiles/biomes/{z}/{x}/{y}.png',
      'default_opacity': 0.35,
      'min_zoom': 3,
      'max_zoom': 12,
      'available': true,
      'legend': [
        {'label': 'Pampa', 'color': '#dfc27d'}
      ],
      'source': {'name': 'IBGE', 'version': '2022'},
    });

    expect(layer.id, 'biomes');
    expect(layer.available, isTrue);
    expect(layer.legend.single.label, 'Pampa');
    expect(layer.sourceName, 'IBGE');
  });
}
