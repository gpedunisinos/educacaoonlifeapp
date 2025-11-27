import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CategoryUpdateController extends GetxController {
  final CategoryController _categoryController = Get.find<CategoryController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CategoryModel? category;

  late final TextEditingController nameController;
  late final TextEditingController colorController;
  late final TextEditingController iconController;
  late final TextEditingController descriptionController;

  RxBool get isLoading => _categoryController.isLoading;

  @override
  void onInit() {
    super.onInit();
    category = Get.arguments as CategoryModel?;
    nameController = TextEditingController(text: category?.name ?? '');
    colorController = TextEditingController(text: category?.colorHex ?? '#');
    iconController = TextEditingController(text: category?.iconCode ?? '');
    descriptionController = TextEditingController(text: category?.description ?? '');
  }

  @override
  void onClose() {
    nameController.dispose();
    colorController.dispose();
    iconController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (category == null) return;

    final categoryToSave = CategoryModel(
      id: category!.id,
      name: nameController.text.trim(),
      colorHex: colorController.text.trim(),
      iconCode: iconController.text.trim().isEmpty ? null : iconController.text.trim(),
      description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
    );

    final saved = await _categoryController.saveCategory(categoryToSave);
    if (saved) {
      Get.secureBack();
    }
  }
}
