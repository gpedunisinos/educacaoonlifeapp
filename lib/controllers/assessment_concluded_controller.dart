import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/utils/file_utils.dart';
import 'package:unisinos_usp_app/webclients/assessment_completion_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/models/mfile_base_model.dart';
import 'package:widgets_spo/utils.dart';

class AssessmentConcludedController extends GetxController {
  final AssessmentCompletionWebclient webclient = AssessmentCompletionWebclient();

  final RxList<AssessmentCompletionModel> assessments = <AssessmentCompletionModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchConcludedOnly();
  }

  Future<void> fetch({int? offset}) async {
    try {
      isLoading.value = true;

      Map<String, dynamic>? params = {
        'status': [
          AssessmentCompletionStatusEnum.waitingCorrection.value.toString(),
          AssessmentCompletionStatusEnum.approved.value.toString(),
          AssessmentCompletionStatusEnum.repproved.value.toString(),
        ]
      };

      List<AssessmentCompletionModel> list = await webclient.fetch(offset: offset, params: params);
      assessments.assignAll(list);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Avaliações. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchConcludedOnly({int? offset}) async {
    try {
      isLoading.value = true;

      Map<String, dynamic>? params = {
        'status': [
          AssessmentCompletionStatusEnum.approved.value.toString(),
          AssessmentCompletionStatusEnum.repproved.value.toString(),
        ]
      };

      List<AssessmentCompletionModel> list = await webclient.fetch(offset: offset, params: params);
      assessments.assignAll(list);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Avaliações. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> send(AssessmentModel assessmentModel, int userId,
      {required List<Map<String, dynamic>> answers, required RxList<MFileBase> files}) async {
    try {
      isLoading.value = false;

      AssessmentCompletionModel completionModel = AssessmentCompletionModel.fromAssessment(
        assessmentModel,
        userId: userId,
        files: files,
      );

      await Future.wait(files.map((file) => FileUtils.prepareFileStream(file)));

      final List<Map<String, dynamic>> filteredAnswers = answers.where((answer) {
        final answerId = answer['answer_id'];
        final answerText = answer['answer_text'];

        return answerId != null || (answerText != null && (answerText as String).trim().isNotEmpty);
      }).toList();

      await webclient.addWithFiles(completionModel, files, filteredAnswers);

      Get.successSnackbar('Avaliação concluída com sucesso!');

      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao enviar Avaliação. $error');
    } finally {
      isLoading.value = false;
    }

    return false;
  }
}
