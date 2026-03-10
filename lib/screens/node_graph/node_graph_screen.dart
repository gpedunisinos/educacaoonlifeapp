import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/node_graph/node_graph_controller.dart';
import 'package:unisinos_usp_app/models/node_link_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';

class NodeGraphScreen extends StatefulWidget {
  const NodeGraphScreen({super.key});

  @override
  State<NodeGraphScreen> createState() => _NodeGraphScreenState();
}

class _NodeGraphScreenState extends State<NodeGraphScreen> {
  final NodeGraphController _controller = Get.find<NodeGraphController>();
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    _transformationController.value = Matrix4.identity()
      ..translate(500.0, 420.0)
      ..scale(0.85);
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Grafo de nós'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.loadGraph,
            tooltip: 'Recarregar',
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          Obx(() {
            if (_controller.isLoading.value && _controller.graphNodes.isEmpty) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final nodes = _controller.visibleNodes;
            final links = _controller.visibleLinks;
            final neighbors = _controller.neighborNodeIds;

            return Column(
              children: [
                _GraphFilters(controller: _controller),
                if (_controller.errorMessage.value != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _controller.errorMessage.value!,
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.45),
                        child: InteractiveViewer(
                          transformationController: _transformationController,
                          constrained: false,
                          minScale: 0.2,
                          maxScale: 3.5,
                          boundaryMargin: const EdgeInsets.all(600),
                          child: SizedBox(
                            width: 1800,
                            height: 1400,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _GraphLinkPainter(
                                      nodes: nodes,
                                      links: links,
                                      selectedNodeId: _controller.selectedNodeId.value,
                                      neighborNodeIds: neighbors,
                                    ),
                                  ),
                                ),
                                for (final node in nodes)
                                  Positioned(
                                    left: node.position.dx + 900 - node.radius,
                                    top: node.position.dy + 700 - node.radius,
                                    child: _GraphNodeWidget(
                                      node: node,
                                      isSelected: _controller.selectedNodeId.value == node.node.id,
                                      isNeighbor: neighbors.contains(node.node.id),
                                      onTap: () => _controller.selectNode(node.node.id),
                                      onDragUpdate: (details) {
                                        final double scale =
                                            _transformationController.value.getMaxScaleOnAxis();
                                        _controller.updateNodePosition(
                                          node.node.id,
                                          node.position + details.delta / scale,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _GraphFilters extends StatelessWidget {
  const _GraphFilters({required this.controller});

  final NodeGraphController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.nodeTypes
                  .map(
                    (type) => FilterChip(
                      label: Text(type.name),
                      selected: controller.selectedTypeIds.contains(type.id),
                      selectedColor: _parseHexColor(type.color).withValues(alpha: 0.25),
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      labelStyle: const TextStyle(color: Colors.white),
                      side: BorderSide(color: _parseHexColor(type.color)),
                      onSelected: (selected) => controller.toggleType(type.id, selected),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.tune, color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                const Text('Grau mínimo', style: TextStyle(color: Colors.white)),
                Expanded(
                  child: Slider(
                    value: controller.minimumDegree.value.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: controller.minimumDegree.value.toString(),
                    onChanged: controller.updateMinimumDegree,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  controller.minimumDegree.value.toString(),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Toque para selecionar. Arraste um nó para reposicionar. Pinça ou scroll para zoom.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseHexColor(String value) {
    final String hex = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _GraphNodeWidget extends StatelessWidget {
  const _GraphNodeWidget({
    required this.node,
    required this.isSelected,
    required this.isNeighbor,
    required this.onTap,
    required this.onDragUpdate,
  });

  final NodeGraphNodeState node;
  final bool isSelected;
  final bool isNeighbor;
  final VoidCallback onTap;
  final ValueChanged<DragUpdateDetails> onDragUpdate;

  @override
  Widget build(BuildContext context) {
    final Color color = _parseHexColor(node.node.color);
    final bool faded = !isSelected && !isNeighbor;
    final double size = node.radius * 2;

    return GestureDetector(
      onTap: onTap,
      onPanUpdate: onDragUpdate,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: faded ? 0.35 : 0.95),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : color.withValues(alpha: 0.7),
            width: isSelected ? 3 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: isSelected ? 0.55 : 0.2),
              blurRadius: isSelected ? 18 : 8,
              spreadRadius: isSelected ? 3 : 0,
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  node.node.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: faded ? 0.7 : 1),
                    fontWeight: FontWeight.w700,
                    fontSize: size < 54 ? 10 : 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${node.degree}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: faded ? 0.65 : 0.92),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _parseHexColor(String value) {
    final String hex = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _GraphLinkPainter extends CustomPainter {
  _GraphLinkPainter({
    required this.nodes,
    required this.links,
    required this.selectedNodeId,
    required this.neighborNodeIds,
  });

  final List<NodeGraphNodeState> nodes;
  final List<NodeLinkModel> links;
  final int? selectedNodeId;
  final Set<int> neighborNodeIds;

  @override
  void paint(Canvas canvas, Size size) {
    final Map<int, NodeGraphNodeState> nodesById = {
      for (final node in nodes) node.node.id: node,
    };

    for (final link in links) {
      final source = nodesById[link.sourceNodeId];
      final target = nodesById[link.targetNodeId];
      if (source == null || target == null) continue;

      final bool highlighted = selectedNodeId != null &&
          (link.sourceNodeId == selectedNodeId || link.targetNodeId == selectedNodeId);

      final Paint paint = Paint()
        ..color = highlighted ? Colors.white : Colors.white.withValues(alpha: 0.25)
        ..strokeWidth = highlighted ? 3.2 : 1.4
        ..style = PaintingStyle.stroke;

      canvas.drawLine(
        Offset(source.position.dx + 900, source.position.dy + 700),
        Offset(target.position.dx + 900, target.position.dy + 700),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraphLinkPainter oldDelegate) {
    return oldDelegate.nodes != nodes ||
        oldDelegate.links != links ||
        oldDelegate.selectedNodeId != selectedNodeId ||
        oldDelegate.neighborNodeIds != neighborNodeIds;
  }
}
