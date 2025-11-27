import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';

class AssessmentQuestionWebclient with CRUDMixin<AssessmentQuestionModel> {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'assessment_questions';

  @override
  AssessmentQuestionModel fromJson(Map<String, dynamic> json) => AssessmentQuestionModel.fromJson(json);

  @override
  List<AssessmentQuestionModel> fromJsonArray(List<dynamic> json) => AssessmentQuestionModel.fromJsonArray(json);
}
