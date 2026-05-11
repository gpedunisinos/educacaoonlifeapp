import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/biome/biome_create_controller.dart';
import 'package:unisinos_usp_app/models/biome_model.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/color_preview_card.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';
import 'package:widgets_spo/widgets_spo.dart';

class _BiomeForm extends StatefulWidget {
  const _BiomeForm({
    required this.title,
    required this.onSave,
  });
  final String title;
  final Future<bool> Function(BiomeModel model) onSave;

  @override
  State<_BiomeForm> createState() => _BiomeFormState();
}

class _BiomeFormState extends State<_BiomeForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _slugController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _colorController;
  late final TextEditingController _coverImageController;
  bool _isActive = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    const BiomeModel? model = null;
    _nameController = TextEditingController(text: model?.name ?? '');
    _slugController = TextEditingController(text: model?.slug ?? '');
    _descriptionController = TextEditingController(
      text: model?.description ?? '',
    );
    _colorController =
        TextEditingController(text: model?.colorHex ?? '#2563EB');
    _coverImageController = TextEditingController(
      text: model?.coverImageUrl ?? '',
    );
    _isActive = model?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    _coverImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          const Positioned.fill(child: CidigScenicBackground()),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Card(
                color: Colors.black.withValues(alpha: 0.58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(
                    color: Color(0x8A46B6EC),
                    width: 1.2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      InputText(
                        hintText: 'Nome',
                        controller: _nameController,
                        validator: (v) => PValidator([
                          PRuleRequired(v, message: 'Obrigatório'),
                        ]).val(),
                      ),
                      Insets.large.height,
                      InputText(
                        hintText: 'Slug',
                        controller: _slugController,
                        validator: (v) => PValidator([
                          PRuleRequired(v, message: 'Obrigatório'),
                        ]).val(),
                      ),
                      Insets.large.height,
                      InputText(
                        hintText: 'Cor em hex',
                        controller: _colorController,
                        validator: _validateColor,
                      ),
                      Insets.medium.height,
                      ColorPreviewCard(
                        color: _parseHexColor(_colorController.text),
                        onTap: _pickColor,
                      ),
                      Insets.large.height,
                      InputText(
                        hintText: 'Descrição (opcional)',
                        controller: _descriptionController,
                        maxLines: 4,
                      ),
                      Insets.large.height,
                      InputText(
                        hintText: 'URL da capa (opcional)',
                        controller: _coverImageController,
                      ),
                      Insets.medium.height,
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Ativo'),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                      Insets.extraLarge.height,
                      SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: _saving ? 'Salvando...' : 'Salvar',
                          onPressed: _saving ? null : _save,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final saved = await widget.onSave(
      BiomeModel(
        id: 0,
        name: _nameController.text.trim(),
        slug: _slugController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        colorHex: _colorController.text.trim(),
        coverImageUrl: _coverImageController.text.trim().isEmpty
            ? null
            : _coverImageController.text.trim(),
        metadata: null,
        isActive: _isActive,
      ),
    );
    if (mounted) setState(() => _saving = false);
    if (saved) Get.secureBack(result: true);
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

class BiomeCreateScreen extends StatelessWidget {
  const BiomeCreateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BiomeCreateController>();
    return _BiomeForm(
      title: 'Novo bioma',
      onSave: (BiomeModel model) => controller.save(model),
    );
  }
}
