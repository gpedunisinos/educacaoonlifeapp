import 'package:http_interceptor/http_interceptor.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:widgets_spo/services/services.dart';
import 'package:widgets_spo/widgets_spo.dart';

import 'webclient.dart';

class CategorySelectWebclient {
  final WebClient webClient = WebClient.instance;
  final CategoryWebclient _categoryWebclient = CategoryWebclient();

  Future<List<ItemSelect>?> select(
    String? search,
    int? offset, {
    String? type,
  }) async {
    final List<CategoryModel> categories = await _categoryWebclient.fetch();
    final String normalizedSearch = (search ?? '').trim().toLowerCase();

    final List<ItemSelect> returnList = categories
        .where((category) => type == null || category.type == type)
        .where((category) {
          if (normalizedSearch.isEmpty) return true;
          return category.name.toLowerCase().contains(normalizedSearch);
        })
        .map(
          (category) => ItemSelect(
            id: category.id,
            name: category.name,
          ),
        )
        .toList();

    return returnList.isEmpty ? null : returnList;
  }
}
