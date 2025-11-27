import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class CategoryManagerController extends GetxController {
  final categories = <CategoryModel>[].obs;
  final isLoading = false.obs;

  final webclient = CategoryWebclient();

  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({int offset = 0}) async {
    try {
      isLoading.value = true;

      final result = await webclient.fetch(search: searchQuery, offset: offset);
      if (offset == 0) {
        categories.assignAll(result);
      } else {
        categories.addAll(result);
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao carregar categorias: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory(CategoryModel category) async {
    try {
      await webclient.delete(category.id);
      categories.remove(category);

      Get.successSnackbar('A Categoria foi excluída com sucesso'.tlt, duration: Duration(seconds: 5));
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao excluir a Categoria. $error');
      rethrow;
    }
  }
}
