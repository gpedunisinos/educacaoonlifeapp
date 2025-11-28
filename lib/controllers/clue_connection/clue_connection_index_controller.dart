import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/webclients/clue_connection_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClueConnectionIndexController extends GetxController {
  final ClueConnectionWebclient _webclient = ClueConnectionWebclient();

  final RxList<ClueConnectionModel> connections = <ClueConnectionModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConnections();
  }

  Future<void> loadConnections() async {
    try {
      isLoading.value = true;
      connections.assignAll(await _webclient.fetch());
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao buscar conexões. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteConnection(ClueConnectionModel model) async {
    try {
      isLoading.value = true;
      await _webclient.delete(model.id);
      connections.removeWhere((item) => item.id == model.id);
      Get.successSnackbar('Conexão removida com sucesso.');
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao remover conexão. $error');
    } finally {
      isLoading.value = false;
    }
  }
}
