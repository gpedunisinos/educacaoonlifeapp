import 'package:unisinos_usp_app/webclients/assessment_correction_webclient.dart';
import 'package:get/get.dart';

class AssessmentCorrectionController extends GetxController {
  final AssessmentCorrectionWebclient webclient = AssessmentCorrectionWebclient();

  final RxBool isLoading = false.obs;
}
