import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/category/category_update_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CategoryUpdateScreen extends StatefulWidget {
  const CategoryUpdateScreen({super.key});

  @override
  State<CategoryUpdateScreen> createState() => _CategoryUpdateScreenState();
}

class _CategoryUpdateScreenState extends State<CategoryUpdateScreen> {
  final CategoryUpdateController _controller = Get.find<CategoryUpdateController>();

  @override
  Widget build(BuildContext context) {
    if (_controller.category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editar categoria')),
        body: const Center(
          child: Text('Categoria não encontrada.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar categoria'),
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
                  final String buttonTitle = loading ? 'Atualizando...' : 'Atualizar';
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
