import 'package:unisinos_usp_app/models/certificate_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';

class CertificateWebclient with CRUDMixin<CertificateModel> {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'certificates';

  @override
  CertificateModel fromJson(Map<String, dynamic> json) => CertificateModel.fromJson(json);

  @override
  List<CertificateModel> fromJsonArray(List<dynamic> json) => CertificateModel.fromJsonArray(json);
}
