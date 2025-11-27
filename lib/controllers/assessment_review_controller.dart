import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/assessment_correction_model.dart';
import 'package:unisinos_usp_app/models/assessment_correction_request_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_completion_model.dart';
import 'package:unisinos_usp_app/webclients/assessment_correction_webclient.dart';
import 'package:unisinos_usp_app/webclients/assessment_webclient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class AssessmentReviewController extends GetxController {
  final AssessmentWebclient webclient = AssessmentWebclient();
  final AssessmentCorrectionWebclient correctionWebclient = AssessmentCorrectionWebclient();

  final Rxn<AssessmentModel> inReviewAssessment = Rxn<AssessmentModel>();
  final Rxn<AssessmentCompletionModel> assessCompl = Rxn<AssessmentCompletionModel>();

  final RxList<AssessmentQuestionCompletionModel> questions = <AssessmentQuestionCompletionModel>[].obs;
  final RxMap<int, bool> questionCorrections = <int, bool>{}.obs;
  final Rxn<TextEditingController> correctionNotes = Rxn<TextEditingController>(TextEditingController());

  final RxBool isLoading = false.obs;
  final RxBool isConcluded = false.obs;

  @override
  void onInit() {
    super.onInit();

    final assessmentId = Get.parameters['id'];
    var assessmentCompl = Get.arguments as AssessmentCompletionModel?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (assessmentCompl == null) {
        Get.secureBack(); // theres no way to load the item after user do f5
        return;
      } else {
        assessCompl.value = assessmentCompl;
        isConcluded.value = assessCompl.value?.status != AssessmentCompletionStatusEnum.waitingCorrection;
        fetchById(assessmentId!.toInt());
      }
    });
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      final Map<AssessmentModel, List<AssessmentQuestionCompletionModel>> fetched =
          await webclient.fetchAssessmentAndQuestionCompletionByAssessmentId(id, assessCompl.value!.id);

      final AssessmentCorrectionModel? assessmentCorrection = await correctionWebclient.fetchByAssessmentCompletionId(assessCompl.value!.id);

      if (fetched.isNotEmpty) {
        final assessment = fetched.keys.first;
        final completions = fetched.values.first;

        inReviewAssessment.value = assessment;

        questions.assignAll(completions);

        for (var question in questions) {
          if (question.isCorrect != null) {
            updateCorrectionStatus(question.id, question.isCorrect!);
          }
        }
        correctionNotes.value!.text = assessmentCorrection?.correctionNotes ?? '';
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela Avaliação. $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateCorrectionStatus(int questionCompletionId, bool isCorrect) {
    questionCorrections[questionCompletionId] = isCorrect;
    questionCorrections.refresh();
  }

  AssessmentCorrectionRequestModel createCorrectionRequest() {
    final assessmentComplId = assessCompl.value!.id;

    final List<QuestionCorrection> correctionList = questionCorrections.entries.map((entry) {
      return QuestionCorrection(
        questionCompletionId: entry.key,
        isCorrect: entry.value,
      );
    }).toList();

    return AssessmentCorrectionRequestModel(
      assessmentCompletionId: assessmentComplId,
      teacherId: Get.find<UserController>().user.value!.id,
      questions: correctionList,
      correctionNotes: correctionNotes.value!.text,
    );
  }

  Future<bool> concludeReview() async {
    if (questionCorrections.length != questions.length) {
      Get.snackbar('Atenção', 'Você precisa corrigir todas as questões antes de finalizar.');
      return false;
    }

    try {
      isLoading.value = true;

      final AssessmentCorrectionRequestModel correction = createCorrectionRequest();

      bool result = await webclient.concludeReview(correction);

      if (result) {
        Get.successSnackbar('Revisão concluída com sucesso!');
      }
      return result;
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao concluir revisão. $e');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
