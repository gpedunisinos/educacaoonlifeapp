import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:widgets_spo/utils.dart';

class CategoryController extends GetxController {
  final CategoryWebclient webclient = CategoryWebclient();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      categories.assignAll(await webclient.fetch());
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao buscar categorias. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveCategory(CategoryModel category) async {
    try {
      isLoading.value = true;
      final CategoryModel saved;
      if (category.id == 0) {
        saved = await webclient.create(category);
        categories.add(saved);
      } else {
        saved = await webclient.update(category);
        final index = categories.indexWhere((c) => c.id == saved.id);
        if (index >= 0) {
          categories[index] = saved;
        } else {
          categories.add(saved);
        }
      }
      categories.refresh();
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

  Future<void> deleteCategory(int id) async {
    try {
      isLoading.value = true;
      await webclient.delete(id);
      categories.removeWhere((c) => c.id == id);
      Get.successSnackbar('Categoria removida com sucesso.');
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao remover categoria. $error');
    } finally {
      isLoading.value = false;
    }
  }
}
