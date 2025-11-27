import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailEditorController extends GetxController {
  final TrailWebclient webclient = TrailWebclient();
  final Rxn<TrailModel> trail = Rxn<TrailModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    trail.value = Get.arguments as TrailModel?;
  }

  Future<bool> saveTrail(TrailModel model) async {
    try {
      isLoading.value = true;

      if (model.id == 0) {
        final created = await createTrail(model);
        trail.value = created;
        Get.successSnackbar('Trilha criada com sucesso!');
      } else {
        final updated = await updateTrail(model);
        trail.value = updated;
        Get.successSnackbar('Trilha atualizada com sucesso!');
      }

      return true;
    } catch (e, stack) {
      Util.debug(exception: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }

    return false;
  }

  Future<TrailModel> createTrail(TrailModel model) async {
    try {
      return await webclient.add(model);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao criar Trilha. $error');
      rethrow;
    }
  }

  Future<TrailModel> updateTrail(TrailModel model) async {
    try {
      return await webclient.update(model);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar Trilha. $error');
      rethrow;
    }
  }
}
