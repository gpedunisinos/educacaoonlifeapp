import 'package:flutter/material.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ChatTemplateFormValue {
  ChatTemplateFormValue({
    required this.name,
    this.description,
    this.systemInstruction,
    required this.files,
  });

  final String name;
  final String? description;
  final String? systemInstruction;
  final List<ChatTemplateFileModel> files;
}

class ChatTemplateForm extends StatefulWidget {
  const ChatTemplateForm({
    super.key,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
    this.initialValue,
  });

  final String submitLabel;
  final bool isLoading;
  final ChatTemplateModel? initialValue;
  final Future<void> Function(ChatTemplateFormValue value) onSubmit;

  @override
  State<ChatTemplateForm> createState() => _ChatTemplateFormState();
}

class _ChatTemplateFormState extends State<ChatTemplateForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _systemInstructionController;
  late List<_ChatTemplateFileFormEntry> _fileEntries;

  @override
  void initState() {
    super.initState();
    final ChatTemplateModel? initialValue = widget.initialValue;
    _nameController = TextEditingController(text: initialValue?.name ?? '');
    _descriptionController = TextEditingController(text: initialValue?.description ?? '');
    _systemInstructionController = TextEditingController(text: initialValue?.systemInstruction ?? '');
    _fileEntries = (initialValue?.files ?? const <ChatTemplateFileModel>[]).map((file) => _ChatTemplateFileFormEntry.fromModel(file)).toList();
  }

  @override
  void didUpdateWidget(covariant ChatTemplateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue == widget.initialValue || widget.initialValue == null) return;

    final ChatTemplateModel initialValue = widget.initialValue!;
    _nameController.text = initialValue.name;
    _descriptionController.text = initialValue.description ?? '';
    _systemInstructionController.text = initialValue.systemInstruction ?? '';
    for (final entry in _fileEntries) {
      entry.dispose();
    }
    _fileEntries = initialValue.files.map((file) => _ChatTemplateFileFormEntry.fromModel(file)).toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _systemInstructionController.dispose();
    for (final entry in _fileEntries) {
      entry.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
          TextFormField(
            controller: _descriptionController,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            validator: (value) => PValidator([
              PRuleMaxString(value, 2000, message: 'Máximo de 2000 caracteres'),
            ]).val(),
          ),
          Insets.large.height,
          TextFormField(
            controller: _systemInstructionController,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'System instruction',
              border: OutlineInputBorder(),
            ),
            validator: (value) => PValidator([
              PRuleMaxString(value, 10000, message: 'Máximo de 10000 caracteres'),
            ]).val(),
          ),
          Insets.extraLarge.height,
          Row(
            children: [
              Expanded(
                child: Text(
                  'Arquivos do template',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: widget.isLoading ? null : _addFileEntry,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar arquivo'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_fileEntries.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Nenhum arquivo informado.'),
            ),
          for (int index = 0; index < _fileEntries.length; index++) ...[
            _buildFileCard(index),
            const SizedBox(height: 12),
          ],
          Insets.extraLarge.height,
          SizedBox(
            width: double.infinity,
            child: ActionButton(
              theme: ActionButtonTheme.blue,
              title: widget.isLoading ? '${widget.submitLabel}...' : widget.submitLabel,
              onPressed: widget.isLoading ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(int index) {
    final _ChatTemplateFileFormEntry entry = _fileEntries[index];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Arquivo ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: widget.isLoading ? null : () => _removeFileEntry(index),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remover arquivo',
                ),
              ],
            ),
            const SizedBox(height: 8),
            InputText(
              hintText: 'Nome do arquivo',
              controller: entry.nameController,
              validator: (value) => PValidator([
                PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
              ]).val(),
            ),
            Insets.medium.height,
            InputText(
              hintText: 'Mime type',
              controller: entry.mimeTypeController,
              validator: (value) => PValidator([
                PRuleMaxString(value, 255, message: 'Máximo de 255 caracteres'),
              ]).val(),
            ),
            Insets.medium.height,
            TextFormField(
              controller: entry.contentController,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Conteúdo',
                border: OutlineInputBorder(),
              ),
              validator: (value) => PValidator([
                PRuleMaxString(value, 80000, message: 'Máximo de 80000 caracteres'),
              ]).val(),
            ),
          ],
        ),
      ),
    );
  }

  void _addFileEntry() {
    setState(() {
      _fileEntries = [..._fileEntries, _ChatTemplateFileFormEntry.empty()];
    });
  }

  void _removeFileEntry(int index) {
    final _ChatTemplateFileFormEntry entry = _fileEntries[index];
    setState(() {
      _fileEntries = [..._fileEntries]..removeAt(index);
    });
    entry.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final List<ChatTemplateFileModel> files = _fileEntries
        .map((entry) => entry.toModel())
        .where((file) => file.name.isNotEmpty || file.mimeType.isNotEmpty || file.content.isNotEmpty)
        .toList();

    await widget.onSubmit(
      ChatTemplateFormValue(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        systemInstruction: _systemInstructionController.text.trim().isEmpty ? null : _systemInstructionController.text.trim(),
        files: files,
      ),
    );
  }
}

class _ChatTemplateFileFormEntry {
  _ChatTemplateFileFormEntry({
    required this.id,
    required this.nameController,
    required this.mimeTypeController,
    required this.contentController,
  });

  final int? id;
  final TextEditingController nameController;
  final TextEditingController mimeTypeController;
  final TextEditingController contentController;

  factory _ChatTemplateFileFormEntry.empty() {
    return _ChatTemplateFileFormEntry(
      id: null,
      nameController: TextEditingController(),
      mimeTypeController: TextEditingController(),
      contentController: TextEditingController(),
    );
  }

  factory _ChatTemplateFileFormEntry.fromModel(ChatTemplateFileModel model) {
    return _ChatTemplateFileFormEntry(
      id: model.id,
      nameController: TextEditingController(text: model.name),
      mimeTypeController: TextEditingController(text: model.mimeType),
      contentController: TextEditingController(text: model.content),
    );
  }

  ChatTemplateFileModel toModel() {
    return ChatTemplateFileModel(
      id: id,
      name: nameController.text.trim(),
      mimeType: mimeTypeController.text.trim(),
      content: contentController.text,
    );
  }

  void dispose() {
    nameController.dispose();
    mimeTypeController.dispose();
    contentController.dispose();
  }
}
