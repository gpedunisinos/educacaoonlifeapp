import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/report_teacher_score_model.dart';
import 'package:unisinos_usp_app/webclients/report_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class AssessmentPerformanceController extends GetxController {
  final UserController _userController = Get.find<UserController>();
  final ReportWebclient webclient = ReportWebclient();

  final RxList<ReportTeacherScore> teacherScores = <ReportTeacherScore>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchReportStats();
  }

  Future<void> fetchReportStats() async {
    try {
      isLoading.value = true;

      final fetchedData = await webclient.getReportsByTeacher(
        teacherId: _userController.user.value!.id,
      );

      teacherScores.assignAll(fetchedData);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar estatísticas das Avaliações. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
