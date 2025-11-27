import 'package:unisinos_usp_app/models/configuration_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';

class ConfigurationWebclient with CRUDMixin<ConfigurationModel> {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'configurations';

  @override
  ConfigurationModel fromJson(Map<String, dynamic> json) => ConfigurationModel.fromJson(json);

  @override
  List<ConfigurationModel> fromJsonArray(List<dynamic> json) => ConfigurationModel.fromJsonArray(json);
}
