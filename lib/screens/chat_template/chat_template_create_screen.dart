import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_create_controller.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_form.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';

class ChatTemplateCreateScreen extends StatelessWidget {
  const ChatTemplateCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatTemplateCreateController controller =
        Get.find<ChatTemplateCreateController>();
    return ManagementRecordScaffold(
      section: 'chat_templates',
      title: 'Novo Agente',
      subtitle: 'Configure identidades, instruções e referências dos agentes.',
      form: true,

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              return ChatTemplateForm(
                submitLabel: 'Salvar',
                isLoading: controller.isLoading.value,
                onSubmit: (value) async {
                  final bool saved = await controller.save(
                    ChatTemplateModel(
                      id: 0,
                      name: value.name,
                      description: value.description,
                      systemInstruction: value.systemInstruction,
                      files: value.files,
                    ),
                  );
                  if (saved && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
