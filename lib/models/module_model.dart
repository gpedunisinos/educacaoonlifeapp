import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:widgets_spo/models/model_base.dart';

class ModuleModel extends ModelBase {
  final String name;
  final int? trailId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final TrailModel? trail;
  final List<ClassModel>? classes;

  ModuleModel({
    required super.id,
    required this.name,
    this.trailId,
    this.createdAt,
    this.updatedAt,
    this.trail,
    this.classes,
  });

  factory ModuleModel.fromJson(Map<String, dynamic> json) {
    return ModuleModel(
      id: json['id'],
      name: json['name'],
      trailId: json['trail_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      trail: json['trail'] != null ? TrailModel.fromJson(json['trail']) : null,
      classes: json['classes'] != null ? ClassModel.fromJsonArray(json['classes']) : null,
    );
  }

  static List<ModuleModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => ModuleModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'trail_id': trailId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'trail': trail?.toJson(),
      'classes': classes?.map((e) => e.toJson()).toList(),
    };
  }
}
