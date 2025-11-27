import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/category/category_index_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';

class CategoryIndexScreen extends StatelessWidget {
  CategoryIndexScreen({super.key});

  final CategoryIndexController _controller = Get.find<CategoryIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/categories/create'),
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

        return RefreshIndicator(
          onRefresh: _controller.refreshCategories,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _controller.categories.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              final CategoryModel category = _controller.categories[index];
              return ListTile(
                leading: _ColorDot(colorHex: category.colorHex),
                title: Text(category.name),
                subtitle: category.description?.isNotEmpty == true ? Text(category.description!) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => Get.toNamed('/categories/update', arguments: category),
                      tooltip: 'Editar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(category),
                      tooltip: 'Excluir',
                    ),
                  ],
                ),
              );
            },
          ),
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
