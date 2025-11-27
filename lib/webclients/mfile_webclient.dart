import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/file_mixin.dart';

class MFileWebclient with FileMixin<MFile>, CRUDMixin<MFile> {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'files';

  @override
  MFile fromJson(Map<String, dynamic> json) => MFile.fromJson(json);

  @override
  List<MFile> fromJsonArray(List<dynamic> json) => MFile.fromJsonArray(json);
}
