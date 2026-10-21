import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueIndexController extends GetxController {
  final LivingClueWebclient _webclient = LivingClueWebclient();

  final RxList<LivingClueModel> livingClues = <LivingClueModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLivingClues();
  }

  Future<void> loadLivingClues([String search = '']) async {
    try {
      isLoading.value = true;
      livingClues.assignAll(search.trim().isEmpty
          ? await _webclient.fetch()
          : await _webclient.search(search: search.trim()));
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao buscar pistas. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteLivingClue(LivingClueModel model) async {
    try {
      isLoading.value = true;
      await _webclient.delete(model.id);
      livingClues.removeWhere((item) => item.id == model.id);
      Get.successSnackbar('Pista removida com sucesso.');
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao remover pista. $error');
    } finally {
      isLoading.value = false;
    }
  }
}
