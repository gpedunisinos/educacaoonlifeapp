import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CategoryCreateController extends GetxController {
  final CategoryWebclient _webclient = CategoryWebclient();

  final RxBool isLoading = false.obs;

  Future<bool> save({
    required String name,
    required String colorHex,
    String? iconCode,
    String? description,
  }) async {
    final category = CategoryModel(
      id: 0,
      name: name.trim(),
      colorHex: colorHex.trim(),
      iconCode: iconCode?.trim().isEmpty == true ? null : iconCode?.trim(),
      description: description?.trim().isEmpty == true ? null : description?.trim(),
    );

    try {
      isLoading.value = true;
      await _webclient.create(category);
      Get.successSnackbar('Categoria salva com sucesso.');
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Não foi possível salvar a categoria. $error');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
