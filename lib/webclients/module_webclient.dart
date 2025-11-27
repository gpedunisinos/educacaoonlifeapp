import 'package:unisinos_usp_app/models/module_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';

class ModuleWebclient with CRUDMixin<ModuleModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'modules';

  @override
  ModuleModel fromJson(Map<String, dynamic> json) => ModuleModel.fromJson(json);

  @override
  List<ModuleModel> fromJsonArray(List<dynamic> json) => ModuleModel.fromJsonArray(json);
}
