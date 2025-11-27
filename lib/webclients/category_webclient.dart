import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';

class CategoryWebclient with CRUDMixin<CategoryModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'categories';

  @override
  CategoryModel fromJson(Map<String, dynamic> json) => CategoryModel.fromJson(json);

  @override
  List<CategoryModel> fromJsonArray(List<dynamic> json) => CategoryModel.fromJsonArray(json);
}
