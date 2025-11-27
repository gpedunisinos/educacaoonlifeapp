import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';

class ClassCompletion {
  final int? id;
  final int classId;
  final int? assessmentId;
  final int userId;
  final ClassModel classModel;
  final AssessmentModel? assessment;
  final UserModel user;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final bool deleted;

  ClassCompletion({
    this.id,
    required this.classId,
    this.assessmentId,
    required this.userId,
    required this.classModel,
    this.assessment,
    required this.user,
    DateTime? createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deleted = false,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'assessment_id': assessmentId,
      'user_id': userId,
      'class': classModel.toJson(),
      'assessment': assessment?.toJson(),
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'deleted': deleted,
    };
  }
}
