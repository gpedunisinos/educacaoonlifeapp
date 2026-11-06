import 'dart:convert';

import 'package:unisinos_usp_app/models/connection_type_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';

class ClueConnectionModel {
  int id;
  int sourceClueId;
  int targetClueId;
  int connectionTypeId;
  int strength;
  String? evidence;
  LivingClueModel? sourceClue;
  LivingClueModel? targetClue;
  ConnectionTypeModel? connectionType;
  DateTime? createdAt;
  DateTime? updatedAt;

  ClueConnectionModel({
    required this.id,
    required this.sourceClueId,
    required this.targetClueId,
    required this.connectionTypeId,
    this.strength = 1,
    this.evidence,
    this.sourceClue,
    this.targetClue,
    this.connectionType,
    this.createdAt,
    this.updatedAt,
  });

  ClueConnectionModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        sourceClueId = json['source_clue_id'] is int
            ? json['source_clue_id']
            : int.parse(json['source_clue_id'].toString()),
        targetClueId = json['target_clue_id'] is int
            ? json['target_clue_id']
            : int.parse(json['target_clue_id'].toString()),
        connectionTypeId = json['connection_type_id'] is int
            ? json['connection_type_id']
            : int.parse(json['connection_type_id'].toString()),
        strength = json['strength'] == null
            ? 1
            : int.parse(json['strength'].toString()),
        evidence = json['evidence'],
        sourceClue = _parseLivingClue(json['source_clue']),
        targetClue = _parseLivingClue(json['target_clue']),
        connectionType = _parseConnectionType(json['connection_type']),
        createdAt = json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt = json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'source_clue_id': sourceClueId,
        'target_clue_id': targetClueId,
        'connection_type_id': connectionTypeId,
        'strength': strength,
        'evidence': evidence,
      };

  LivingClueModel? relatedClueFor(int clueId) {
    if (sourceClueId == clueId) return targetClue;
    if (targetClueId == clueId) return sourceClue;
    return null;
  }

  bool isOutgoingFrom(int clueId) => sourceClueId == clueId;

  static LivingClueModel? _parseLivingClue(value) {
    if (value is Map) {
      return LivingClueModel.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static ConnectionTypeModel? _parseConnectionType(value) {
    if (value is Map) {
      return ConnectionTypeModel.fromJson(Map<String, dynamic>.from(value));
    }
    return null;
  }

  static List<ClueConnectionModel> fromJsonArray(String str) {
    return List<ClueConnectionModel>.from(
      jsonDecode(str).map((map) => ClueConnectionModel.fromJson(map)),
    );
  }
}
