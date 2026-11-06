import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/locker_panel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/node_graph/node_graph_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/node_link_model.dart';
import 'package:unisinos_usp_app/models/node_model.dart';
import 'package:unisinos_usp_app/models/node_type_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'dart:math' as math;
import 'package:unisinos_usp_app/screens/space/research_room_painter.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:widgets_spo/widgets_spo.dart';

class NodeGraphScreen extends StatefulWidget {
  const NodeGraphScreen({super.key, this.controllerFactory, this.fromClue = false});
  final bool fromClue;
  final NodeGraphController Function()? controllerFactory;

  @override
  State<NodeGraphScreen> createState() => _NodeGraphScreenState();
}

class _NodeGraphScreenState extends State<NodeGraphScreen> {
  static const String _screenName = 'Problemáticas';
  static const Size _graphCanvasSize = Size(1800, 1400);
  // Each route owns its analysis state. Opening an AI reference must not reuse
  // another graph route's selection or overwrite its filters on return.
  final String _controllerTag = UniqueKey().toString();
  late final NodeGraphController _controller;
  final TransformationController _transformationController =
      TransformationController();
  bool _didCenterGraph = false;
  final _searchController = TextEditingController();

  late final String _contextRoute = Get.currentRoute;
  late final AiAssistantContextProvider _contextProvider = _buildAiContext;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(widget.controllerFactory?.call() ?? NodeGraphController(), tag: _controllerTag);
    _searchController.text = _controller.searchQuery.value;
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(_contextRoute, _contextProvider);
    }
    _searchController.dispose();
    _transformationController.dispose();
    Get.delete<NodeGraphController>(tag: _controllerTag);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      _contextRoute,
      _contextProvider,
    );
    return Theme(
      data: spaceRecordTheme(),
      child: Scaffold(
        backgroundColor: const Color(0xFF050C18),
        body: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: ResearchRoomPainter()),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _returnToCockpit,
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: Text(widget.fromClue ? 'Voltar à pista' : 'Cockpit'),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'RASTROS E PROBLEMÁTICAS',
                            style: TextStyle(
                              color: Color(0xFF9CE7DF),
                              letterSpacing: 1.6,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (Get.find<UserController>().user.value?.canAuthor ==
                            true)
                          IconButton(
                            onPressed: _openCreateNodeSheet,
                            icon: const Icon(Icons.add_circle_outline),
                            tooltip: 'Nova problemática',
                          ),
                        IconButton(
                          onPressed: _controller.loadGraph,
                          icon: const Icon(Icons.refresh),
                          tooltip: 'Recarregar',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Obx(() {
                        final nodes = _controller.visibleNodes;
                        final links = _controller.visibleLinks;
                        final neighbors = _controller.neighborNodeIds;
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            final wide = constraints.maxWidth >= 700;
                            final panel = AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: _controller.selectedNodeId.value == null
                                  ? const Padding(
                                      key: ValueKey('idle'),
                                      padding: EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.hub_outlined,
                                            color: Color(0xFF9CE7DF),
                                            size: 38,
                                          ),
                                          SizedBox(height: 20),
                                          Text(
                                            'Analisar a rede',
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            'Selecione uma problemática para conhecer seu tipo, explorar conexões e acessar as ações disponíveis.',
                                            style: TextStyle(
                                              color: Color(0xFFB2CDD5),
                                              height: 1.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _SelectedNodePanel(
                                      key: ValueKey(
                                        _controller.selectedNodeId.value,
                                      ),
                                      controller: _controller,
                                      onCreateNear: _openCreateNodeSheet,
                                      onConnect: _openConnectSelectedNodeSheet,
                                      onConnections:
                                          _openSelectedNodeConnectionsSheet,
                                      onEdit: _openEditSelectedNodeSheet,
                                      onDelete: _confirmDeleteSelectedNode,
                                    ),
                            );
                            final filters = _GraphFilters(
                              searchController: _searchController,
                              controller: _controller,
                            );
                            final graph = Column(
                              children: [
                                if (_controller.errorMessage.value != null)
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      _controller.errorMessage.value!,
                                      style: const TextStyle(
                                        color: Color(0xFFFFB5B5),
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: LayoutBuilder(
                                    builder: (context, viewport) {
                                      _viewport = Size(
                                        viewport.maxWidth,
                                        viewport.maxHeight,
                                      );
                                      if (nodes.isNotEmpty)
                                        _centerGraphIfNeeded(_viewport);
                                      return Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: const Color(0xDD061421),
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFF315766),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child:
                                                  _controller.isLoading.value &&
                                                      nodes.isEmpty
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : nodes.isEmpty
                                                  ? _GraphEmptyState(
                                                      hasLoadedNodes:
                                                          _controller
                                                              .graphNodes
                                                              .isNotEmpty,
                                                      hasActiveFilters:
                                                          _controller
                                                              .searchQuery
                                                              .value
                                                              .isNotEmpty ||
                                                          _controller
                                                                  .minimumDegree
                                                                  .value >
                                                              0 ||
                                                          _controller
                                                                  .selectedTypeIds
                                                                  .length !=
                                                              _controller
                                                                  .nodeTypes
                                                                  .length,
                                                      onCreatePressed:
                                                          _openCreateNodeSheet,
                                                    )
                                                  : InteractiveViewer(
                                                      transformationController:
                                                          _transformationController,
                                                      constrained: false,
                                                      minScale: 0.2,
                                                      maxScale: 3.5,
                                                      boundaryMargin:
                                                          const EdgeInsets.all(
                                                            600,
                                                          ),
                                                      child: SizedBox(
                                                        width: _graphCanvasSize
                                                            .width,
                                                        height: _graphCanvasSize
                                                            .height,
                                                        child: Stack(
                                                          children: [
                                                            Positioned.fill(
                                                              child: CustomPaint(
                                                                painter: _GraphLinkPainter(
                                                                  nodes: nodes,
                                                                  links: links,
                                                                  selectedNodeId:
                                                                      _controller
                                                                          .selectedNodeId
                                                                          .value,
                                                                  neighborNodeIds:
                                                                      neighbors,
                                                                ),
                                                              ),
                                                            ),
                                                            for (final node
                                                                in nodes)
                                                              Positioned(
                                                                left:
                                                                    node
                                                                        .position
                                                                        .dx +
                                                                    (_graphCanvasSize
                                                                            .width /
                                                                        2) -
                                                                    node.radius,
                                                                top:
                                                                    node
                                                                        .position
                                                                        .dy +
                                                                    (_graphCanvasSize
                                                                            .height /
                                                                        2) -
                                                                    node.radius,
                                                                child: _GraphNodeWidget(
                                                                  node: node,
                                                                  isSelected:
                                                                      _controller
                                                                          .selectedNodeId
                                                                          .value ==
                                                                      node
                                                                          .node
                                                                          .id,
                                                                  isNeighbor:
                                                                      _controller
                                                                              .selectedNodeId
                                                                              .value ==
                                                                          null ||
                                                                      neighbors.contains(
                                                                        node
                                                                            .node
                                                                            .id,
                                                                      ),
                                                                  onTap: () => _controller
                                                                      .selectNode(
                                                                        node
                                                                            .node
                                                                            .id,
                                                                      ),
                                                                  onDragUpdate: (details) {
                                                                    final double
                                                                    scale = _transformationController
                                                                        .value
                                                                        .getMaxScaleOnAxis();
                                                                    _controller.updateNodePosition(
                                                                      node
                                                                          .node
                                                                          .id,
                                                                      node.position +
                                                                          details.delta /
                                                                              scale,
                                                                    );
                                                                  },
                                                                  onDragEnd: () =>
                                                                      _controller.persistNodePosition(
                                                                        node
                                                                            .node
                                                                            .id,
                                                                      ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                            Positioned(
                                              top: 14,
                                              left: 16,
                                              child: IgnorePointer(
                                                child: Text(
                                                  '${nodes.length} PROBLEMÁTICAS  /  ${links.length} CONEXÕES',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    letterSpacing: 1.5,
                                                    color: Color(0xFF9CE7DF),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 12,
                                              right: 12,
                                              child: Card(
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () =>
                                                          _zoom(.8),
                                                      icon: const Icon(
                                                        Icons.remove,
                                                      ),
                                                      tooltip: 'Reduzir',
                                                    ),
                                                    IconButton(
                                                      onPressed: () =>
                                                          _zoom(1.25),
                                                      icon: const Icon(
                                                        Icons.add,
                                                      ),
                                                      tooltip: 'Ampliar',
                                                    ),
                                                    IconButton(
                                                      onPressed: _fitGraph,
                                                      icon: const Icon(
                                                        Icons
                                                            .center_focus_strong,
                                                      ),
                                                      tooltip:
                                                          'Reenquadrar rede',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                            final hasSelection =
                                _controller.selectedNodeId.value != null;
                            final headerHeight = math.min(
                              wide ? 280.0 : (hasSelection ? 320.0 : 240.0),
                              constraints.maxHeight *
                                  (wide ? .36 : (hasSelection ? .46 : .33)),
                            );
                            return Column(
                              children: [
                                SizedBox(
                                  height: headerHeight,
                                  child: wide
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: _RoomPanel(child: filters),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              flex: 2,
                                              child: _RoomPanel(
                                                resetKey: _controller
                                                    .selectedNodeId
                                                    .value,
                                                child: panel,
                                              ),
                                            ),
                                          ],
                                        )
                                      : _RoomPanel(
                                          resetKey:
                                              _controller.selectedNodeId.value,
                                          child: Column(
                                            children: [
                                              if (hasSelection) panel,
                                              filters,
                                            ],
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 12),
                                Expanded(child: graph),
                              ],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Size _viewport = Size.zero;

  void _returnToCockpit() {
    if (widget.fromClue && Navigator.of(context).canPop()) {
      Get.back();
      return;
    }
    var found = false;
    Get.until((route) {
      found = route.settings.name == '/space';
      return found || route.isFirst;
    });
    if (!found) Get.offNamed('/space');
  }

  void _zoom(double factor) {
    final matrix = _transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();
    final next = (scale * factor).clamp(.2, 3.5);
    final ratio = next / scale;
    _transformationController.value = Matrix4.identity()
      ..setEntry(0, 0, next)
      ..setEntry(1, 1, next)
      ..setEntry(
        0,
        3,
        _viewport.width / 2 +
            (matrix.entry(0, 3) - _viewport.width / 2) * ratio,
      )
      ..setEntry(
        1,
        3,
        _viewport.height / 2 +
            (matrix.entry(1, 3) - _viewport.height / 2) * ratio,
      );
  }

  void _fitGraph() {
    final nodes = _controller.visibleNodes;
    if (nodes.isEmpty || _viewport.isEmpty) return;
    final left = nodes.map((n) => n.position.dx - n.radius).reduce(math.min);
    final right = nodes.map((n) => n.position.dx + n.radius).reduce(math.max);
    final top = nodes.map((n) => n.position.dy - n.radius).reduce(math.min);
    final bottom = nodes.map((n) => n.position.dy + n.radius).reduce(math.max);
    final scale = math
        .min(
          (_viewport.width - 90) / math.max(1, right - left),
          (_viewport.height - 100) / math.max(1, bottom - top),
        )
        .clamp(.2, 1.3);
    _transformationController.value = Matrix4.identity()
      ..translate(
        _viewport.width / 2 - (900 + (left + right) / 2) * scale,
        _viewport.height / 2 - (700 + (top + bottom) / 2) * scale,
      )
      ..scale(scale);
  }

  void _centerGraphIfNeeded(Size viewportSize) {
    if (_didCenterGraph || viewportSize.isEmpty) return;
    _didCenterGraph = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _fitGraph();
    });
  }

  AiAssistantScreenContext _buildAiContext() {
    final NodeModel? selectedNode = _selectedNode;
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: _contextRoute,
      stage: 'mapeamento e análise de problemáticas',
      goal: 'criar, conectar, editar e organizar entidades no grafo',
      references: {if (selectedNode != null) 'node_id': selectedNode.id},
      visibleRecords: _controller.visibleNodes.take(20).map((entry) => AiRecordReference(kind: 'node', id: entry.node.id, name: entry.node.name)).toList(),
      visibleFields: const <String>[
        'tipos de problemática',
        'grau mínimo',
        'grafo interativo',
        'painel da problemática selecionada',
      ],
      filledFields: <String, String>{
        'problemáticas carregadas': _controller.graphNodes.length.toString(),
        'ligações carregadas': _controller.graphLinks.length.toString(),
        'tipos de problemática carregados': _controller.nodeTypes.length
            .toString(),
        'busca': _controller.searchQuery.value,
        'ids dos tipos ativos': _controller.selectedTypeIds.join(', '),
        'relações da seleção': _controller.graphLinks.where((link) => link.sourceNodeId == selectedNode?.id || link.targetNodeId == selectedNode?.id).take(20).map((link) => '${link.sourceNodeId} → ${link.targetNodeId}').join('; '),
        'grau mínimo': _controller.minimumDegree.value.toString(),
        'tipos ativos': _controller.selectedTypeIds.length.toString(),
        if (selectedNode != null) 'problemática selecionada': selectedNode.name,
        if (selectedNode != null)
          'tipo da problemática selecionada':
              selectedNode.nodeType?.name ?? 'Tipo #${selectedNode.nodeTypeId}',
      },
      notes: <String>[
        if (_controller.selectedNodeId.value != null)
          'Há uma problemática selecionada e o painel contextual está disponível.',
        if (_controller.visibleNodes.isEmpty)
          'Os filtros atuais podem estar escondendo todas as problemáticas visíveis.',
        'O usuário pode arrastar problemáticas, criar conexões e editar o grafo sem sair da tela.',
      ],
    );
  }

  Future<void> _openCreateNodeSheet() async {
    if (Get.find<UserController>().user.value?.canAuthor != true) return;
    if (_controller.nodeTypes.isEmpty) {
      Get.customSnackbar(
        'Erro',
        'Cadastre um tipo de problemática antes de criar problemáticas.',
      );
      return;
    }

    await Get.bottomSheet<void>(
      _NodeEditorSheet(
        title: 'Nova problemática',
        submitLabel: 'Criar problemática',
        nodeTypes: _controller.nodeTypes.toList(),
        isSaving: _controller.isSavingNode,
        initialColor: '#0EA5E9',
        onSubmit: (draft) => _controller.createNode(
          name: draft.name,
          color: draft.color,
          nodeTypeId: draft.nodeTypeId,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _openEditSelectedNodeSheet() async {
    if (Get.find<UserController>().user.value?.canAuthor != true) return;
    final NodeModel? node = _selectedNode;
    if (node == null) return;

    await Get.bottomSheet<void>(
      _NodeEditorSheet(
        title: 'Editar problemática',
        submitLabel: 'Salvar alterações',
        nodeTypes: _controller.nodeTypes.toList(),
        isSaving: _controller.isSavingNode,
        initialNode: node,
        onSubmit: (draft) => _controller.updateNode(
          id: node.id,
          name: draft.name,
          color: draft.color,
          nodeTypeId: draft.nodeTypeId,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _openConnectSelectedNodeSheet() async {
    if (Get.find<UserController>().user.value?.canAuthor != true) return;
    final NodeModel? sourceNode = _selectedNode;
    if (sourceNode == null) return;

    await Get.bottomSheet<void>(
      _NodeConnectionSheet(
        sourceNode: sourceNode,
        availableTargets: _controller.availableTargetsFor(sourceNode.id),
        isSaving: _controller.isSavingLink,
        onSubmit: (targetNodeId) => _controller.createLink(
          sourceNodeId: sourceNode.id,
          targetNodeId: targetNodeId,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _openSelectedNodeConnectionsSheet() async {
    final NodeModel? node = _selectedNode;
    if (node == null) return;

    await Get.bottomSheet<void>(
      _NodeConnectionsSheet(controller: _controller, sourceNode: node),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _confirmDeleteSelectedNode() async {
    if (Get.find<UserController>().user.value?.canAuthor != true) return;
    final NodeModel? node = _selectedNode;
    if (node == null) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir problemática'),
        content: Text('Deseja realmente excluir "${node.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _controller.deleteNode(node.id);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  NodeModel? get _selectedNode {
    final int? selectedId = _controller.selectedNodeId.value;
    if (selectedId == null) return null;
    for (final item in _controller.graphNodes) {
      if (item.node.id == selectedId) return item.node;
    }
    return null;
  }
}

class _GraphEmptyState extends StatelessWidget {
  const _GraphEmptyState({
    required this.hasLoadedNodes,
    required this.hasActiveFilters,
    required this.onCreatePressed,
  });

  final bool hasLoadedNodes;
  final bool hasActiveFilters;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    final String title = hasLoadedNodes
        ? 'Nenhuma problemática encontrada'
        : 'A rede ainda está vazia';
    final String message = hasLoadedNodes
        ? 'Ajuste a busca ou os filtros para explorar outras problemáticas.'
        : 'As problemáticas cadastradas aparecerão neste painel de análise.';

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          color: Colors.white.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hub_outlined, color: Colors.white70, size: 38),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.78)),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed:
                      Get.find<UserController>().user.value?.canAuthor == true
                      ? onCreatePressed
                      : null,
                  icon: const Icon(Icons.add),
                  label: Text(
                    hasLoadedNodes
                        ? 'Criar nova problemática'
                        : 'Criar primeira problemática',
                  ),
                ),
                if (hasActiveFilters) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Tente limpar a busca e os filtros de tipo e conexões.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomPanel extends StatefulWidget {
  const _RoomPanel({required this.child, this.resetKey});
  final Widget child;
  final Object? resetKey;
  @override
  State<_RoomPanel> createState() => _RoomPanelState();
}

class _RoomPanelState extends State<_RoomPanel> {
  final _scroll = ScrollController();
  @override
  void didUpdateWidget(covariant _RoomPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.resetKey != widget.resetKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scroll.hasClients) _scroll.jumpTo(0);
      });
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Scrollbar(
      controller: _scroll,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      child: SingleChildScrollView(controller: _scroll, child: widget.child),
    ),
  );
}

class _SelectedNodePanel extends StatelessWidget {
  const _SelectedNodePanel({
    super.key,
    required this.controller,
    required this.onCreateNear,
    required this.onConnect,
    required this.onConnections,
    required this.onEdit,
    required this.onDelete,
  });

  final NodeGraphController controller;
  final VoidCallback onCreateNear;
  final VoidCallback onConnect;
  final VoidCallback onConnections;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final int? selectedId = controller.selectedNodeId.value;
    if (selectedId == null) return const SizedBox.shrink();

    NodeGraphNodeState? state;
    for (final item in controller.graphNodes) {
      if (item.node.id == selectedId) {
        state = item;
        break;
      }
    }
    if (state == null) return const SizedBox.shrink();

    final NodeModel node = state.node;
    final int connections = controller.graphLinks
        .where(
          (link) =>
              link.sourceNodeId == node.id || link.targetNodeId == node.id,
        )
        .length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: _parseHexColor(node.color),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'NODO SELECIONADO',
                  style: TextStyle(
                    color: Color(0xFF9CE7DF),
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
              LockerButton(type: 'node', id: node.id),
              IconButton(
                onPressed: () => controller.selectNode(null),
                tooltip: 'Fechar análise',
                icon: const Icon(Icons.close, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            node.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MetaChip(
                label: node.nodeType?.name ?? 'Tipo #${node.nodeTypeId}',
              ),
              _MetaChip(label: '$connections conexões'),
              _MetaChip(label: 'Grau de conexão ${state.degree}'),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed:
                    Get.find<UserController>().user.value?.canAuthor == true
                    ? onCreateNear
                    : null,
                icon: const Icon(Icons.add_link),
                label: const Text('Nova problemática próxima'),
              ),
              OutlinedButton.icon(
                onPressed:
                    Get.find<UserController>().user.value?.canAuthor == true
                    ? onConnect
                    : null,
                icon: const Icon(Icons.hub_outlined),
                label: const Text('Conectar'),
              ),
              OutlinedButton.icon(
                onPressed: onConnections,
                icon: const Icon(Icons.link_off_outlined),
                label: const Text('Conexões'),
              ),
              FilledButton.icon(
                onPressed:
                    Get.find<UserController>().user.value?.canAuthor == true
                    ? onEdit
                    : null,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Editar'),
              ),
              TextButton.icon(
                onPressed:
                    controller.isDeletingNode.value ||
                        Get.find<UserController>().user.value?.canAuthor != true
                    ? null
                    : onDelete,
                icon: const Icon(Icons.delete_outline),
                label: Text(
                  controller.isDeletingNode.value ? 'Excluindo...' : 'Excluir',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _parseHexColor(String value) {
    final String hex = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70)),
    );
  }
}

class _NodeDraft {
  _NodeDraft({
    required this.name,
    required this.color,
    required this.nodeTypeId,
  });

  final String name;
  final String color;
  final int nodeTypeId;
}

class _NodeEditorSheet extends StatefulWidget {
  const _NodeEditorSheet({
    required this.title,
    required this.submitLabel,
    required this.nodeTypes,
    required this.isSaving,
    required this.onSubmit,
    this.initialNode,
    this.initialColor,
  });

  final String title;
  final String submitLabel;
  final List<NodeTypeModel> nodeTypes;
  final RxBool isSaving;
  final Future<NodeModel?> Function(_NodeDraft draft) onSubmit;
  final NodeModel? initialNode;
  final String? initialColor;

  @override
  State<_NodeEditorSheet> createState() => _NodeEditorSheetState();
}

class _NodeConnectionSheet extends StatefulWidget {
  const _NodeConnectionSheet({
    required this.sourceNode,
    required this.availableTargets,
    required this.isSaving,
    required this.onSubmit,
  });

  final NodeModel sourceNode;
  final List<NodeModel> availableTargets;
  final RxBool isSaving;
  final Future<NodeLinkModel?> Function(int targetNodeId) onSubmit;

  @override
  State<_NodeConnectionSheet> createState() => _NodeConnectionSheetState();
}

class _NodeConnectionSheetState extends State<_NodeConnectionSheet> {
  int? _targetNodeId;

  @override
  void initState() {
    super.initState();
    if (widget.availableTargets.isNotEmpty) {
      _targetNodeId = widget.availableTargets.first.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF10151D),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Conectar problemática',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Origem: ${widget.sourceNode.name}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
                ),
                const SizedBox(height: 20),
                if (widget.availableTargets.isEmpty)
                  Text(
                    'Todas as outras problemáticas já estão conectadas a esta problemática.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.78),
                    ),
                  )
                else
                  DropdownButtonFormField<int>(
                    initialValue: _targetNodeId,
                    dropdownColor: const Color(0xFF10151D),
                    decoration: InputDecoration(
                      labelText: 'Problemática de destino',
                      labelStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    items: widget.availableTargets
                        .map(
                          (node) => DropdownMenuItem<int>(
                            value: node.id,
                            child: Text(node.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _targetNodeId = value);
                    },
                  ),
                const SizedBox(height: 20),
                Obx(() {
                  final bool saving = widget.isSaving.value;
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: saving
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed:
                              saving ||
                                  _targetNodeId == null ||
                                  widget.availableTargets.isEmpty
                              ? null
                              : _submit,
                          child: Text(
                            saving ? 'Conectando...' : 'Criar ligação',
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final int? targetNodeId = _targetNodeId;
    if (targetNodeId == null) return;
    final NodeLinkModel? link = await widget.onSubmit(targetNodeId);
    if (link != null && mounted) {
      Navigator.of(context).pop(link);
    }
  }
}

class _NodeConnectionsSheet extends StatelessWidget {
  const _NodeConnectionsSheet({
    required this.controller,
    required this.sourceNode,
  });

  final NodeGraphController controller;
  final NodeModel sourceNode;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF10151D),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Obx(() {
              final List<NodeLinkModel> connections = controller.connectionsFor(
                sourceNode.id,
              );

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conexões de ${sourceNode.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remova vínculos sem sair do mapa.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (connections.isEmpty)
                    Text(
                      'Esta problemática ainda não possui conexões.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 360),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: connections.length,
                        separatorBuilder: (_, __) => Divider(
                          color: Colors.white.withValues(alpha: 0.08),
                          height: 1,
                        ),
                        itemBuilder: (_, index) {
                          final NodeLinkModel link = connections[index];
                          final NodeModel? otherNode = controller
                              .otherNodeForLink(link, sourceNode.id);
                          final String label =
                              otherNode?.name ??
                              'Problemática #${link.sourceNodeId == sourceNode.id ? link.targetNodeId : link.sourceNodeId}';

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              label,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Ligação #${link.id}',
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: TextButton.icon(
                              onPressed:
                                  Get.find<UserController>()
                                              .user
                                              .value
                                              ?.canAuthor !=
                                          true ||
                                      controller.isDeletingLink.value
                                  ? null
                                  : () => _confirmDeleteLink(
                                      context,
                                      link,
                                      label,
                                    ),
                              icon: const Icon(Icons.delete_outline),
                              label: Text(
                                controller.isDeletingLink.value
                                    ? 'Removendo...'
                                    : 'Remover',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Fechar'),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  void _confirmDeleteLink(
    BuildContext context,
    NodeLinkModel link,
    String otherNodeName,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remover conexão'),
        content: Text('Deseja remover a conexão com "$otherNodeName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await controller.deleteLink(link.id);
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }
}

class _NodeEditorSheetState extends State<_NodeEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _colorController;
  late int _nodeTypeId;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialNode?.name ?? '',
    );
    _colorController = TextEditingController(
      text: widget.initialNode?.color ?? widget.initialColor ?? '#0EA5E9',
    );
    _nodeTypeId = widget.initialNode?.nodeTypeId ?? widget.nodeTypes.first.id;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF10151D),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Preencha o essencial para colocar a problemática no mapa.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InputText(
                      hintText: 'Nome da problemática',
                      controller: _nameController,
                      validator: (value) => PValidator([
                        PRuleRequired(value, message: 'Obrigatório'),
                        PRuleMaxString(
                          value,
                          120,
                          message: 'Máximo de 120 caracteres',
                        ),
                      ]).val(),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: _nodeTypeId,
                      dropdownColor: const Color(0xFF10151D),
                      decoration: InputDecoration(
                        labelText: 'Tipo de problemática',
                        labelStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.08),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: widget.nodeTypes
                          .map(
                            (type) => DropdownMenuItem<int>(
                              value: type.id,
                              child: Text(type.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _nodeTypeId = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    InputText(
                      hintText: 'Cor hexadecimal',
                      controller: _colorController,
                      validator: _validateColor,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _pickColor,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: _parseHexColor(_colorController.text),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Escolher cor',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              _normalizedHex(_colorController.text),
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      final bool saving = widget.isSaving.value;
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: saving
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: saving ? null : _submit,
                              child: Text(
                                saving ? 'Salvando...' : widget.submitLabel,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickColor() async {
    Color tempColor = _parseHexColor(_colorController.text);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Selecionar cor'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) => tempColor = color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _colorController.text = _colorToHex(tempColor);
              setState(() {});
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Usar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final NodeModel? node = await widget.onSubmit(
      _NodeDraft(
        name: _nameController.text.trim(),
        color: _normalizedHex(_colorController.text),
        nodeTypeId: _nodeTypeId,
      ),
    );
    if (node != null && mounted) {
      Navigator.of(context).pop(node);
    }
  }

  String? _validateColor(String? value) {
    final String text = value?.trim() ?? '';
    final RegExp regex = RegExp(r'^#?[0-9A-Fa-f]{6}$');
    if (text.isEmpty) return 'Obrigatório';
    if (!regex.hasMatch(text)) return 'Informe uma cor HEX válida';
    return null;
  }

  String _normalizedHex(String value) {
    final String raw = value.trim().replaceAll('#', '');
    return '#${raw.padLeft(6, '0').toUpperCase()}';
  }

  Color _parseHexColor(String value) {
    final String hex = _normalizedHex(value).replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}

class _GraphFilters extends StatelessWidget {
  const _GraphFilters({
    required this.controller,
    required this.searchController,
  });

  final TextEditingController searchController;

  final NodeGraphController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            onChanged: controller.updateSearch,
            decoration: const InputDecoration(
              isDense: true,
              prefixIcon: Icon(Icons.search),
              hintText: 'Buscar problemática pelo nome',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.nodeTypes.map((type) {
              final Color accentColor = _parseHexColor(type.color);
              final bool isSelected = controller.selectedTypeIds.contains(
                type.id,
              );
              final Color selectedBackground = Color.alphaBlend(
                accentColor.withValues(alpha: 0.28),
                const Color(0xFF10151D),
              );

              return FilterChip(
                label: Text(type.name),
                selected: isSelected,
                selectedColor: selectedBackground,
                backgroundColor: const Color(0xFF161C24),
                labelStyle: TextStyle(
                  color: isSelected
                      ? _contrastingTextColor(selectedBackground)
                      : Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.95)
                      : accentColor.withValues(alpha: 0.55),
                ),
                checkmarkColor: _contrastingTextColor(selectedBackground),
                onSelected: (selected) =>
                    controller.toggleType(type.id, selected),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.tune, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Conexões mín.',
                style: TextStyle(color: Colors.white),
              ),
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
            'Toque para selecionar. Arraste uma problemática para reposicionar. Use o gesto de pinça ou a rolagem para ampliar.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
          ),
        ],
      ),
    );
  }

  Color _parseHexColor(String value) {
    final String hex = value.replaceAll('#', '').padLeft(6, '0');
    return Color(int.parse('FF$hex', radix: 16));
  }

  Color _contrastingTextColor(Color color) {
    return color.computeLuminance() > 0.55 ? Colors.black : Colors.white;
  }
}

class _GraphNodeWidget extends StatelessWidget {
  const _GraphNodeWidget({
    required this.node,
    required this.isSelected,
    required this.isNeighbor,
    required this.onTap,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final NodeGraphNodeState node;
  final bool isSelected;
  final bool isNeighbor;
  final VoidCallback onTap;
  final ValueChanged<DragUpdateDetails> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    final Color color = _parseHexColor(node.node.color);
    final bool faded = !isSelected && !isNeighbor;
    final double size = node.radius * 2;

    return GestureDetector(
      onTap: onTap,
      onPanUpdate: onDragUpdate,
      onPanEnd: (_) => onDragEnd(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color.alphaBlend(
                color.withValues(alpha: faded ? .16 : .48),
                const Color(0xFF091B2A),
              ),
              const Color(0xFF091B2A),
            ],
          ),
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
                Flexible(
                  child: Text(
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

      final bool highlighted =
          selectedNodeId != null &&
          (link.sourceNodeId == selectedNodeId ||
              link.targetNodeId == selectedNodeId);

      final Paint paint = Paint()
        ..color = highlighted
            ? const Color(0xFF9CE7DF)
            : const Color(
                0xFF76B2C9,
              ).withValues(alpha: selectedNodeId == null ? .30 : .10)
        ..strokeWidth = highlighted ? 2 : 1
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
