import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/services/services.dart';
import 'package:widgets_spo/widgets_spo.dart';

import 'webclient.dart';

class CategorySelectWebclient {
  final WebClient webClient = WebClient.instance;

  Future<List<ItemSelect>?> select(String? search, int? offset) async {
    final Response response = await webClient.get(
      '/categories_select',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {
        'limit': webClient.defaultLimit.toString(),
        'search': search ?? '',
        'offset': offset?.toString() ?? '0',
      },
    );

    final List<ItemSelect> returnList = ItemSelect.fromJsonArray(response.body);
    return returnList.isEmpty ? null : returnList;
  }
}
