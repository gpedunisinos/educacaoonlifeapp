import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:widgets_spo/models.dart';

class CategoryModel extends ModelBase {
  final String? name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final List<TrailModel>? trails;

  CategoryModel({
    required super.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.trails,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      trails: json['trails'] != null ? TrailModel.fromJsonArray(json['trails']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'trails': trails?.map((e) => e.toJson()).toList(),
    };
  }

  static List<CategoryModel> fromJsonArray(List json) {
    return json.map((e) => CategoryModel.fromJson(e)).toList();
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
