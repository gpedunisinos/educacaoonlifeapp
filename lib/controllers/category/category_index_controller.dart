import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';

class CategoryIndexController extends GetxController {
  final CategoryController _categoryController = Get.find<CategoryController>();

  RxList<CategoryModel> get categories => _categoryController.categories;
  RxBool get isLoading => _categoryController.isLoading;

  Future<void> refreshCategories() => _categoryController.fetchCategories();

  Future<void> deleteCategory(CategoryModel category) => _categoryController.deleteCategory(category.id);
}
