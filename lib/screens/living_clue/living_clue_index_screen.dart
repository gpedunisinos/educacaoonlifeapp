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
          return const Center(child: Text('Nenhuma pista cadastrada.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: _controller.livingClues.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final LivingClueModel model = _controller.livingClues[index];
                  return ListTile(
                    title: Text(model.name),
                    subtitle: Text(model.description ?? ''),
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
    await Get.toNamed('/living_clues/create');
    await _controller.loadLivingClues();
  }

  Future<void> _goToUpdate(LivingClueModel model) async {
    await Get.toNamed('/living_clues/update', parameters: {'id': model.id.toString()});
    await _controller.loadLivingClues();
  }
}
