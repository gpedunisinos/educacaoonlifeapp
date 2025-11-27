import 'dart:convert';

import 'package:unisinos_usp_app/models/assessment_correction_request_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_completion_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:http/http.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';
import 'package:widgets_spo/services/services.dart';

class AssessmentWebclient with CRUDMixin<AssessmentModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'assessments';

  @override
  AssessmentModel fromJson(Map<String, dynamic> json) => AssessmentModel.fromJson(json);

  @override
  List<AssessmentModel> fromJsonArray(List<dynamic> json) => AssessmentModel.fromJsonArray(json);

  Future<Map<AssessmentModel, List<AssessmentQuestionCompletionModel>>> fetchAssessmentAndQuestionCompletionByAssessmentId(
      int assessmentId, int assessComplId) async {
    final AssessmentModel assessment = await fetchById(assessmentId);

    final Map<String, String?> params = {'assessment_completion_id': assessComplId.toString()};

    final Response response = await webClient.get(
      '/assessment_question_completions',
      [LoggingInterceptor(), ApiInterceptor(), TokenInterceptor()],
      params,
    );

    final List<AssessmentQuestionCompletionModel> questions = AssessmentQuestionCompletionModel.fromJsonArray(jsonDecode(response.body));

    return {assessment: questions};
  }

  Future<bool> concludeReview(AssessmentCorrectionRequestModel correction) async {
    final Response response = await webClient.post(
      '/assessment_corrections',
      jsonEncode(correction.toJson()),
      [LoggingInterceptor(), ApiInterceptor(), TokenInterceptor()],
    );

    if (response.statusCode >= 200 && response.statusCode <= 201) {
      return true;
    } else {
      return false;
    }
  }
}
