import 'package:unisinos_usp_app/models/assessment_available_answer_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';

class AssessmentAvailableAnswerWebclient with CRUDMixin<AssessmentAvailableAnswersModel> {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'assessment_available_answers';

  @override
  AssessmentAvailableAnswersModel fromJson(Map<String, dynamic> json) => AssessmentAvailableAnswersModel.fromJson(json);

  @override
  List<AssessmentAvailableAnswersModel> fromJsonArray(List<dynamic> json) => AssessmentAvailableAnswersModel.fromJsonArray(json);
}
