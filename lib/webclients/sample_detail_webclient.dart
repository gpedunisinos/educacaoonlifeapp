import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/widgets_spo.dart';

import 'webclient.dart';

class SampleDetailWebclient {
  final WebClient webClient = WebClient.instance;

  Future<List<ItemSelect>?> select(String? search, int? offset, Map<String, String?>? params) async {
    final Response response = await webClient.get(
      '/samples_detail_select',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {
        'limit': webClient.defaultLimit.toString(),
        'search': search ?? '',
      },
    );

    final List<ItemSelect> returnList = ItemSelect.fromJsonArray(response.body);
    return returnList.isEmpty ? null : returnList;
  }
}
