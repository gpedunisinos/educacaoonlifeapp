import 'package:unisinos_usp_app/models/sensor_reading_model.dart';
import 'package:unisinos_usp_app/models/file_model.dart';
import 'dart:convert';

import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/environmental_context_model.dart';

class LivingClueModel {
  List<FileModel> files;
  final List<SensorReadingModel> sensorReadings;
  int id;
  String name;
  int categoryId;
  String? description;
  String? descriptionDelta;
  double? latitude;
  double? longitude;
  String? imageUrl;
  Map<String, dynamic>? metadata;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  CategoryModel? category;
  EnvironmentalContextModel? environmentalContext;

  LivingClueModel({
    required this.id,
    this.files = const [],
    this.sensorReadings = const [],
    required this.name,
    required this.categoryId,
    this.latitude,
    this.longitude,
    this.description,
    this.descriptionDelta,
    this.imageUrl,
    this.metadata,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.environmentalContext,
  });

  LivingClueModel.fromJson(Map<String, dynamic> json)
    : sensorReadings =
          (json['sensor_readings'] is List
                  ? json['sensor_readings'] as List
                  : const [])
              .whereType<Map>()
              .map(
                (e) =>
                    SensorReadingModel.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList(),
      files = (json['files'] as List? ?? [])
          .map((e) => FileModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      id = json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name = json['name'] ?? '',
      categoryId = _parseCategoryId(json),
      description = json['description'],
      descriptionDelta = json['description_delta'],
      latitude = double.tryParse(json['latitude']?.toString() ?? ''),
      longitude = double.tryParse(json['longitude']?.toString() ?? ''),
      imageUrl = json['image_url'],
      metadata = json['metadata'],
      isActive = json['is_active'] == null ? true : json['is_active'] == true,
      createdAt = json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt = json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      category = _parseCategory(json),
      environmentalContext = _parseEnvironmentalContext(json);

  bool get hasLocation => latitude != null && longitude != null;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
    'description': description,
    'description_delta': descriptionDelta,
    'description_format_version': 1,
    'remove_location': !hasLocation,
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

  static CategoryModel? _parseCategory(Map<String, dynamic> json) {
    final categoryJson = json['category'] ?? json['Category'];
    if (categoryJson is Map<String, dynamic>) {
      return CategoryModel.fromJson(categoryJson);
    }
    if (categoryJson is Map) {
      return CategoryModel.fromJson(Map<String, dynamic>.from(categoryJson));
    }
    return null;
  }

  static int _parseCategoryId(Map<String, dynamic> json) {
    final rawId = json['category_id'];
    if (rawId is int) return rawId;

    final parsedId = int.tryParse(rawId?.toString() ?? '');
    if (parsedId != null) return parsedId;

    final category = _parseCategory(json);
    return category?.id ?? 0;
  }

  static EnvironmentalContextModel? _parseEnvironmentalContext(
    Map<String, dynamic> json,
  ) {
    final value = json['environmental_context'];
    if (value is Map) {
      return EnvironmentalContextModel.fromJson(
        Map<String, dynamic>.from(value),
      );
    }
    return null;
  }
}
