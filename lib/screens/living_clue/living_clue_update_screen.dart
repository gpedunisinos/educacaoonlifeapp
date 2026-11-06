import 'package:unisinos_usp_app/widgets/clue_alias_field.dart';
import 'package:unisinos_usp_app/models/inventive/inventive_catalog.dart';
import 'package:unisinos_usp_app/widgets/inventive_classification_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unisinos_usp_app/widgets/clue_attachment_tile.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/living_clue_location_button.dart';
import 'package:unisinos_usp_app/widgets/living_clue_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_update_controller.dart';
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/webclients/file_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/living_clue_description_editor.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueUpdateScreen extends StatefulWidget {
  const LivingClueUpdateScreen({super.key});

  @override
  State<LivingClueUpdateScreen> createState() => _LivingClueUpdateScreenState();
}

class _LivingClueUpdateScreenState extends State<LivingClueUpdateScreen> {
  final LivingClueUpdateController _controller =
      Get.find<LivingClueUpdateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aliasesController = TextEditingController();
  final QuillController _descriptionController = QuillController.basic();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final MFileController _fileController = MFileController();
  final Map<String, TextEditingController> _metadataControllers = {};
  final Map<String, dynamic> _classificationEdits = {};
  Map<String, dynamic> _metadataForSave() =>
      mergeClueMetadata(_initialMetadata, {
        for (final entry in _metadataControllers.entries)
          entry.key: entry.value.text,
      }, _classificationEdits);
  final List<FileModel> _attachments = [];
  bool _filled = false;
  String? _initialFormSnapshot;
  bool _isActive = true;
  bool _loadingCategory = false;
  bool _loadingAttachments = false;
  bool _metadataLoaded = false;
  bool _attachmentsLoaded = false;
  bool _uploadingFile = false;
  int? _categoryId;
  List<String> _metadataTags = [];
  Map<String, dynamic> _initialMetadata = {};

  late final String _contextRoute = Get.currentRoute;
  late final AiAssistantContextProvider
  _contextProvider = () => AiAssistantScreenContext(
    screenName: 'Edição de pista',
    route: _contextRoute,
    stage: !_filled
        ? 'carregamento do registro'
        : _hasUnsavedChanges
        ? 'edição de rascunho'
        : 'revisão do registro',
    goal:
        'ajudar a revisar a pista sem confundir alterações locais com o registro salvo',
    references: {
      if (_controller.livingClueId != null)
        'living_clue_id': _controller.livingClueId!,
      if (_categoryId != null) 'category_id': _categoryId!,
    },
    visibleFields: const [
      'nome',
      'categoria',
      'descrição',
      'metadados',
      'anexos',
      'latitude',
      'longitude',
      'ativo',
    ],
    filledFields: _filled
        ? {
            'nome': _nameController.text,
            'categoria': _categoryController.text,
            'descrição': QuillDocumentUtils.plainText(_descriptionController),
            'latitude': _latitudeController.text,
            'longitude': _longitudeController.text,
          }
        : {},
    draft: _filled && _hasUnsavedChanges
        ? {
            'unsaved': true,
            'name': _nameController.text,
            'description': QuillDocumentUtils.plainText(_descriptionController),
            'description_delta': _descriptionController.document
                .toDelta()
                .toJson(),
            'category_id': _categoryId,
            'active': _isActive,
            'metadata': _metadataForSave(),
          }
        : {},
    notes: [
      _hasUnsavedChanges
          ? 'Há alterações locais ainda não confirmadas no backend.'
          : 'O formulário não tem alterações locais em relação ao registro carregado.',
      'A pista pode não possuir localização.',
    ],
  );

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().registerProvider(
        _contextRoute,
        _contextProvider,
      );
    }
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
    _categoryController.dispose();
    _linkController.dispose();
    _fileController.dispose();
    _metadataControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: spaceRecordTheme(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            leading: const SafeBackButton(),
            title: const Text('Editar pista viva'),
            actions: [
              Obx(() {
                return IconButton(
                  tooltip: 'Abrir painel de conexão',
                  onPressed: _controller.livingClue.value == null
                      ? null
                      : _openConnectionPanel,
                  icon: const Icon(Icons.share_outlined),
                );
              }),
            ],
          ),
          body: Stack(
            children: [
              Obx(() {
                if (_controller.livingClueId == null) {
                  return const Center(
                    child: Text(
                      'Pista não informada.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (_controller.isLoading.value &&
                    _controller.livingClue.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                if (_controller.livingClue.value == null) {
                  return const Center(
                    child: Text(
                      'Pista não encontrada.',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!_filled && _controller.livingClue.value != null) {
                  _fillFromModel(_controller.livingClue.value!);
                  _filled = true;
                }

                if (!_metadataLoaded &&
                    !_loadingCategory &&
                    _categoryId != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loadCategoryMetadata(_categoryId!, _initialMetadata);
                  });
                }

                if (!_attachmentsLoaded &&
                    _controller.livingClue.value != null) {
                  _attachmentsLoaded = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loadAttachments(_controller.livingClue.value!.id);
                  });
                }

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: LivingClueLayout.pagePadding(context),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoCard(context),
                            const SizedBox(height: 12),
                            _buildConnectionCard(),
                            const SizedBox(height: 12),
                            _buildLocationCard(),
                            const SizedBox(height: 12),
                            _buildAttachmentsCard(),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    final bool loading =
                                        _controller.isLoading.value;
                                    final String buttonTitle = loading
                                        ? 'Atualizando...'
                                        : 'Atualizar';
                                    return ActionButton(
                                      theme: ActionButtonTheme.blue,
                                      title: buttonTitle,
                                      onPressed: loading ? null : _save,
                                    );
                                  }),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton.icon(
                                  onPressed:
                                      _controller.livingClue.value == null
                                      ? null
                                      : _openConnectionPanel,
                                  icon: const Icon(Icons.share),
                                  label: const Text('Conectar'),
                                ),
                              ],
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.badge_outlined, color: Colors.indigo),
                const SizedBox(width: 8),
                Text(
                  'Informações principais',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Insets.large.height,
            ManagementInput(
              hintText: 'Nome',
              controller: _nameController,
              validator: (value) => PValidator([
                PRuleRequired(value, message: 'Obrigatório'),
                PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
              ]).val(),
            ),
            Insets.large.height,
            ClueAliasField(controller: _aliasesController),
            Insets.large.height,
            ManagementInput(
              hintText: 'Categoria',
              readOnly: true,
              controller: _categoryController,
              validator: (_) =>
                  _categoryId == null ? 'Categoria obrigatória' : null,
            ),
            Insets.large.height,
            InventiveClassificationFields(
              enabledKeys: _metadataTags,
              metadata: _metadataForSave(),
              onChanged: (key, value) =>
                  setState(() => _classificationEdits[key] = value),
            ),
            LivingClueDescriptionEditor(controller: _descriptionController),
            Insets.large.height,
            if (_metadataTags.any(
              (tag) => !InventiveCatalog.keys.contains(tag),
            )) ...[
              const Text('Metadata (opcional)'),
              const SizedBox(height: 8),
              ..._metadataTags
                  .where((tag) => !InventiveCatalog.keys.contains(tag))
                  .map(
                    (tag) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ManagementInput(
                        hintText: _formatTagLabel(tag),
                        controller: _metadataControllers[tag]!,
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.place_outlined, color: Colors.teal),
                const SizedBox(width: 8),
                const Text(
                  'Localização e status',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Insets.large.height,
            TextButton.icon(
              onPressed: () => setState(() {
                _latitudeController.clear();
                _longitudeController.clear();
              }),
              icon: const Icon(Icons.location_off_outlined),
              label: const Text('Remover localização'),
            ),
            LivingClueLocationButton(
              latitude: _latitudeController,
              longitude: _longitudeController,
            ),
            const SizedBox(height: 12),
            ListenableBuilder(
              listenable: Listenable.merge([
                _latitudeController,
                _longitudeController,
              ]),
              builder: (_, __) =>
                  _latitudeController.text.isNotEmpty &&
                      _longitudeController.text.isNotEmpty
                  ? SelectableText(
                      'Latitude: ${_latitudeController.text}  ·  Longitude: ${_longitudeController.text}',
                      style: const TextStyle(
                        color: Color(0xFFB5D7DC),
                        height: 1.5,
                      ),
                    )
                  : const Text(
                      'Sem localização definida. Escolha um ponto no mapa, se desejar.',
                    ),
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
    );
  }

  Widget _buildConnectionCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.hub_outlined, color: Colors.purple),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Painel de conexão',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Conecte esta pista viva a outras pistas.',
                    style: TextStyle(color: Color(0xFF9DB9C7)),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: _openConnectionPanel,
              icon: const Icon(Icons.open_in_new),
              label: const Text('Abrir'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.attachment_outlined, color: Colors.deepOrange),
                const SizedBox(width: 8),
                const Text(
                  'Arquivos e evidências',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                if (_uploadingFile || _loadingAttachments)
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (_loadingAttachments)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_attachments.isEmpty)
              Text(
                'Nenhum arquivo vinculado ainda.',
                style: TextStyle(color: Colors.grey.shade600),
              )
            else
              Column(
                children: [
                  for (final file in _attachments)
                    ClueAttachmentTile(
                      file: file,
                      onRemove: _uploadingFile
                          ? null
                          : () => _removeAttachment(file),
                    ),
                ],
              ),
            const SizedBox(height: 12),
            Text(
              'Adicionar arquivo (até 25 MB)',
              style: TextStyle(
                color: const Color(0xFFE0F5FA),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: _uploadingFile ? null : _pickAttachment,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Selecionar arquivo'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(
                    _uploadingFile ? 'Enviando...' : 'Enviar arquivo',
                  ),
                  onPressed: _uploadingFile ? null : _uploadSelectedFile,
                ),
              ],
            ),
            if (_fileController.file != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _fileController.file!.name ?? 'Arquivo selecionado',
                ),
              ),
            const SizedBox(height: 12),
            ManagementInput(
              hintText: 'Ou cole um link público',
              controller: _linkController,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.send_outlined),
                label: Text(_uploadingFile ? 'Enviando...' : 'Salvar link'),
                onPressed: _uploadingFile ? null : _uploadLink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formSnapshot() => jsonEncode({
    'name': _nameController.text,
    'aliases': _aliasesController.text,
    'description': _descriptionController.document.toDelta().toJson(),
    'latitude': _latitudeController.text,
    'longitude': _longitudeController.text,
    'active': _isActive,
    'category_id': _categoryId,
  });

  bool get _hasUnsavedChanges =>
      _filled &&
      (_classificationEdits.isNotEmpty ||
          _formSnapshot() != _initialFormSnapshot ||
          _metadataControllers.entries.any(
            (entry) =>
                entry.value.text !=
                (_initialMetadata[entry.key]?.toString() ?? ''),
          ));

  void _fillFromModel(LivingClueModel model) {
    _nameController.text = model.name;
    _aliasesController.text = (model.aliasNames ?? []).join('; ');
    _descriptionController.document = QuillDocumentUtils.fromStored(
      delta: model.descriptionDelta,
      plainText: model.description,
    );
    _latitudeController.text = model.latitude?.toString() ?? '';
    _longitudeController.text = model.longitude?.toString() ?? '';
    _isActive = model.isActive;
    _categoryId = model.categoryId;
    _initialMetadata = model.metadata ?? {};
    _initialFormSnapshot = _formSnapshot();
  }

  Future<void> _loadCategoryMetadata(
    int categoryId,
    Map<String, dynamic> existingMetadata,
  ) async {
    setState(() => _loadingCategory = true);
    try {
      final category = await CategoryWebclient().fetchById(categoryId);
      _categoryId = category.id;
      _categoryController.text = category.name;
      _metadataTags = category.metadataTags
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      for (final tag in _metadataTags.where(
        (tag) => !InventiveCatalog.keys.contains(tag),
      )) {
        final initial = existingMetadata[tag]?.toString() ?? '';
        _metadataControllers.putIfAbsent(
          tag,
          () => TextEditingController(text: initial),
        );
      }
      _metadataLoaded = true;
      setState(() {});
    } catch (e) {
      Get.snackbar('Categoria', 'Falha ao carregar metadados da categoria.');
    } finally {
      if (mounted) setState(() => _loadingCategory = false);
    }
  }

  Future<void> _loadAttachments(int livingClueId) async {
    setState(() => _loadingAttachments = true);
    try {
      final files = await FileWebclient().fetch(livingClueId: livingClueId);
      setState(() {
        _attachments
          ..clear()
          ..addAll(files);
        _attachmentsLoaded = true;
      });
    } catch (_) {
      Get.customSnackbar('Arquivos', 'Falha ao carregar arquivos desta pista.');
    } finally {
      if (mounted) setState(() => _loadingAttachments = false);
    }
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: FileWebclient.allowedExtensions,
        allowMultiple: false,
        withData: false,
        withReadStream: true,
      );
      if (result == null || result.files.isEmpty || !mounted) return;
      final picked = result.files.single;
      if (picked.size > FileWebclient.maxBytes) {
        Get.customSnackbar('Arquivos', 'O arquivo deve ter no máximo 25 MB.');
        return;
      }
      final builder = BytesBuilder(copy: false);
      if (picked.readStream != null) {
        await for (final chunk in picked.readStream!) {
          if (builder.length + chunk.length > FileWebclient.maxBytes) {
            throw const AttachmentException(
              'O arquivo deve ter no máximo 25 MB.',
            );
          }
          builder.add(chunk);
        }
      } else {
        builder.add(await picked.xFile.readAsBytes());
      }
      final bytes = builder.takeBytes();
      if (!mounted) return;
      setState(
        () => _fileController.setFile(
          FileModel(
            id: 0,
            extension: picked.extension ?? '',
            name: picked.name,
            bytes: bytes,
            size: bytes.length,
          ),
        ),
      );
    } catch (error) {
      Get.customSnackbar(
        'Arquivos',
        error is AttachmentException
            ? error.message
            : 'Não foi possível selecionar o arquivo.',
      );
    }
  }

  Future<void> _uploadSelectedFile() async {
    if (_controller.livingClue.value == null) return;
    final file = _fileController.file;
    if (file == null) {
      Get.customSnackbar('Arquivos', 'Selecione um arquivo primeiro.');
      return;
    }

    setState(() => _uploadingFile = true);
    try {
      final uploaded = await FileWebclient().upload(
        FileModel(
          id: 0,
          extension: file.extension,
          name: file.name ?? 'arquivo.${file.extension}',
          path: file.path,
          publicUrl: file.publicUrl,
          bytes: file.bytes,
          readStream: file.readStream,
          size: file.size,
          livingClueId: _controller.livingClue.value!.id,
        ),
      );
      if (!mounted) return;
      setState(() {
        _attachments.insert(0, uploaded);
        _fileController.clearFile();
      });
      Get.successSnackbar('Arquivo enviado com sucesso.');
    } catch (error) {
      Get.customSnackbar(
        'Arquivos',
        error is AttachmentException
            ? error.message
            : 'Não foi possível enviar o arquivo.',
      );
    } finally {
      if (mounted) setState(() => _uploadingFile = false);
    }
  }

  Future<void> _uploadLink() async {
    if (_controller.livingClue.value == null) return;
    final link = _linkController.text.trim();
    if (link.isEmpty) {
      Get.customSnackbar('Arquivos', 'Cole um link público para salvar.');
      return;
    }

    setState(() => _uploadingFile = true);
    try {
      final uploaded = await FileWebclient().upload(
        FileModel(
          id: 0,
          extension: 'link',
          name: link,
          publicUrl: link,
          livingClueId: _controller.livingClue.value!.id,
        ),
      );
      if (!mounted) return;
      setState(() {
        _attachments.insert(0, uploaded);
        _linkController.clear();
      });
      Get.successSnackbar('Link adicionado.');
    } catch (_) {
      Get.customSnackbar('Arquivos', 'Não foi possível salvar o link.');
    } finally {
      if (mounted) setState(() => _uploadingFile = false);
    }
  }

  Future<void> _removeAttachment(FileModel file) async {
    try {
      await FileWebclient().delete(file.id);
      setState(() => _attachments.removeWhere((item) => item.id == file.id));
      Get.successSnackbar('Arquivo removido.');
    } catch (_) {
      Get.customSnackbar('Arquivos', 'Falha ao remover o arquivo.');
    }
  }

  Future<void> _save() async {
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
      id: _controller.livingClue.value?.id ?? _controller.livingClueId ?? 0,
      name: _nameController.text.trim(),
      aliasNames: parseClueAliases(_aliasesController.text),
      categoryId: _categoryId!,
      description: QuillDocumentUtils.plainText(_descriptionController).isEmpty
          ? null
          : QuillDocumentUtils.plainText(_descriptionController),
      descriptionDelta: QuillDocumentUtils.encodeDelta(_descriptionController),
      latitude: latitude,
      longitude: longitude,
      imageUrl: _controller.livingClue.value?.imageUrl,
      metadata: metadata.isEmpty ? null : metadata,
      isActive: _isActive,
    );

    final bool saved = await _controller.save(model);
    if (!mounted || !saved) return;
    Get.offNamed('/living_clues/${model.id}');
  }

  String _formatTagLabel(String raw) {
    final cleaned = raw.replaceAll('_', ' ');
    return cleaned
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  Future<void> _openConnectionPanel() async {
    final LivingClueModel? model = _controller.livingClue.value;
    if (model == null) return;

    await Get.toNamed('/living_clues/connect', arguments: model);
  }
}
