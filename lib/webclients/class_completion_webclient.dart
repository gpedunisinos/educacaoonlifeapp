import 'dart:convert';

import 'package:unisinos_usp_app/models/class_completion_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:http/http.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';
import 'package:widgets_spo/services/services.dart';

class ClassCompletionWebclient with CRUDMixin<ClassCompletionModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'class_completions';

  @override
  ClassCompletionModel fromJson(Map<String, dynamic> json) => ClassCompletionModel.fromJson(json);

  @override
  List<ClassCompletionModel> fromJsonArray(List<dynamic> json) => ClassCompletionModel.fromJsonArray(json);

  Future<ClassCompletionModel?> fetchClassCompletion(int classId) async {
    final Response response = await webClient.get(
      '/$endpoint/class/$classId',
      [LoggingInterceptor(), ApiInterceptor(), TokenInterceptor()],
      null,
    );

    var body = jsonDecode(response.body);

    if (body != null) {
      return ClassCompletionModel.fromJson(body);
    }

    return null;
  }
}
