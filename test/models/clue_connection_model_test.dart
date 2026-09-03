import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';

void main() {
  test('parses enriched connection and identifies the related clue', () {
    final connection = ClueConnectionModel.fromJson({
      'id': 7,
      'source_clue_id': 10,
      'target_clue_id': 20,
      'connection_type_id': 3,
      'strength': 4,
      'evidence': 'Observação de campo',
      'source_clue': {
        'id': 10,
        'name': 'Pista de origem',
        'biome_id': 1,
        'category_id': 2,
        'latitude': -29.7,
        'longitude': -51.1,
      },
      'target_clue': {
        'id': 20,
        'name': 'Pista de destino',
        'biome_id': 1,
        'category_id': 2,
        'latitude': -29.8,
        'longitude': -51.2,
      },
      'connection_type': {
        'id': 3,
        'name': 'Influência',
        'stroke_style': 'solid',
        'is_directional': true,
      },
    });

    expect(connection.sourceClue?.name, 'Pista de origem');
    expect(connection.targetClue?.name, 'Pista de destino');
    expect(connection.connectionType?.name, 'Influência');
    expect(connection.isOutgoingFrom(10), isTrue);
    expect(connection.isOutgoingFrom(20), isFalse);
    expect(connection.relatedClueFor(10)?.id, 20);
    expect(connection.relatedClueFor(20)?.id, 10);
  });
}
