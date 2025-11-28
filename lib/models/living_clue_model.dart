import 'dart:convert';

import 'package:unisinos_usp_app/models/category_model.dart';

class LivingClueModel {
  int id;
  String name;
  int categoryId;
  String? description;
  double latitude;
  double longitude;
  String? imageUrl;
  Map<String, dynamic>? metadata;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  CategoryModel? category;

  LivingClueModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.latitude,
    required this.longitude,
    this.description,
    this.imageUrl,
    this.metadata,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  LivingClueModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        name = json['name'] ?? '',
        categoryId = json['category_id'] is int
            ? json['category_id']
            : int.parse(json['category_id'].toString()),
        description = json['description'],
        latitude = double.parse(json['latitude'].toString()),
        longitude = double.parse(json['longitude'].toString()),
        imageUrl = json['image_url'],
        metadata = json['metadata'],
        isActive = json['is_active'] == null ? true : json['is_active'] == true,
        createdAt = json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
        category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category_id': categoryId,
        'description': description,
        'latitude': latitude,
        'longitude': longitude,
        'image_url': imageUrl,
        'metadata': metadata,
        'is_active': isActive,
        // categoria é enviada apenas por id
      };

  static List<LivingClueModel> fromJsonArray(String str) {
    return List<LivingClueModel>.from(
      jsonDecode(str).map((map) => LivingClueModel.fromJson(map)),
    );
  }
}
