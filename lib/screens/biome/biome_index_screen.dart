import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/biome/biome_index_controller.dart';
import 'package:unisinos_usp_app/models/biome_model.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';

class BiomeIndexScreen extends StatelessWidget {
  BiomeIndexScreen({super.key});
  final BiomeIndexController _controller = Get.find<BiomeIndexController>();

  @override
  Widget build(BuildContext context) {
    final canManage = AppAccessPolicy.canManageModule(
      Get.find<UserController>().user.value,
      AppModule.biomes,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Biomas'),
        actions: [
          if (canManage)
            IconButton(icon: const Icon(Icons.add), onPressed: _goToCreate),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          const Positioned.fill(child: CidigScenicBackground()),
          Obx(() {
            if (_controller.isLoading.value && _controller.biomes.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (_controller.biomes.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum bioma cadastrado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _controller.biomes.length,
              itemBuilder: (_, index) {
                final BiomeModel model = _controller.biomes[index];
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
                    leading: CircleAvatar(
                      backgroundColor: _parseColor(model.colorHex),
                    ),
                    title: Text(
                      model.name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      model.slug,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: canManage
                        ? Row(
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
                          )
                        : null,
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }

  void _confirmDelete(BiomeModel model) {
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
              _controller.deleteBiome(model);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Future<void> _goToCreate() async {
    await Get.toNamed('/biomes/create');
    await _controller.loadBiomes();
  }

  Future<void> _goToUpdate(BiomeModel model) async {
    await Get.toNamed(
      '/biomes/update',
      parameters: {'id': model.id.toString()},
    );
    await _controller.loadBiomes();
  }
}
