import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_controller.dart';
import 'package:unisinos_usp_app/controllers/category/category_create_controller.dart';
import 'package:unisinos_usp_app/controllers/category/category_index_controller.dart';
import 'package:unisinos_usp_app/controllers/category/category_update_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CategoryController>(() => CategoryController());
    Get.lazyPut<CategoryIndexController>(() => CategoryIndexController(), fenix: true);
    Get.lazyPut<CategoryCreateController>(() => CategoryCreateController(), fenix: true);
    Get.lazyPut<CategoryUpdateController>(() => CategoryUpdateController(), fenix: true);
  }
}
