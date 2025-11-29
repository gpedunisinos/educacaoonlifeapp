import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_index_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';

class CategoryIndexScreen extends StatelessWidget {
  CategoryIndexScreen({super.key});

  final CategoryIndexController _controller = Get.find<CategoryIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SafeBackButton(),
        title: const Text('Categorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Nova categoria',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.categories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.categories.isEmpty) {
          return const Center(child: Text('Nenhuma categoria cadastrada.'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _controller.categories.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, index) {
                  final CategoryModel category = _controller.categories[index];
                  return ListTile(
                    leading: _ColorDot(colorHex: category.colorHex),
                    title: Text(category.name),
                    subtitle: Text(category.description ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: _controller.isLoading.value ? null : () => _goToUpdate(category),
                          tooltip: 'Editar',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: _controller.isLoading.value ? null : () => _confirmDelete(category),
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

  void _confirmDelete(CategoryModel category) {
    Get.defaultDialog(
      title: 'Excluir categoria',
      middleText: 'Deseja realmente excluir "${category.name}"?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _controller.deleteCategory(category);
      },
    );
  }

  Future<void> _goToCreate() async {
    await Get.toNamed('/categories/create');
    await _controller.loadCategories();
  }

  Future<void> _goToUpdate(CategoryModel category) async {
    await Get.toNamed('/categories/update', parameters: {'id': category.id.toString()});
    await _controller.loadCategories();
  }
}

class _ColorDot extends StatelessWidget {
  final String colorHex;

  const _ColorDot({required this.colorHex});

  @override
  Widget build(BuildContext context) {
    Color color;
    try {
      color = Color(int.parse(colorHex.replaceFirst('#', '0xff')));
    } catch (_) {
      color = Colors.grey;
    }
    return CircleAvatar(
      backgroundColor: color,
      radius: 16,
      child: const SizedBox.shrink(),
    );
  }
}
