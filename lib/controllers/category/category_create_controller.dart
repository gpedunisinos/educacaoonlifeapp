import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CategoryCreateController extends GetxController {
  final CategoryController _categoryController = Get.find<CategoryController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController colorController;
  late final TextEditingController iconController;
  late final TextEditingController descriptionController;

  RxBool get isLoading => _categoryController.isLoading;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: '');
    colorController = TextEditingController(text: '#');
    iconController = TextEditingController(text: '');
    descriptionController = TextEditingController(text: '');
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

    final category = CategoryModel(
      id: 0,
      name: nameController.text.trim(),
      colorHex: colorController.text.trim(),
      iconCode: iconController.text.trim().isEmpty ? null : iconController.text.trim(),
      description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
    );

    final saved = await _categoryController.saveCategory(category);
    if (saved) {
      Get.secureBack();
    }
  }
}
