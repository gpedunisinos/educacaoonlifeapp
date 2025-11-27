import 'package:unisinos_usp_app/controllers/category_manager_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_search.dart';
import 'package:widgets_spo/widgets/paginated_listview.dart';

class CategoriesManagerScreen extends StatelessWidget {
  final CategoryManagerController _controller = Get.find<CategoryManagerController>();

  CategoriesManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Gerenciar Categorias',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              Text(
                'Aqui você pode visualizar, editar e cadastrar categorias.',
                style: secondaryTextStyle(size: 16),
              ),
              Insets.small.height,
              InputSearch(
                initialValue: _controller.searchQuery,
                hintText: 'Pesquisar por nome',
                iconColor: Colors.black87,
                onSearch: (text) {
                  _controller.searchQuery = text ?? '';
                  _controller.fetch();
                },
              ),
              Insets.medium.height,
              Expanded(
                child: Obx(() {
                  return PaginatedListView<CategoryModel>(
                    items: _controller.categories,
                    isLoading: _controller.isLoading.value,
                    isInitialLoading: _controller.isLoading.value && _controller.categories.isEmpty,
                    onFetchMore: (offset) => _controller.fetch(offset: offset),
                    itemBuilder: (context, category, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: ImageWidget(image: category.trails?.firstOrNull?.coverImageFile, width: 50, height: 50),
                          title: Text(
                            category.name ?? 'Sem Nome',
                            style: primaryTextStyle(size: 14, weight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            category.description ?? 'Sem descrição',
                            style: secondaryTextStyle(size: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (String result) {
                              if (result == 'delete') {
                                _showDeleteConfirmationDialog(context, category);
                              }
                            },
                            itemBuilder: (context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: ListTile(
                                  leading: Icon(Icons.delete, color: Colors.red),
                                  title: Text('Excluir'),
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            await Get.toNamed('/category_editor/${category.id}', arguments: {'category_id': category.id, 'category': category});
                            await _controller.fetch();
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              Insets.medium.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Nova Categoria',
                  onPressed: () async {
                    await Get.toNamed('/category_editor');
                    await _controller.fetch();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, CategoryModel category) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir a categoria "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              _controller.deleteCategory(category);
              Get.back();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
