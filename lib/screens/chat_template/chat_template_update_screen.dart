import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_update_controller.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_form.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';

class ChatTemplateUpdateScreen extends StatelessWidget {
  const ChatTemplateUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatTemplateUpdateController controller =
        Get.find<ChatTemplateUpdateController>();
    return ManagementRecordScaffold(
      section: 'chat_templates',
      title: 'Editar agente',
      subtitle: 'Configure identidades, instruções e referências dos agentes.',
      form: true,

      body: Stack(
        children: [
          Obx(() {
            if (controller.templateId == null) {
              return const Center(
                child: Text(
                  'Agente não informado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (controller.isLoading.value &&
                controller.template.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (controller.template.value == null) {
              return const Center(
                child: Text(
                  'Template não encontrado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ChatTemplateForm(
                        key: ValueKey<int>(controller.template.value!.id),
                        initialValue: controller.template.value,
                        submitLabel: 'Atualizar',
                        isLoading: controller.isLoading.value,
                        onSubmit: (value) async {
                          final ChatTemplateModel current =
                              controller.template.value!;
                          final bool saved = await controller.save(
                            ChatTemplateModel(
                              id: current.id,
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
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: controller.isLoading.value
                              ? null
                              : () =>
                                    _confirmDeleteMessages(context, controller),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red.shade300,
                            side: BorderSide(color: Colors.red.shade400),
                          ),
                          icon: const Icon(Icons.delete_sweep_outlined),
                          label: const Text(
                            'Excluir todas as mensagens do template',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (controller.isLoading.value)
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
    );
  }

  Future<void> _confirmDeleteMessages(
    BuildContext context,
    ChatTemplateUpdateController controller,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text(
          'Tem certeza que deseja excluir todas as mensagens deste template? Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Excluir tudo'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await controller.deleteAllMessages();
  }
}
