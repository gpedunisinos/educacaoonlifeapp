import 'dart:convert';

import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/models/mfile_base_model.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';
import 'package:widgets_spo/services/services.dart';

class AssessmentCompletionWebclient with CRUDMixin<AssessmentCompletionModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'assessment_completions';

  @override
  AssessmentCompletionModel fromJson(Map<String, dynamic> json) => AssessmentCompletionModel.fromJson(json);

  @override
  List<AssessmentCompletionModel> fromJsonArray(List<dynamic> json) => AssessmentCompletionModel.fromJsonArray(json);

  Future<void> addWithFile(AssessmentCompletionModel completionModel, MFileBase file, List<Map<String, dynamic>> answers) async {
    await webClient.postMultipart(
      '/$endpoint',
      file,
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      fileFields: {
        'assessment_id': completionModel.assessmentId?.toString(),
        'user_id': completionModel.userId?.toString(),
        'answers': jsonEncode(answers),
      },
    );
  }

  Future<void> addWithFiles(AssessmentCompletionModel completionModel, List<MFileBase> files, List<Map<String, dynamic>> answers) async {
    await webClient.postMultipartList(
      '/$endpoint',
      files,
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      fileFields: {
        'assessment_id': completionModel.assessmentId?.toString(),
        'user_id': completionModel.userId?.toString(),
        'answers': jsonEncode(answers),
      },
      timeOut: files.isNotEmpty ? 60 * files.length : null, // 60s each file
    );
  }
}
