import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LivingClueDescriptionView extends StatefulWidget {
  const LivingClueDescriptionView({
    required this.plainText,
    this.delta,
    super.key,
  });

  final String plainText;
  final String? delta;

  @override
  State<LivingClueDescriptionView> createState() =>
      _LivingClueDescriptionViewState();
}

class _LivingClueDescriptionViewState extends State<LivingClueDescriptionView> {
  late final QuillController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = QuillController(
      document: QuillDocumentUtils.fromStored(
        delta: widget.delta,
        plainText: widget.plainText,
      ),
      selection: const TextSelection.collapsed(offset: 0),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return QuillEditor.basic(
      controller: _controller,
      focusNode: _focusNode,
      config: QuillEditorConfig(
        showCursor: false,
        onLaunchUrl: (url) => _openUrl(context, url),
      ),
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Não foi possível abrir este link.')),
    );
  }
}
