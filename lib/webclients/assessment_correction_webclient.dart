import 'package:unisinos_usp_app/models/assessment_correction_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';

class AssessmentCorrectionWebclient with CRUDMixin<AssessmentCorrectionModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'assessment_corrections';

  @override
  AssessmentCorrectionModel fromJson(Map<String, dynamic> json) => AssessmentCorrectionModel.fromJson(json);

  @override
  List<AssessmentCorrectionModel> fromJsonArray(List<dynamic> json) => AssessmentCorrectionModel.fromJsonArray(json);

  Future<AssessmentCorrectionModel?> fetchByAssessmentCompletionId(int assessmentComplId) async {
    final List<AssessmentCorrectionModel> assessment = await fetch(params: {'assessment_completion_id': assessmentComplId.toString()});

    return assessment.firstOrNull;
  }
}
