import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/connection_type/connection_type_index_controller.dart';
import 'package:unisinos_usp_app/models/connection_type_model.dart';

class ConnectionTypeIndexScreen extends StatelessWidget {
  ConnectionTypeIndexScreen({super.key});

  final ConnectionTypeIndexController _controller = Get.find<ConnectionTypeIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de conexão'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Novo tipo',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.connectionTypes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.connectionTypes.isEmpty) {
          return const Center(child: Text('Nenhum tipo cadastrado.'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _controller.connectionTypes.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final ConnectionTypeModel model = _controller.connectionTypes[index];
                  return ListTile(
                    title: Text(model.name),
                    subtitle: Text('Estilo: ${model.strokeStyle} • Direcional: ${model.isDirectional ? "Sim" : "Não"}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _controller.isLoading.value ? null : () => _goToUpdate(model),
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: _controller.isLoading.value ? null : () => _confirmDelete(model),
                          tooltip: 'Excluir',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_controller.isLoading.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: CircularProgressIndicator(),
              ),
          ],
        );
      }),
    );
  }

  void _confirmDelete(ConnectionTypeModel model) {
    Get.defaultDialog(
      title: 'Excluir tipo',
      middleText: 'Deseja realmente excluir "${model.name}"?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _controller.deleteConnectionType(model);
      },
    );
  }

  Future<void> _goToCreate() async {
    await Get.toNamed('/connection_types/create');
    await _controller.loadConnectionTypes();
  }

  Future<void> _goToUpdate(ConnectionTypeModel model) async {
    await Get.toNamed('/connection_types/update', parameters: {'id': model.id.toString()});
    await _controller.loadConnectionTypes();
  }
}
