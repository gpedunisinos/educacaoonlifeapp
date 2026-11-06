import 'package:unisinos_usp_app/widgets/clue_alias_field.dart';
import 'package:unisinos_usp_app/widgets/similar_clues_notice.dart';
import 'package:unisinos_usp_app/models/inventive/inventive_catalog.dart';
import 'package:unisinos_usp_app/widgets/inventive_classification_fields.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/widgets/living_clue_location_button.dart';
import 'package:unisinos_usp_app/widgets/living_clue_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_create_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/living_clue_description_editor.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueCreateScreen extends StatefulWidget {
  const LivingClueCreateScreen({super.key});

  @override
  State<LivingClueCreateScreen> createState() => _LivingClueCreateScreenState();
}

class _LivingClueCreateScreenState extends State<LivingClueCreateScreen> {
  static const String _screenName = 'Cadastro de pista';
  final LivingClueCreateController _controller =
      Get.find<LivingClueCreateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasesController = TextEditingController();
  final QuillController _descriptionController = QuillController.basic();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final Map<String, TextEditingController> _metadataControllers = {};
  final Map<String, dynamic> _classificationEdits = {};
  Map<String, dynamic> _metadataForSave() => mergeClueMetadata({}, {
    for (final entry in _metadataControllers.entries)
      entry.key: entry.value.text,
  }, _classificationEdits);
  int? _categoryId;
  String _categoryName = '';
  String _categoryType = '';
  List<String> _metadataTags = [];
  bool _isActive = true;

  late final String _contextRoute = Get.currentRoute;
  late final AiAssistantContextProvider _contextProvider = _buildAiContext;

  @override
  void initState() {
    super.initState();
    _prefillFromArgs();
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(
        _contextRoute,
        _contextProvider,
      );
    }
    _nameController.dispose();
    _aliasesController.dispose();
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
      _metadataTags = tagsString
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      for (final tag in _metadataTags.where(
        (tag) => !InventiveCatalog.keys.contains(tag),
      )) {
        _metadataControllers[tag] = TextEditingController();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      _contextRoute,
      _contextProvider,
    );
    return Theme(
      data: spaceRecordTheme(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            leading: const SafeBackButton(),
            title: const Text('Nova pista viva'),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                padding: LivingClueLayout.pagePadding(context),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.bolt_outlined,
                                    color: Colors.indigo,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Dados principais',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              Insets.large.height,
                              ManagementInput(
                                hintText: 'Nome',
                                controller: _nameController,
                                validator: (value) => PValidator([
                                  PRuleRequired(value, message: 'Obrigatório'),
                                  PRuleMaxString(
                                    value,
                                    255,
                                    message: 'Máximo de 255 caracteres',
                                  ),
                                ]).val(),
                              ),
                              SimilarCluesNotice(
                                nameController: _nameController,
                              ),
                              Insets.large.height,
                              ClueAliasField(controller: _aliasesController),
                              Insets.large.height,
                              ManagementInput(
                                hintText: 'Categoria',
                                readOnly: true,
                                controller: _categoryController,
                                validator: (_) => _categoryId == null
                                    ? 'Selecione uma categoria antes'
                                    : null,
                              ),
                              Insets.large.height,
                              InventiveClassificationFields(
                                enabledKeys: _metadataTags,
                                metadata: _metadataForSave(),
                                onChanged: (key, value) => setState(
                                  () => _classificationEdits[key] = value,
                                ),
                              ),
                              LivingClueDescriptionEditor(
                                controller: _descriptionController,
                              ),
                              Insets.large.height,
                              if (_metadataTags.any(
                                (tag) => !InventiveCatalog.keys.contains(tag),
                              )) ...[
                                const Text('Metadata (opcional)'),
                                const SizedBox(height: 8),
                                ..._metadataTags
                                    .where(
                                      (tag) =>
                                          !InventiveCatalog.keys.contains(tag),
                                    )
                                    .map(
                                      (tag) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: ManagementInput(
                                          hintText: _formatTagLabel(tag),
                                          controller:
                                              _metadataControllers[tag]!,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.place_outlined,
                                    color: Colors.teal,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Localização',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Insets.large.height,
                              LivingClueLocationButton(
                                latitude: _latitudeController,
                                longitude: _longitudeController,
                              ),
                              const SizedBox(height: 12),
                              InputNumber(
                                label: 'Latitude (opcional)',
                                controller: _latitudeController,
                              ),
                              Insets.large.height,
                              InputNumber(
                                label: 'Longitude (opcional)',
                                controller: _longitudeController,
                              ),
                              Insets.large.height,
                              ManagementInput(
                                hintText: 'URL da imagem (opcional)',
                                controller: _imageUrlController,
                              ),
                              Insets.medium.height,
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Ativo'),
                                value: _isActive,
                                onChanged: (val) =>
                                    setState(() => _isActive = val),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Insets.extraLarge.height,
                      const Text(
                        'Para anexar documentos, imagens, áudio ou vídeo, salve a pista e continue em Arquivos e evidências.',
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => OutlinedButton.icon(
                          onPressed: _controller.isLoading.value
                              ? null
                              : () => _save(addFiles: true),
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Salvar e adicionar arquivos'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() {
                          final bool loading = _controller.isLoading.value;
                          final String buttonTitle = loading
                              ? 'Salvando...'
                              : 'Salvar';
                          return ActionButton(
                            theme: ActionButtonTheme.blue,
                            title: buttonTitle,
                            onPressed: loading ? null : () => _save(),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: _contextRoute,
      stage: 'preenchimento do formulário',
      goal:
          'registrar uma pista viva com localização, categoria e dados principais',
      references: {if (_categoryId != null) 'category_id': _categoryId!},
      draft: {
        'unsaved': true,
        'name': _nameController.text,
        'description': QuillDocumentUtils.plainText(_descriptionController),
        'description_delta': _descriptionController.document.toDelta().toJson(),
        'category_id': _categoryId,
        'metadata': _metadataForSave(),
      },
      visibleFields: <String>[
        'nome',
        'categoria',
        if (_categoryType.isNotEmpty) 'tipo da categoria',
        'descrição',
        ..._metadataTags
            .where((tag) => !InventiveCatalog.keys.contains(tag))
            .map(_formatTagLabel),
        'latitude',
        'longitude',
        'URL da imagem',
        'ativo',
      ],
      filledFields: <String, String>{
        if (_nameController.text.trim().isNotEmpty)
          'nome': _nameController.text.trim(),
        if (_categoryController.text.trim().isNotEmpty)
          'categoria': _categoryController.text.trim(),
        if (_categoryType.trim().isNotEmpty)
          'tipo da categoria': _categoryType.trim(),
        if (QuillDocumentUtils.plainText(_descriptionController).isNotEmpty)
          'descrição': QuillDocumentUtils.plainText(_descriptionController),
        if (_latitudeController.text.trim().isNotEmpty)
          'latitude': _latitudeController.text.trim(),
        if (_longitudeController.text.trim().isNotEmpty)
          'longitude': _longitudeController.text.trim(),
        if (_imageUrlController.text.trim().isNotEmpty)
          'url da imagem': _imageUrlController.text.trim(),
        'ativo': _isActive ? 'sim' : 'não',
        for (final entry in _metadataControllers.entries)
          if (entry.value.text.trim().isNotEmpty)
            _formatTagLabel(entry.key): entry.value.text.trim(),
      },
      notes: const <String>[
        'Rascunho ainda não salvo. A pista pode existir sem localização; não invente coordenadas.',
      ],
    );
  }

  Future<void> _save({bool addFiles = false}) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final double? latitude = double.tryParse(_latitudeController.text.trim());
    final double? longitude = double.tryParse(_longitudeController.text.trim());
    if (_categoryId == null) {
      return;
    }

    final latText = _latitudeController.text.trim();
    final lngText = _longitudeController.text.trim();
    if ((latText.isEmpty != lngText.isEmpty) ||
        (latText.isNotEmpty &&
            (latitude == null ||
                longitude == null ||
                !latitude.isFinite ||
                !longitude.isFinite ||
                latitude.abs() > 90 ||
                longitude.abs() > 180))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Informe as duas coordenadas válidas ou deixe ambas vazias.',
          ),
        ),
      );
      return;
    }
    final metadata = _metadataForSave();

    final model = LivingClueModel(
      id: 0,
      name: _nameController.text.trim(),
      aliasNames: parseClueAliases(_aliasesController.text),
      categoryId: _categoryId!,
      description: QuillDocumentUtils.plainText(_descriptionController).isEmpty
          ? null
          : QuillDocumentUtils.plainText(_descriptionController),
      descriptionDelta: QuillDocumentUtils.encodeDelta(_descriptionController),
      latitude: latitude,
      longitude: longitude,
      imageUrl: _imageUrlController.text.trim().isEmpty
          ? null
          : _imageUrlController.text.trim(),
      metadata: metadata.isEmpty ? null : metadata,
      isActive: _isActive,
    );

    final saved = await _controller.save(model);
    if (!mounted || saved == null) return;
    Get.offNamed(
      addFiles
          ? '/living_clues/update?id=${saved.id}'
          : '/living_clues/${saved.id}',
      arguments: saved,
    );
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
