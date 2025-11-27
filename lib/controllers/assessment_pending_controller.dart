import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/webclients/assessment_completion_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class AssessmentPendingController extends GetxController {
  final AssessmentCompletionWebclient webclient = AssessmentCompletionWebclient();

  final RxList<AssessmentCompletionModel> assessments = <AssessmentCompletionModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({int? trailId}) async {
    try {
      isLoading.value = true;

      Map<String, dynamic>? params = {
        'status': [AssessmentCompletionStatusEnum.waitingCorrection.value.toString()]
      };

      if (trailId != null) {
        params['trail_id'] = trailId.toString();
      }
      List<AssessmentCompletionModel> list = await webclient.fetch(params: params);
      assessments.assignAll(list);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Avaliações. $error');
    } finally {
      isLoading.value = false;
    }
  }
}
