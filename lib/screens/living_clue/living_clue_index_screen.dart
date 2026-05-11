import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_index_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';

class LivingClueIndexScreen extends StatelessWidget {
  LivingClueIndexScreen({super.key});

  final LivingClueIndexController _controller =
      Get.find<LivingClueIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Pistas'),
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
      body: Stack(
        children: [
          const Positioned.fill(
            child: StarfieldBackground(),
          ),
          const Positioned.fill(
            child: CidigScenicBackground(),
          ),
          Obx(() {
            if (_controller.isLoading.value &&
                _controller.livingClues.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            }

            if (_controller.livingClues.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma pista cadastrada.\nQue tal criar ou buscar no mapa?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: _controller.livingClues.length,
                    itemBuilder: (_, index) {
                      final LivingClueModel model =
                          _controller.livingClues[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0x8A46B6EC),
                            width: 1.2,
                          ),
                        ),
                        elevation: 2,
                        color: Colors.black.withValues(alpha: 0.58),
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
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (model.isActive
                                              ? Colors.green
                                              : Colors.grey.shade500)
                                          .withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      model.isActive ? 'Ativa' : 'Inativa',
                                      style: TextStyle(
                                        color: model.isActive
                                            ? Colors.green.shade200
                                            : Colors.grey.shade300,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                (model.description?.isNotEmpty ?? false)
                                    ? model.description!
                                    : 'Sem descrição',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.white70),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.category_outlined,
                                      size: 18, color: Colors.white70),
                                  const SizedBox(width: 6),
                                  Text(
                                    model.category?.name ??
                                        'Categoria ${model.categoryId}',
                                    style: Theme.of(
                                      context,
                                    )
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.visibility_outlined),
                                    tooltip: 'Ver pista',
                                    onPressed: () => Get.toNamed(
                                        '/living_clues/show',
                                        arguments: model),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.edit),
                                    onPressed: _controller.isLoading.value
                                        ? null
                                        : () => _goToUpdate(model),
                                    tooltip: 'Editar',
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: _controller.isLoading.value
                                        ? null
                                        : () => _confirmDelete(model),
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
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              ],
            );
          }),
        ],
      ),
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
    final result = await Get.toNamed('/living_clues/type_select');
    if (result == true || (result is Map && result['created'] == true)) {
      await _controller.loadLivingClues();
    }
  }

  Future<void> _goToUpdate(LivingClueModel model) async {
    await Get.toNamed('/living_clues/update',
        parameters: {'id': model.id.toString()});
    await _controller.loadLivingClues();
  }
}
