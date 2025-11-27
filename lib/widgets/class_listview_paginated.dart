import 'package:unisinos_usp_app/controllers/classes_manager_controller.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClassListviewPaginated extends StatefulWidget {
  final ClassesManagerController controller;
  final ItemSelectController trailSelectController;
  final bool isReorderable;

  const ClassListviewPaginated({
    super.key,
    required this.controller,
    required this.trailSelectController,
    this.isReorderable = false,
  });

  @override
  State<ClassListviewPaginated> createState() => _ClassListviewPaginatedState();
}

class _ClassListviewPaginatedState extends State<ClassListviewPaginated> {
  late final ScrollController _controller;
  int offset = 0;

  @override
  void initState() {
    super.initState();

    TrailModel? trailModel = widget.controller.trail.value;
    widget.trailSelectController.selectedItem = ItemSelect(id: trailModel?.category?.id ?? 0, name: trailModel?.category?.name ?? '');

    _controller = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      if (!widget.controller.isLoading.value) {
        widget.controller.fetch(
          offset: offset += 30,
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (widget.controller.isLoading.value && widget.controller.classes.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (widget.controller.classes.isEmpty) {
        return const Center(child: Text('Nenhuma aula encontrada'));
      }

      if (widget.isReorderable) {
        return ReorderableListView.builder(
          scrollController: _controller,
          itemCount: widget.controller.classes.length,
          onReorder: widget.controller.reorderClasses,
          itemBuilder: (context, index) {
            final model = widget.controller.classes[index];
            return Card(
              key: ValueKey(model.id),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: ReorderableDragStartListener(
                  index: index,
                  child: const Icon(
                    Icons.drag_handle,
                    color: Colors.grey,
                  ),
                ),
                title: Text(
                  model.name,
                  style: primaryTextStyle(size: 14, weight: FontWeight.bold),
                ),
                subtitle: Text(
                  model.description,
                  style: secondaryTextStyle(size: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPopupMenu(context, model),
                  ],
                ),
                onTap: () async {
                  await Get.toNamed(
                    '/class_editor',
                    arguments: {
                      'class': model,
                      'trailId': model.trailId,
                    },
                  );

                  if (widget.trailSelectController.selectedItem?.id != null) {
                    await widget.controller.fetchByTrail(widget.trailSelectController.selectedItem!.id);
                  } else {
                    await widget.controller.fetch();
                  }
                },
              ),
            );
          },
        );
      } else {
        return ListView.builder(
          controller: _controller,
          itemCount: widget.controller.classes.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.controller.classes.length) {
              return widget.controller.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }

            final model = widget.controller.classes[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  model.name,
                  style: primaryTextStyle(size: 14, weight: FontWeight.bold),
                ),
                subtitle: Text(
                  model.description,
                  style: secondaryTextStyle(size: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPopupMenu(context, model),
                  ],
                ),
                onTap: () async {
                  await Get.toNamed(
                    '/class_editor',
                    arguments: {
                      'class': model,
                      'trailId': model.trailId,
                    },
                  );

                  if (widget.trailSelectController.selectedItem?.id != null) {
                    await widget.controller.fetchByTrail(widget.trailSelectController.selectedItem!.id);
                  } else {
                    await widget.controller.fetch();
                  }
                },
              ),
            );
          },
        );
      }
    });
  }

  Widget _buildPopupMenu(BuildContext context, ClassModel classModel) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'delete') {
          Get.dialog(
            AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text('Tem certeza que deseja excluir a trilha "${classModel.name}"?'),
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    widget.controller.deleteClass(classModel);
                    Get.back();
                  },
                  child: const Text('Excluir', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
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
    );
  }
}
