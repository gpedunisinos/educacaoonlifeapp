import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_update_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/category_select_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueUpdateScreen extends StatefulWidget {
  const LivingClueUpdateScreen({super.key});

  @override
  State<LivingClueUpdateScreen> createState() => _LivingClueUpdateScreenState();
}

class _LivingClueUpdateScreenState extends State<LivingClueUpdateScreen> {
  final LivingClueUpdateController _controller = Get.find<LivingClueUpdateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _metadataController = TextEditingController();
  final ItemSelectController _categorySelectController = ItemSelectController();
  bool _filled = false;
  bool _isActive = true;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageUrlController.dispose();
    _metadataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar pista viva'),
      ),
      body: Obx(() {
        if (_controller.livingClueId == null) {
          return const Center(child: Text('Pista não informada.'));
        }
        if (_controller.isLoading.value && _controller.livingClue.value == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.livingClue.value == null) {
          return const Center(child: Text('Pista não encontrada.'));
        }

        if (!_filled && _controller.livingClue.value != null) {
          final LivingClueModel model = _controller.livingClue.value!;
          _nameController.text = model.name;
          _descriptionController.text = model.description ?? '';
          _latitudeController.text = model.latitude.toString();
          _longitudeController.text = model.longitude.toString();
          _imageUrlController.text = model.imageUrl ?? '';
          _metadataController.text = model.metadata == null ? '' : jsonEncode(model.metadata);
          _isActive = model.isActive;
          _categorySelectController.selectedItem =
              ItemSelect(id: model.categoryId, name: model.categoryId.toString());
          _filled = true;
        }

        return SingleChildScrollView(
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
                InputSelectApi(
                  label: 'Categoria',
                  controller: _categorySelectController,
                  validator: (value) => PValidator([
                    PRuleRequired(value, message: 'Obrigatório'),
                  ]).val(),
                  onFind: (search, offset, params) => CategorySelectWebclient().select(search, offset),
                ),
                Insets.large.height,
                InputText(
                  hintText: 'Descrição (opcional)',
                  controller: _descriptionController,
                  maxLines: 3,
                ),
                Insets.large.height,
                InputNumber(
                  label: 'Latitude',
                  controller: _latitudeController,
                  validator: (value) => PValidator([
                    PRuleRequired(value, message: 'Obrigatório'),
                    PRuleNumeric(value, message: 'Use um número válido'),
                  ]).val(),
                ),
                Insets.large.height,
                InputNumber(
                  label: 'Longitude',
                  controller: _longitudeController,
                  validator: (value) => PValidator([
                    PRuleRequired(value, message: 'Obrigatório'),
                    PRuleNumeric(value, message: 'Use um número válido'),
                  ]).val(),
                ),
                Insets.large.height,
                InputText(
                  hintText: 'URL da imagem (opcional)',
                  controller: _imageUrlController,
                ),
                Insets.large.height,
                InputText(
                  hintText: 'Metadata JSON (opcional)',
                  controller: _metadataController,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    try {
                      jsonDecode(value);
                      return null;
                    } catch (_) {
                      return 'JSON inválido';
                    }
                  },
                ),
                Insets.large.height,
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ativo'),
                  value: _isActive,
                  onChanged: (val) => setState(() => _isActive = val),
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
        );
      }),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final double? latitude = double.tryParse(_latitudeController.text.trim());
    final double? longitude = double.tryParse(_longitudeController.text.trim());
    final int? categoryId = _categorySelectController.selectedItem?.id;
    if (latitude == null || longitude == null || categoryId == null) return;

    Map<String, dynamic>? metadata;
    if (_metadataController.text.trim().isNotEmpty) {
      metadata = jsonDecode(_metadataController.text.trim()) as Map<String, dynamic>;
    }

    final model = LivingClueModel(
      id: _controller.livingClue.value?.id ?? _controller.livingClueId ?? 0,
      name: _nameController.text.trim(),
      categoryId: categoryId,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      latitude: latitude,
      longitude: longitude,
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      metadata: metadata,
      isActive: _isActive,
    );

    final bool saved = await _controller.save(model);
    if (saved) {
      Get.secureBack(result: true);
    }
  }
}
