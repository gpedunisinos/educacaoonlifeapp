import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/category/category_create_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CategoryCreateScreen extends StatefulWidget {
  const CategoryCreateScreen({super.key});

  @override
  State<CategoryCreateScreen> createState() => _CategoryCreateScreenState();
}

class _CategoryCreateScreenState extends State<CategoryCreateScreen> {
  final CategoryCreateController _controller = Get.find<CategoryCreateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova categoria'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputText(
                hintText: 'Nome',
                controller: _controller.nameController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
                ]).val(),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Cor em hex (ex: #FF5733)',
                controller: _controller.colorController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                  PRuleRegex(value, r'^#([A-Fa-f0-9]{6})$', message: 'Use o formato #RRGGBB'),
                ]).val(),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Código do ícone (opcional)',
                controller: _controller.iconController,
              ),
              Insets.large.height,
              InputText(
                hintText: 'Descrição (opcional)',
                controller: _controller.descriptionController,
                maxLines: 4,
              ),
              Insets.extraLarge.height,
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final bool loading = _controller.isLoading.value;
                  final String buttonTitle = loading ? 'Salvando...' : 'Salvar';
                  return ActionButton(
                    theme: ActionButtonTheme.blue,
                    title: buttonTitle,
                    onPressed: loading ? null : _controller.save,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
