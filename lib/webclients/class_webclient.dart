import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';

class ClassWebclient with CRUDMixin<ClassModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'classes';

  @override
  ClassModel fromJson(Map<String, dynamic> json) => ClassModel.fromJson(json);

  @override
  List<ClassModel> fromJsonArray(List<dynamic> json) => ClassModel.fromJsonArray(json);
}
