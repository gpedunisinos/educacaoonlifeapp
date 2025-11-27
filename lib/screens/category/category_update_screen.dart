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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController(text: '#');
  final TextEditingController _iconController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _filledControllers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar categoria'),
      ),
      body: Obx(() {
        if (_controller.categoryId == null) {
          return const Center(child: Text('Categoria não informada.'));
        }

        if (_controller.isLoading.value && _controller.category.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.category.value == null) {
          return const Center(child: Text('Categoria não encontrada.'));
        }

        if (!_filledControllers && _controller.category.value != null) {
          final category = _controller.category.value!;
          _nameController.text = category.name;
          _colorController.text = category.colorHex;
          _iconController.text = category.iconCode ?? '';
          _descriptionController.text = category.description ?? '';
          _filledControllers = true;
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputText(
                      hintText: 'Nome',
                      controller: _nameController,
                      validator: (value) => PValidator([
                        PRuleRequired(value, message: 'Obrigatório'),
                        PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
                      ]).val(),
                    ),
                    Insets.large.height,
                    InputText(
                      hintText: 'Cor em hex (ex: #FF5733)',
                      controller: _colorController,
                      validator: (value) => PValidator([
                        PRuleRequired(value, message: 'Obrigatório'),
                        PRuleRegex(value, r'^#([A-Fa-f0-9]{6})$', message: 'Use o formato #RRGGBB'),
                      ]).val(),
                    ),
                    Insets.large.height,
                    InputText(
                      hintText: 'Código do ícone (opcional)',
                      controller: _iconController,
                    ),
                    Insets.large.height,
                    InputText(
                      hintText: 'Descrição (opcional)',
                      controller: _descriptionController,
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
                          onPressed: loading ? null : _save,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            if (_controller.isLoading.value)
              const Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final bool saved = await _controller.save(
      name: _nameController.text,
      colorHex: _colorController.text,
      iconCode: _iconController.text,
      description: _descriptionController.text,
    );
    if (saved) {
      Get.secureBack(result: true);
    }
  }
}
