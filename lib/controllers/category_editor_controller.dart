import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class CategoryEditorController extends GetxController {
  final CategoryWebclient webclient = CategoryWebclient();
  final Rxn<CategoryModel> category = Rxn<CategoryModel>();
  final RxBool isLoading = false.obs;

  CategoryEditorController({CategoryModel? category}) {
    this.category.value = category;
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    category.value = args?['category'] as CategoryModel?;
  }

  Future<void> saveCategory(CategoryModel model) async {
    try {
      isLoading.value = true;

      if (model.id == 0) {
        final created = await createCategory(model);
        category.value = created;
        Get.successSnackbar('Categoria criada com sucesso!');
      } else {
        final updated = await updateCategory(model);
        category.value = updated;
        Get.successSnackbar('Categoria atualizada com sucesso!');
      }
    } catch (e, stack) {
      Util.debug(exception: e, stackTrace: stack);
    } finally {
      isLoading.value = false;
    }
  }

  Future<CategoryModel> createCategory(CategoryModel model) async {
    try {
      return await webclient.add(model);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao criar Categoria. $error');
      rethrow;
    }
  }

  Future<CategoryModel> updateCategory(CategoryModel model) async {
    try {
      return await webclient.update(model);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar Categoria. $error');
      rethrow;
    }
  }
}
