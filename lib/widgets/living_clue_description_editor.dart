import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/widgets/clue_media.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:unisinos_usp_app/widgets/clue_integrations.dart';

class LivingClueDescriptionEditor extends StatelessWidget {
  const LivingClueDescriptionEditor({required this.controller, super.key});

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descrição (opcional)',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              QuillSimpleToolbar(
                controller: controller,
                config: const QuillSimpleToolbarConfig(
                  showFontFamily: false,
                  showFontSize: false,
                  showColorButton: false,
                  showBackgroundColorButton: false,
                  showSearchButton: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showInlineCode: false,
                  showCodeBlock: false,
                  showListCheck: false,
                  showIndent: false,
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              Padding(
                padding: const EdgeInsets.all(12),
                child: QuillEditor.basic(
                  controller: controller,
                  config: const QuillEditorConfig(
                    embedBuilders: [
                      ClueVideoBuilder(),
                      ClueIntegrationBuilder(),
                    ],
                    unknownEmbedBuilder: UnknownClueEmbedBuilder(),
                    minHeight: 140,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ClueIntegrationCards(controller: controller),
        ClueLinkPreviews(controller: controller),
      ],
    );
  }
}
