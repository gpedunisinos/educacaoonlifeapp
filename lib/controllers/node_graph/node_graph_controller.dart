import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/node_link_model.dart';
import 'package:unisinos_usp_app/models/node_map_model.dart';
import 'package:unisinos_usp_app/models/node_model.dart';
import 'package:unisinos_usp_app/models/node_type_model.dart';
import 'package:unisinos_usp_app/webclients/node_type_webclient.dart';
import 'package:unisinos_usp_app/webclients/node_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class NodeGraphController extends GetxController {
  final NodeWebclient _nodeWebclient = NodeWebclient();
  final NodeTypeWebclient _nodeTypeWebclient = NodeTypeWebclient();

  final RxList<NodeGraphNodeState> graphNodes = <NodeGraphNodeState>[].obs;
  final RxList<NodeLinkModel> graphLinks = <NodeLinkModel>[].obs;
  final RxList<NodeTypeModel> nodeTypes = <NodeTypeModel>[].obs;
  final RxSet<int> selectedTypeIds = RxSet<int>({});
  final Rxn<int> selectedNodeId = Rxn<int>();
  final RxInt minimumDegree = 0.obs;
  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadGraph();
  }

  Future<void> loadGraph() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;
      final results = await Future.wait([
        _nodeWebclient.fetchMap(),
        _nodeTypeWebclient.fetch(limit: 200, offset: 0),
      ]);
      final NodeMapModel map = results[0] as NodeMapModel;
      final List<NodeTypeModel> types = results[1] as List<NodeTypeModel>;

      graphNodes.assignAll(_buildNodeStates(map.nodes, map.links));
      graphLinks.assignAll(map.links);
      nodeTypes.assignAll(types);
      selectedTypeIds
        ..clear()
        ..addAll(types.map((item) => item.id));
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Não foi possível carregar o grafo agora.';
    } finally {
      isLoading.value = false;
    }
  }

  List<NodeGraphNodeState> _buildNodeStates(
      List<NodeGraphNode> nodes, List<NodeLinkModel> links) {
    final Map<int, int> degreeById = <int, int>{};
    for (final link in links) {
      degreeById.update(link.sourceNodeId, (value) => value + 1,
          ifAbsent: () => 1);
      degreeById.update(link.targetNodeId, (value) => value + 1,
          ifAbsent: () => 1);
    }

    final List<NodeGraphNodeState> states = nodes
        .map(
          (graphNode) => NodeGraphNodeState(
            node: graphNode.node,
            position: graphNode.position ?? Offset.zero,
            degree: degreeById[graphNode.node.id] ?? 0,
          ),
        )
        .toList();

    if (states.every((node) => node.position == Offset.zero)) {
      final double radius = math.max(260, states.length * 26).toDouble();
      for (int index = 0; index < states.length; index++) {
        final double angle = (2 * math.pi * index) / math.max(states.length, 1);
        states[index] = states[index].copyWith(
          position: Offset(math.cos(angle) * radius, math.sin(angle) * radius),
        );
      }
    }

    return states;
  }

  List<NodeGraphNodeState> get visibleNodes => graphNodes
      .where(
        (node) =>
            selectedTypeIds.contains(node.node.nodeTypeId) &&
            node.degree >= minimumDegree.value,
      )
      .toList();

  List<NodeLinkModel> get visibleLinks {
    final Set<int> ids = visibleNodes.map((item) => item.node.id).toSet();
    return graphLinks
        .where((link) =>
            ids.contains(link.sourceNodeId) && ids.contains(link.targetNodeId))
        .toList();
  }

  Set<int> get neighborNodeIds {
    final int? selected = selectedNodeId.value;
    if (selected == null) return const <int>{};
    final Set<int> ids = <int>{selected};
    for (final link in visibleLinks) {
      if (link.sourceNodeId == selected) ids.add(link.targetNodeId);
      if (link.targetNodeId == selected) ids.add(link.sourceNodeId);
    }
    return ids;
  }

  void toggleType(int nodeTypeId, bool enabled) {
    if (enabled) {
      selectedTypeIds.add(nodeTypeId);
    } else {
      selectedTypeIds.remove(nodeTypeId);
    }
    _ensureSelectedNodeVisible();
  }

  void updateMinimumDegree(double value) {
    minimumDegree.value = value.round();
    _ensureSelectedNodeVisible();
  }

  void selectNode(int? nodeId) {
    if (selectedNodeId.value == nodeId) {
      selectedNodeId.value = null;
      return;
    }
    selectedNodeId.value = nodeId;
  }

  void updateNodePosition(int nodeId, Offset position) {
    final int index = graphNodes.indexWhere((item) => item.node.id == nodeId);
    if (index == -1) return;
    graphNodes[index] = graphNodes[index].copyWith(position: position);
    graphNodes.refresh();
  }

  void _ensureSelectedNodeVisible() {
    final int? selected = selectedNodeId.value;
    if (selected == null) return;
    final bool stillVisible =
        visibleNodes.any((node) => node.node.id == selected);
    if (!stillVisible) selectedNodeId.value = null;
  }
}

class NodeGraphNodeState {
  NodeGraphNodeState({
    required this.node,
    required this.position,
    required this.degree,
  });

  final NodeModel node;
  final Offset position;
  final int degree;

  double get radius => 34 + math.min(degree, 10) * 4.0;

  NodeGraphNodeState copyWith({
    NodeModel? node,
    Offset? position,
    int? degree,
  }) {
    return NodeGraphNodeState(
      node: node ?? this.node,
      position: position ?? this.position,
      degree: degree ?? this.degree,
    );
  }
}
