import 'package:unisinos_usp_app/controllers/category_editor_controller.dart';
import 'package:unisinos_usp_app/controllers/trail_manager_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/trail_listview_paginated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';

class CategoryEditorScreen extends StatefulWidget {
  const CategoryEditorScreen({super.key});

  @override
  State<CategoryEditorScreen> createState() => _CategoryEditorScreenState();
}

class _CategoryEditorScreenState extends State<CategoryEditorScreen> {
  final CategoryEditorController _controller = Get.find<CategoryEditorController>();
  final TrailManagerController _trailController = Get.find<TrailManagerController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _updateFields();
  }

  void _updateFields() {
    final c = _controller.category.value;
    setState(() {
      nameTextController.text = c?.name ?? '';
      descriptionTextController.text = c?.description ?? '';
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _controller.category.value?.id == 0 || _controller.category.value?.id == null;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: Text(
            isNew ? 'Cadastrar Categoria' : 'Editar Categoria',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: Obx(() {
          final isNew = _controller.category.value?.id == 0 || _controller.category.value?.id == null;
          return Column(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Insets.large.height,
                      InputText(
                        hintText: 'Nome da Categoria',
                        controller: nameTextController,
                        validator: (string) => PValidator([
                          PRuleRequired(string, message: 'Obrigatório'.tlt),
                        ]).val(),
                        keyboardType: TextInputType.name,
                      ),
                      Insets.medium.height,
                      InputText(
                        hintText: 'Descrição da Categoria',
                        controller: descriptionTextController,
                        maxLines: 6,
                        validator: (string) => PValidator([
                          PRuleRequired(string, message: 'Obrigatório'.tlt),
                          PRuleMaxString(string, 200, message: 'Máximo de 200 caracteres'.tlt),
                        ]).val(),
                      ),
                      Insets.large.height,
                      SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: 'Salvar',
                          onPressed: doSave,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (!isNew) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Trilhas associadas',
                      style: primaryTextStyle(size: 16, weight: FontWeight.w600),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TrailListviewPaginated(controller: _trailController, isReorderable: true),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  Future<void> doSave() async {
    if (_formKey.currentState!.validate()) {
      final currentCategory = _controller.category.value ??
          CategoryModel(
            id: 0,
            name: nameTextController.text,
            description: descriptionTextController.text,
            createdAt: DateTime.now().toIso8601String(),
          );

      final updatedCategory = currentCategory.copyWith(
        name: nameTextController.text,
        description: descriptionTextController.text,
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _controller.saveCategory(updatedCategory);

      Get.secureBack(result: _controller.category.value);
    }
  }
}
