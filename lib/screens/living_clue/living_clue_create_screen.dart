import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_create_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/category_select_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueCreateScreen extends StatefulWidget {
  const LivingClueCreateScreen({super.key});

  @override
  State<LivingClueCreateScreen> createState() => _LivingClueCreateScreenState();
}

class _LivingClueCreateScreenState extends State<LivingClueCreateScreen> {
  final LivingClueCreateController _controller = Get.find<LivingClueCreateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _metadataController = TextEditingController();
  final ItemSelectController _categorySelectController = ItemSelectController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _prefillCoordinates();
  }

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

  void _prefillCoordinates() {
    final args = Get.arguments;
    if (args is Map) {
      final lat = args['latitude'];
      final lng = args['longitude'];
      if (lat != null && lng != null) {
        _latitudeController.text = '$lat';
        _longitudeController.text = '$lng';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova pista viva'),
      ),
      body: SingleChildScrollView(
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
                ]).val(),
              ),
              Insets.large.height,
              InputNumber(
                label: 'Longitude',
                controller: _longitudeController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
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
                  final String buttonTitle = loading ? 'Salvando...' : 'Salvar';
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
      id: 0,
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
