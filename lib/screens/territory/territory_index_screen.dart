import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/territory/territory_index_controller.dart';
import 'package:unisinos_usp_app/models/territory_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';

class TerritoryIndexScreen extends StatelessWidget {
  TerritoryIndexScreen({super.key});
  final TerritoryIndexController _controller =
      Get.find<TerritoryIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Territórios'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _goToCreate),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.black.withValues(alpha: 0.58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color(0x8A46B6EC),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Obx(
                      () => DropdownButtonFormField<int?>(
                        initialValue: _controller.selectedBiomeId.value,
                        dropdownColor: Colors.grey.shade900,
                        decoration: const InputDecoration(
                          labelText: 'Filtrar por bioma',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('Todos os biomas'),
                          ),
                          ..._controller.biomes.map(
                            (b) => DropdownMenuItem<int?>(
                              value: b.id,
                              child: Text(b.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          _controller.selectedBiomeId.value = value;
                          _controller.loadTerritories();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value &&
                      _controller.territories.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (_controller.territories.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum território cadastrado.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: _controller.territories.length,
                    itemBuilder: (_, index) {
                      final TerritoryModel model =
                          _controller.territories[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Colors.black.withValues(alpha: 0.58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(
                            color: Color(0x8A46B6EC),
                            width: 1.2,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            model.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            '${model.type} • ${model.biome?.name ?? 'Bioma ${model.biomeId}'}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.edit),
                                onPressed: () => _goToUpdate(model),
                              ),
                              IconButton(
                                color: Colors.white,
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _confirmDelete(model),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(TerritoryModel model) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF09192E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0x8A46B6EC),
            width: 1.2,
          ),
        ),
        title: const Text(
          'Confirmar exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Deseja realmente excluir "${model.name}"?',
          style: const TextStyle(color: Color(0xFFA4C0E6)),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB3261E),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back();
              _controller.deleteTerritory(model);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Future<void> _goToCreate() async {
    await Get.toNamed('/territories/create');
    await _controller.loadTerritories();
  }

  Future<void> _goToUpdate(TerritoryModel model) async {
    await Get.toNamed(
      '/territories/update',
      parameters: {'id': model.id.toString()},
    );
    await _controller.loadTerritories();
  }
}
