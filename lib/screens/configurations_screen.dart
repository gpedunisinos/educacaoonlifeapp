import 'package:unisinos_usp_app/controllers/configuration_controller.dart';
import 'package:unisinos_usp_app/models/configuration_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_text.dart';

class ConfigurationsScreen extends StatelessWidget {
  final ConfigurationController _controller = Get.find<ConfigurationController>();

  ConfigurationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Configurações',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Insets.extraLarge.height,
              const Text(
                'Configurações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Aqui editamos todas as informações da plataforma.'),
              Insets.large.height,
              Obx(() {
                final configs = _controller.configurations;

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: configs.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final config = configs[index];

                    return ListTile(
                      title: Text(
                        config.name!,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        config.value!,
                        style: secondaryTextStyle(size: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                      onTap: () => _showEditModal(config),
                    );
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }

  void _showEditModal(ConfigurationModel config) {
    TextEditingController textEditingController = TextEditingController(text: config.value);

    Get.defaultDialog(
      title: 'Editar ${config.name ?? 'Configuração'}',
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputText(
              label: config.name,
              hintText: 'Novo valor para ${config.name}',
              controller: textEditingController,
            ),
            Insets.medium.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                ),
                Insets.small.width,
                ElevatedButton(
                  onPressed: () {
                    final newValue = textEditingController.text;
                    _controller.updateConfiguration(config, newValue);

                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff030da7)),
                  child: const Text('Salvar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
