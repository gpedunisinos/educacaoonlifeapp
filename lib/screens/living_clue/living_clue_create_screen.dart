import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_create_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueCreateScreen extends StatefulWidget {
  const LivingClueCreateScreen({super.key});

  @override
  State<LivingClueCreateScreen> createState() => _LivingClueCreateScreenState();
}

class _LivingClueCreateScreenState extends State<LivingClueCreateScreen> {
  static const String _screenName = 'Cadastro de pista';
  final LivingClueCreateController _controller = Get.find<LivingClueCreateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final Map<String, TextEditingController> _metadataControllers = {};
  int? _categoryId;
  String _categoryName = '';
  String _categoryType = '';
  List<String> _metadataTags = [];
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _prefillFromArgs();
  }

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

  void _prefillFromArgs() {
    final args = Get.arguments;
    if (args is Map) {
      final lat = args['latitude'];
      final lng = args['longitude'];
      if (lat != null && lng != null) {
        _latitudeController.text = '$lat';
        _longitudeController.text = '$lng';
      }
      _categoryId = args['categoryId'] as int?;
      _categoryName = (args['categoryName'] ?? '') as String;
      _categoryType = (args['categoryType'] ?? '') as String;
      _categoryController.text = _categoryName;
      final tagsString = args['metadataTags'] as String? ?? '';
      _metadataTags = tagsString.split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
      for (final tag in _metadataTags) {
        _metadataControllers[tag] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      Get.currentRoute,
      _buildAiContext,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Nova pista viva'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.bolt_outlined, color: Colors.indigo),
                              const SizedBox(width: 8),
                              Text(
                                'Dados principais',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          Insets.large.height,
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
                            validator: (_) => _categoryId == null ? 'Selecione uma categoria antes' : null,
                          ),
                          Insets.large.height,
                          InputText(
                            hintText: 'Descrição (opcional)',
                            controller: _descriptionController,
                            maxLines: 3,
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
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.place_outlined, color: Colors.teal),
                              const SizedBox(width: 8),
                              const Text('Localização', style: TextStyle(fontWeight: FontWeight.w700)),
                            ],
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
                          Insets.medium.height,
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Ativo'),
                            value: _isActive,
                            onChanged: (val) => setState(() => _isActive = val),
                          ),
                        ],
                      ),
                    ),
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
        ],
      ),
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: Get.currentRoute,
      stage: 'preenchimento do formulário',
      goal: 'registrar uma pista viva com localização, categoria e dados principais',
      visibleFields: <String>[
        'nome',
        'categoria',
        if (_categoryType.isNotEmpty) 'tipo da categoria',
        'descrição',
        ..._metadataTags.map(_formatTagLabel),
        'latitude',
        'longitude',
        'URL da imagem',
        'ativo',
      ],
      filledFields: <String, String>{
        if (_nameController.text.trim().isNotEmpty) 'nome': _nameController.text.trim(),
        if (_categoryController.text.trim().isNotEmpty) 'categoria': _categoryController.text.trim(),
        if (_categoryType.trim().isNotEmpty) 'tipo da categoria': _categoryType.trim(),
        if (_descriptionController.text.trim().isNotEmpty) 'descrição': _descriptionController.text.trim(),
        if (_latitudeController.text.trim().isNotEmpty) 'latitude': _latitudeController.text.trim(),
        if (_longitudeController.text.trim().isNotEmpty) 'longitude': _longitudeController.text.trim(),
        if (_imageUrlController.text.trim().isNotEmpty) 'url da imagem': _imageUrlController.text.trim(),
        'ativo': _isActive ? 'sim' : 'não',
        for (final entry in _metadataControllers.entries)
          if (entry.value.text.trim().isNotEmpty) _formatTagLabel(entry.key): entry.value.text.trim(),
      },
      notes: const <String>[
        'Os dados desta tela são usados para criar o ponto definitivo no mapa.',
      ],
    );
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
      id: 0,
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
    return cleaned.split(' ').where((part) => part.isNotEmpty).map((part) => part[0].toUpperCase() + part.substring(1)).join(' ');
  }
}
