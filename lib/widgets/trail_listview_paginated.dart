import 'package:unisinos_usp_app/controllers/trail_manager_controller.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailListviewPaginated extends StatefulWidget {
  final TrailManagerController controller;
  final bool isReorderable;

  const TrailListviewPaginated({
    super.key,
    required this.controller,
    this.isReorderable = false,
  });

  @override
  State<TrailListviewPaginated> createState() => _TrailListviewPaginatedState();
}

class _TrailListviewPaginatedState extends State<TrailListviewPaginated> {
  late final ScrollController _controller;
  int offset = 0;

  @override
  void initState() {
    super.initState();
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
      if (widget.controller.isLoading.value && widget.controller.trails.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (widget.controller.trails.isEmpty) {
        return const Center(child: Text('Nenhuma trilha encontrada'));
      }

      if (widget.isReorderable) {
        return ReorderableListView.builder(
          scrollController: _controller,
          itemCount: widget.controller.trails.length,
          onReorder: widget.controller.reorderTrails,
          itemBuilder: (context, index) {
            final trail = widget.controller.trails[index];
            return Card(
              key: ValueKey(trail.id),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: ReorderableDragStartListener(
                  index: index,
                  child: ImageWidget(
                    image: trail.coverImageFile,
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text(
                  trail.name,
                  style: primaryTextStyle(size: 14, weight: FontWeight.bold),
                ),
                subtitle: Text(
                  trail.category?.name ?? 'Sem categoria',
                  style: secondaryTextStyle(size: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        trail.status ? Icons.toggle_on : Icons.toggle_off,
                        color: trail.status ? Colors.green : Colors.red,
                      ),
                      onPressed: () => widget.controller.toggleStatus(trail),
                    ),
                    _buildPopupMenu(context, trail),
                  ],
                ),
                onTap: () async {
                  await Get.toNamed('/trail_editor', arguments: trail);
                  await widget.controller.fetch();
                },
              ),
            );
          },
        );
      } else {
        return ListView.builder(
          controller: _controller,
          itemCount: widget.controller.trails.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.controller.trails.length) {
              return widget.controller.isLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox.shrink();
            }

            final trail = widget.controller.trails[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: ImageWidget(
                  image: trail.coverImageFile,
                  width: 40,
                  height: 40,
                ),
                title: Text(
                  trail.name,
                  style: primaryTextStyle(size: 14, weight: FontWeight.bold),
                ),
                subtitle: Text(
                  trail.category?.name ?? 'Sem categoria',
                  style: secondaryTextStyle(size: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        trail.status ? Icons.toggle_on : Icons.toggle_off,
                        color: trail.status ? Colors.green : Colors.red,
                      ),
                      onPressed: () => widget.controller.toggleStatus(trail),
                    ),
                    _buildPopupMenu(context, trail),
                  ],
                ),
                onTap: () async {
                  await Get.toNamed('/trail_editor', arguments: trail);
                  await widget.controller.fetch();
                },
              ),
            );
          },
        );
      }
    });
  }

  Widget _buildPopupMenu(BuildContext context, TrailModel trail) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        if (result == 'delete') {
          Get.dialog(
            AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: Text('Tem certeza que deseja excluir a trilha "${trail.name}"?'),
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text('Cancelar')),
                TextButton(
                  onPressed: () {
                    widget.controller.deleteTrail(trail);
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
