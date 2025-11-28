import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_update_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
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
  final TextEditingController _categoryController = TextEditingController();
  final Map<String, TextEditingController> _metadataControllers = {};
  bool _filled = false;
  bool _isActive = true;
  bool _loadingCategory = false;
  bool _metadataLoaded = false;
  String _categoryName = '';
  int? _categoryId;
  List<String> _metadataTags = [];
  Map<String, dynamic> _initialMetadata = {};

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _metadataControllers.values.forEach((c) => c.dispose());
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
          _fillFromModel(_controller.livingClue.value!);
          _filled = true;
        }

        if (!_metadataLoaded && !_loadingCategory && _categoryId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _loadCategoryMetadata(_categoryId!, _initialMetadata);
          });
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
                      hintText: 'Categoria',
                      readOnly: true,
                      controller: _categoryController,
                      validator: (_) => _categoryId == null ? 'Categoria obrigatória' : null,
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
                    if (_metadataTags.isNotEmpty) ...[
                      const Text('Metadata (opcional)'),
                      const SizedBox(height: 8),
                      ..._metadataTags.map(
                        (tag) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: InputText(
                            hintText: _formatTagLabel(tag),
                            controller: _metadataControllers[tag]!,
                          ),
                        ),
                      ),
                      Insets.large.height,
                    ],
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
            ),
            if (_controller.isLoading.value || _loadingCategory)
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

  void _fillFromModel(LivingClueModel model) {
    _nameController.text = model.name;
    _descriptionController.text = model.description ?? '';
    _latitudeController.text = model.latitude.toString();
    _longitudeController.text = model.longitude.toString();
    _imageUrlController.text = model.imageUrl ?? '';
    _isActive = model.isActive;
    _categoryId = model.categoryId;
    _initialMetadata = model.metadata ?? {};
  }

  Future<void> _loadCategoryMetadata(int categoryId, Map<String, dynamic> existingMetadata) async {
    setState(() => _loadingCategory = true);
    try {
      final category = await CategoryWebclient().fetchById(categoryId);
      _categoryId = category.id;
      _categoryName = category.name;
      _categoryController.text = _categoryName;
      _metadataTags = category.metadataTags.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
      for (final tag in _metadataTags) {
        final initial = existingMetadata[tag]?.toString() ?? '';
        _metadataControllers.putIfAbsent(tag, () => TextEditingController(text: initial));
      }
      _metadataLoaded = true;
      setState(() {});
    } catch (e) {
      Get.snackbar('Categoria', 'Falha ao carregar metadados da categoria.');
    } finally {
      if (mounted) setState(() => _loadingCategory = false);
    }
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final double? latitude = double.tryParse(_latitudeController.text.trim());
    final double? longitude = double.tryParse(_longitudeController.text.trim());
    if (latitude == null || longitude == null || _categoryId == null) return;

    final Map<String, dynamic> metadata = {};
    for (final entry in _metadataControllers.entries) {
      final value = entry.value.text.trim();
      if (value.isNotEmpty) {
        metadata[entry.key] = value;
      }
    }

    final model = LivingClueModel(
      id: _controller.livingClue.value?.id ?? _controller.livingClueId ?? 0,
      name: _nameController.text.trim(),
      categoryId: _categoryId!,
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      latitude: latitude,
      longitude: longitude,
      imageUrl: _imageUrlController.text.trim().isEmpty ? null : _imageUrlController.text.trim(),
      metadata: metadata.isEmpty ? null : metadata,
      isActive: _isActive,
    );

    final bool saved = await _controller.save(model);
    if (saved) {
      Get.secureBack(result: true);
    }
  }

  String _formatTagLabel(String raw) {
    final cleaned = raw.replaceAll('_', ' ');
    return cleaned
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
