import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:widgets_spo/models/model_base.dart';

class ClassModel extends ModelBase {
  final String name;
  final String description;
  final int order;
  final String? contentType;
  final String? textContent;
  final int? fileId;
  final int? moduleId;
  final TrailModel? trail;
  final int? trailId;
  final int? estimatedTime;
  final bool? hasAssessment;
  final bool? isCompleted;
  final AssessmentModel? assessment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  // final ModuleModel? module;
  final MFile? file;
  final List<MFile> files;
  final String? offlineVideoPath;

  ClassModel({
    required super.id,
    required this.name,
    required this.description,
    required this.order,
    this.contentType,
    this.textContent,
    this.fileId,
    this.moduleId,
    this.trail,
    this.trailId,
    this.estimatedTime,
    this.hasAssessment,
    this.isCompleted,
    this.assessment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    // this.module,
    this.file,
    this.files = const [],
    this.offlineVideoPath,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      order: json['order'],
      contentType: json['content_type'],
      textContent: json['text_content'],
      fileId: json['file_id'],
      moduleId: json['module_id'],
      trail: json['Trail'] != null ? TrailModel.fromJson(json['Trail']) : null,
      trailId: json['trail_id'],
      estimatedTime: json['estimated_time'],
      hasAssessment: json['has_assessment'],
      isCompleted: json['is_completed'],
      assessment: json['assessment'] != null && json['assessment'].isNotEmpty ? AssessmentModel.fromJson(json['assessment'][0]) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      // module: json['module'] != null ? ModuleModel.fromJson(json['module']) : null,
      file: json['file'] != null ? MFile.fromJson(json['file']) : null,
      files: json['files'] != null && (json['files'] as List).isNotEmpty ? MFile.fromJsonArray(json['files']) : [],
      offlineVideoPath: json['offlineVideoPath'],
    );
  }

  static List<ClassModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => ClassModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'order': order,
      'content_type': contentType,
      'text_content': textContent,
      'file_id': fileId,
      'module_id': moduleId,
      'trail': trail,
      'trail_id': trailId,
      'estimated_time': estimatedTime,
      'has_assessment': hasAssessment,
      'is_completed': isCompleted,
      'assessment': assessment != null ? [assessment!.toJson()] : [],
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      // 'module': module?.toJson(),
      'file': file?.toJson(),
      'files': files?.map((e) => e.toJson()).toList(),
      'offlineVideoPath': offlineVideoPath,
    };
  }

  ClassModel copyWith({
    int? id,
    String? name,
    String? description,
    int? order,
    String? contentType,
    String? textContent,
    int? fileId,
    // int? moduleId,
    TrailModel? trail,
    int? trailId,
    int? estimatedTime,
    bool? hasAssessment,
    bool? isCompleted,
    AssessmentModel? assessment,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    MFile? file,
    List<MFile>? files,
    String? offlineVideoPath,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      order: order ?? this.order,
      contentType: contentType ?? this.contentType,
      textContent: textContent ?? this.textContent,
      fileId: fileId ?? this.fileId,
      // moduleId: moduleId ?? this.moduleId,
      trail: trail ?? this.trail,
      trailId: trailId ?? this.trailId,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      hasAssessment: hasAssessment ?? this.hasAssessment,
      isCompleted: isCompleted ?? this.isCompleted,
      assessment: assessment ?? this.assessment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      file: file ?? this.file,
      files: files ?? this.files,
      offlineVideoPath: offlineVideoPath ?? this.offlineVideoPath,
    );
  }
}
