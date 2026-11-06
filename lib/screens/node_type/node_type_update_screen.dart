import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/node_type/node_type_update_controller.dart';
import 'package:unisinos_usp_app/models/node_type_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/color_preview_card.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';
import 'package:widgets_spo/widgets_spo.dart';

class NodeTypeUpdateScreen extends StatefulWidget {
  const NodeTypeUpdateScreen({super.key});

  @override
  State<NodeTypeUpdateScreen> createState() => _NodeTypeUpdateScreenState();
}

class _NodeTypeUpdateScreenState extends State<NodeTypeUpdateScreen> {
  final NodeTypeUpdateController _controller =
      Get.find<NodeTypeUpdateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  bool _filled = false;

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ManagementRecordScaffold(
      section: 'node_types',
      title: 'Editar tipo de problemática',
      subtitle: 'Organize as problemáticas com identificadores e cores.',
      form: true,

      body: Stack(
        children: [
          Obx(() {
            if (_controller.nodeTypeId == null) {
              return const Center(
                child: Text(
                  'Tipo de problemática não informado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (_controller.isLoading.value &&
                _controller.nodeType.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (_controller.nodeType.value == null) {
              return const Center(
                child: Text(
                  'Tipo de problemática não encontrado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (!_filled) {
              final NodeTypeModel model = _controller.nodeType.value!;
              _nameController.text = model.name;
              _colorController.text = model.color;
              _filled = true;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ManagementInput(
                      hintText: 'Nome',
                      controller: _nameController,
                      validator: (value) => PValidator([
                        PRuleRequired(value, message: 'Obrigatório'),
                        PRuleMaxString(
                          value,
                          100,
                          message: 'Máximo de 100 caracteres',
                        ),
                      ]).val(),
                    ),
                    Insets.large.height,
                    ManagementInput(
                      hintText: 'Cor hexadecimal',
                      controller: _colorController,
                      validator: (value) => _validateColor(value),
                    ),
                    Insets.medium.height,
                    ColorPreviewCard(
                      color: _parseHexColor(_colorController.text),
                      onTap: _pickColor,
                    ),
                    Insets.extraLarge.height,
                    SizedBox(
                      width: double.infinity,
                      child: Obx(() {
                        final loading = _controller.isLoading.value;
                        return ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: loading ? 'Atualizando...' : 'Atualizar',
                          onPressed: loading ? null : _save,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _pickColor() async {
    Color tempColor = _parseHexColor(_colorController.text);
    await showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Selecionar cor'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) => tempColor = color,
            enableAlpha: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _colorController.text = _colorToHex(tempColor);
              setState(() {});
              Navigator.of(context).pop();
            },
            child: const Text('Usar'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final model = NodeTypeModel(
      id: _controller.nodeType.value?.id ?? _controller.nodeTypeId ?? 0,
      name: _nameController.text.trim(),
      color: _colorController.text.trim(),
    );

    final bool saved = await _controller.save(model);
    if (saved) {
      Get.secureBack(result: true);
    }
  }

  String? _validateColor(String? value) {
    final String text = value?.trim() ?? '';
    final RegExp regex = RegExp(r'^#?[0-9A-Fa-f]{6}$');
    if (text.isEmpty) return 'Obrigatório';
    if (!regex.hasMatch(text)) return 'Informe uma cor HEX válida';
    return null;
  }

  Color _parseHexColor(String value) {
    final String hex = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }
}
