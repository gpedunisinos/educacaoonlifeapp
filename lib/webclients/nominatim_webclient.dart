import 'package:http/http.dart' as http;
import 'package:unisinos_usp_app/models/nominatim_place_model.dart';

class NominatimWebclient {
  static const String _host = 'nominatim.openstreetmap.org';
  static const String _userAgent = 'unisinos_usp_app/0.7.0';

  Future<List<NominatimPlaceModel>> search({
    required String search,
    int limit = 5,
  }) async {
    final trimmedSearch = search.trim();
    if (trimmedSearch.isEmpty) return <NominatimPlaceModel>[];

    final uri = Uri.https(_host, '/search', {
      'q': trimmedSearch,
      'format': 'jsonv2',
      'addressdetails': '1',
      'limit': limit.toString(),
      'countrycodes': 'br',
    });

    final response = await http.get(
      uri,
      headers: const {
        'Accept': 'application/json',
        'Accept-Language': 'pt-BR,pt;q=0.9,en;q=0.6',
        'User-Agent': _userAgent,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Falha na busca de locais (${response.statusCode}).');
    }

    return NominatimPlaceModel.fromJsonArray(response.body);
  }
}
