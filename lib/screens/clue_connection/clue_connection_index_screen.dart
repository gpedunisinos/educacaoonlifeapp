import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/clue_connection/clue_connection_index_controller.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';

class ClueConnectionIndexScreen extends StatelessWidget {
  ClueConnectionIndexScreen({super.key});

  final ClueConnectionIndexController _controller = Get.find<ClueConnectionIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SafeBackButton(),
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

        return Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: _controller.connections.length,
                  itemBuilder: (_, index) {
                    final ClueConnectionModel model = _controller.connections[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Origem ${model.sourceClueId} → Destino ${model.targetClueId}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Chip(
                                  backgroundColor: Colors.orange.shade50,
                                  label: Text(
                                    'Tipo ${model.connectionTypeId}',
                                    style: TextStyle(color: Colors.orange.shade800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Força ${model.strength}${model.evidence != null ? " • Evidência: ${model.evidence}" : ""}',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: _controller.isLoading.value ? null : () => _goToUpdate(model),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed:
                                      _controller.isLoading.value ? null : () => _confirmDelete(model),
                                  tooltip: 'Excluir',
                                ),
                              ],
                            ),
                          ],
                        ),
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
          ),
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
