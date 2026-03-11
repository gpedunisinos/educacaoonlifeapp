import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_update_controller.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/screens/chat_template/chat_template_form.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';

class ChatTemplateUpdateScreen extends StatelessWidget {
  const ChatTemplateUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatTemplateUpdateController controller = Get.find<ChatTemplateUpdateController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Editar agente'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          Obx(() {
            if (controller.templateId == null) {
              return const Center(child: Text('Agente não informado.', style: TextStyle(color: Colors.white)));
            }

            if (controller.isLoading.value && controller.template.value == null) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (controller.template.value == null) {
              return const Center(child: Text('Template não encontrado.', style: TextStyle(color: Colors.white)));
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ChatTemplateForm(
                    key: ValueKey<int>(controller.template.value!.id),
                    initialValue: controller.template.value,
                    submitLabel: 'Atualizar',
                    isLoading: controller.isLoading.value,
                    onSubmit: (value) async {
                      final ChatTemplateModel current = controller.template.value!;
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
}
