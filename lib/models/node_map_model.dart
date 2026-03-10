import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/models/node_link_model.dart';
import 'package:unisinos_usp_app/models/node_model.dart';

class NodeMapModel {
  NodeMapModel({
    required this.nodes,
    required this.links,
  });

  final List<NodeGraphNode> nodes;
  final List<NodeLinkModel> links;

  factory NodeMapModel.fromResponseBody(String body) {
    final dynamic decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return NodeMapModel(nodes: const [], links: const []);
    }

    final List<NodeGraphNode> parsedNodes = (decoded['nodes'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(NodeGraphNode.fromJson)
        .toList();
    final List<NodeLinkModel> parsedLinks = (decoded['links'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(NodeLinkModel.fromJson)
        .toList();

    return NodeMapModel(
      nodes: _withFallbackPositions(parsedNodes),
      links: parsedLinks,
    );
  }

  static List<NodeGraphNode> _withFallbackPositions(List<NodeGraphNode> nodes) {
    if (nodes.isEmpty) return nodes;
    final bool hasMissingPosition = nodes.any((node) => node.position == null);
    if (!hasMissingPosition) return nodes;

    final double radius = math.max(220, nodes.length * 24).toDouble();
    for (int index = 0; index < nodes.length; index++) {
      if (nodes[index].position != null) continue;
      final double angle = (2 * math.pi * index) / nodes.length;
      nodes[index] = nodes[index].copyWith(
        position: Offset(
          math.cos(angle) * radius,
          math.sin(angle) * radius,
        ),
      );
    }
    return nodes;
  }
}

class NodeGraphNode {
  NodeGraphNode({
    required this.node,
    this.position,
  });

  final NodeModel node;
  final Offset? position;

  factory NodeGraphNode.fromJson(Map<String, dynamic> json) {
    return NodeGraphNode(
      node: NodeModel.fromJson(json),
      position: _parseOffset(json),
    );
  }

  NodeGraphNode copyWith({
    NodeModel? node,
    Offset? position,
  }) {
    return NodeGraphNode(
      node: node ?? this.node,
      position: position ?? this.position,
    );
  }

  static Offset? _parseOffset(Map<String, dynamic> json) {
    final dynamic xRaw = json['x'] ?? json['position_x'] ?? json['px'];
    final dynamic yRaw = json['y'] ?? json['position_y'] ?? json['py'];
    final double? x = _parseDouble(xRaw);
    final double? y = _parseDouble(yRaw);
    if (x == null || y == null) return null;
    return Offset(x, y);
  }

  static double? _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }
}
