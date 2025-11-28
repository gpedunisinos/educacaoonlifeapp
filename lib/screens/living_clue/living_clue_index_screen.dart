import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_index_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';

class LivingClueIndexScreen extends StatelessWidget {
  LivingClueIndexScreen({super.key});

  final LivingClueIndexController _controller = Get.find<LivingClueIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pistas vivas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => Get.toNamed('/living_clues/map'),
            tooltip: 'Abrir mapa',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Nova pista viva',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.livingClues.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.livingClues.isEmpty) {
          return const Center(
            child: Text(
              'Nenhuma pista cadastrada.\nQue tal criar ou buscar no mapa?',
              textAlign: TextAlign.center,
            ),
          );
        }

        return Container(
          color: Colors.grey.shade50,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                  itemCount: _controller.livingClues.length,
                  itemBuilder: (_, index) {
                    final LivingClueModel model = _controller.livingClues[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    model.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (model.isActive ? Colors.green : Colors.grey.shade500)
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    model.isActive ? 'Ativa' : 'Inativa',
                                    style: TextStyle(
                                      color: model.isActive ? Colors.green.shade800 : Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              model.description?.isNotEmpty == true
                                  ? model.description!
                                  : 'Sem descrição',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.category_outlined, size: 18, color: Colors.blueGrey.shade600),
                                const SizedBox(width: 6),
                                Text(
                                  model.category?.name ?? 'Categoria ${model.categoryId}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.visibility_outlined),
                                  tooltip: 'Ver pista',
                                  onPressed: () => Get.toNamed('/living_clues/show', arguments: model),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed:
                                      _controller.isLoading.value ? null : () => _goToUpdate(model),
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

  void _confirmDelete(LivingClueModel model) {
    Get.defaultDialog(
      title: 'Excluir pista viva',
      middleText: 'Deseja realmente excluir "${model.name}"?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _controller.deleteLivingClue(model);
      },
    );
  }

  Future<void> _goToCreate() async {
    final result = await Get.toNamed('/living_clues/pre_create');
    if (result == true) {
      await _controller.loadLivingClues();
    }
  }

  Future<void> _goToUpdate(LivingClueModel model) async {
    await Get.toNamed('/living_clues/update', parameters: {'id': model.id.toString()});
    await _controller.loadLivingClues();
  }
}
