import 'package:unisinos_usp_app/models/file_cover_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';

class CourseModel {
  final int id;
  final String name;
  final String description;
  final bool status;
  final int completionTimeLimit;
  final int coverImageFileId;
  final int trailId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> deletedAt;
  final CoverImageFileModel coverImageFile;
  final TrailModel trail;

  CourseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.completionTimeLimit,
    required this.coverImageFileId,
    required this.trailId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.coverImageFile,
    required this.trail,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      status: json['status'] as bool,
      completionTimeLimit: json['completion_time_limit'] as int,
      coverImageFileId: json['cover_image_file_id'] as int,
      trailId: json['trail_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: {
        'time': json['deleted_at']['time'],
        'valid': json['deleted_at']['valid'] as bool,
      },
      coverImageFile: CoverImageFileModel.fromJson(json['cover_image_file']),
      trail: TrailModel.fromJson(json['trail']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'completion_time_limit': completionTimeLimit,
      'cover_image_file_id': coverImageFileId,
      'trail_id': trailId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt,
      'cover_image_file': coverImageFile.toJson(),
      'trail': trail.toJson(),
    };
  }

  static List<CourseModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => CourseModel.fromJson(json)).toList();
  }
}
