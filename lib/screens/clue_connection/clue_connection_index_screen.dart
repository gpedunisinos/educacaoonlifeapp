import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/clue_connection/clue_connection_index_controller.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';

class ClueConnectionIndexScreen extends StatelessWidget {
  ClueConnectionIndexScreen({super.key});

  final ClueConnectionIndexController _controller = Get.find<ClueConnectionIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conexões'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Nova conexão',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.connections.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_controller.connections.isEmpty) {
          return const Center(child: Text('Nenhuma conexão cadastrada.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _controller.connections.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final ClueConnectionModel model = _controller.connections[index];
                  return ListTile(
                    title: Text('Origem ${model.sourceClueId} → Destino ${model.targetClueId}'),
                    subtitle: Text('Tipo ${model.connectionTypeId} • Força ${model.strength}'),
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

  void _confirmDelete(ClueConnectionModel model) {
    Get.defaultDialog(
      title: 'Excluir conexão',
      middleText: 'Deseja realmente excluir a conexão?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _controller.deleteConnection(model);
      },
    );
  }

  Future<void> _goToCreate() async {
    await Get.toNamed('/clue_connections/create');
    await _controller.loadConnections();
  }

  Future<void> _goToUpdate(ClueConnectionModel model) async {
    await Get.toNamed('/clue_connections/update', parameters: {'id': model.id.toString()});
    await _controller.loadConnections();
  }
}
