import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/webclients/assessment_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/models/mfile_base_model.dart';
import 'package:widgets_spo/utils.dart';

class AssessmentController extends GetxController {
  AssessmentWebclient webclient = AssessmentWebclient();

  Rxn<AssessmentModel> assessment = Rxn<AssessmentModel>();
  RxList<MFileBase> selectedFiles = <MFileBase>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final assessmentId = Get.parameters['id'];

    if (assessmentId != null) {
      fetchById(assessmentId.toInt());
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      await webclient.fetchById(id).then((value) {
        assessment.value = value;
        refresh();
      });
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela Avaliação. $error');
    } finally {
      isLoading.value = false;
    }
  }
}
