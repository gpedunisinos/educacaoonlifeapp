import 'package:unisinos_usp_app/models/module_model.dart';
import 'package:unisinos_usp_app/webclients/module_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class ModuleController extends GetxController {
  ModuleWebclient webclient = ModuleWebclient();

  final Rxn<ModuleModel> moduleDetails = Rxn<ModuleModel>();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final id = Get.parameters['moduleId'];

    if (id != null) {
      fetchById(id.toInt());
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      final ModuleModel fetchedModule = await webclient.fetchById(id);

      moduleDetails.value = fetchedModule;
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelo Módulo. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
