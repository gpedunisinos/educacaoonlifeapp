import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';

void main() {
  test('parses the environmental context returned by the API', () {
    final model = LivingClueModel.fromJson({
      'id': 75,
      'name': 'Pista ambiental',
      'biome_id': 1,
      'category_id': 2,
      'latitude': -29.9,
      'longitude': -51.1,
      'environmental_context': {
        'status': 'completed',
        'biome': 'Mata Atlântica',
        'land_cover': 'Área urbanizada',
        'vegetation_percent': 18.2,
        'water_distance_m': 240,
        'altitude_m': 732,
        'slope_percent': 8.4,
        'built_up_percent': 61,
        'population_density_km2': 4270,
        'analyzed_at': '2026-08-29T12:00:00Z',
        'sources': {'mapbiomas': 'collection-4-2025'},
      },
    });

    expect(model.environmentalContext?.status, 'completed');
    expect(model.environmentalContext?.biome, 'Mata Atlântica');
    expect(model.environmentalContext?.vegetationPercent, 18.2);
    expect(
      model.environmentalContext?.sources['mapbiomas'],
      'collection-4-2025',
    );
  });
}
