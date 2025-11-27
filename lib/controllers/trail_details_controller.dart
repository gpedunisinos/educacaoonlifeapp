import 'package:collection/collection.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/assessment_completion_webclient.dart';
import 'package:unisinos_usp_app/webclients/class_webclient.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailDetailsController extends GetxController {
  final TrailWebclient webclient = TrailWebclient();
  final ClassWebclient classWebclient = ClassWebclient();

  final Rxn<TrailModel> trailDetails = Rxn<TrailModel>();
  final RxList<AssessmentCompletionModel> assessments = <AssessmentCompletionModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    var trailId = Get.parameters['id'];

    if (trailId != null) {
      fetchById(trailId.toInt());
      fetchAssessments();
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      final TrailModel fetchedTrail = await webclient.fetchById(id);
      List<ClassModel> classes = await classWebclient.fetch(params: {'trail_id': id.toString()});

      trailDetails.value = fetchedTrail.copyWith(classes: classes);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela Trilha. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startTrail(int id) async {
    try {
      isLoading.value = true;

      await webclient.startTrail(id);
      Get.successSnackbar('Trilha iniciada com sucesso!');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao iniciar a Trilha. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAssessments({int? offset}) async {
    try {
      isLoading.value = true;

      Map<String, dynamic>? params = {
        'status': [
          AssessmentCompletionStatusEnum.waitingCorrection.value.toString(),
          AssessmentCompletionStatusEnum.approved.value.toString(),
          AssessmentCompletionStatusEnum.repproved.value.toString(),
        ]
      };

      List<AssessmentCompletionModel> list = await AssessmentCompletionWebclient().fetch(offset: offset, params: params);
      assessments.assignAll(list);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Avaliações. $error');
    } finally {
      isLoading.value = false;
    }
  }

  bool isAssessmentApproved(int assessmentId) {
    AssessmentCompletionModel? assessment = assessments
        .firstWhereOrNull((completion) => completion.assessmentId == assessmentId && completion.status == AssessmentCompletionStatusEnum.approved);

    return assessment != null;
  }

  AssessmentCompletionStatusEnum? getAssesmentStatus(int assessmentId) {
    AssessmentCompletionModel? assessment = assessments.lastWhereOrNull((completion) => completion.assessmentId == assessmentId);

    return assessment?.status;
  }
}
