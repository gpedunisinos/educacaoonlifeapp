import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:widgets_spo/models/mfile_base_model.dart';
import 'package:widgets_spo/models/model_base.dart';

enum AssessmentCompletionStatusEnum {
  waitingCorrection(10, 'Aguardando correção'),
  approved(20, 'Aprovado'),
  repproved(30, 'Reprovado');

  final int value;
  final String description;

  const AssessmentCompletionStatusEnum(this.value, this.description);

  static AssessmentCompletionStatusEnum? fromValue(int? value) {
    if (value == null) return null;
    return AssessmentCompletionStatusEnum.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AssessmentCompletionStatusEnum.waitingCorrection,
    );
  }
}

class AssessmentCompletionModel extends ModelBase {
  final AssessmentModel? assessment;
  final int? assessmentId;
  final double? score;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<MFileBase>? files;
  final UserModel? user;
  final int? userId;
  final AssessmentCompletionStatusEnum? status;

  AssessmentCompletionModel({
    required super.id,
    this.assessment,
    this.assessmentId,
    this.score,
    this.createdAt,
    this.updatedAt,
    this.files,
    this.user,
    this.userId,
    this.status,
  });

  factory AssessmentCompletionModel.fromJson(Map<String, dynamic> json) {
    return AssessmentCompletionModel(
      id: json['id'],
      assessment: json['assessment'] != null ? AssessmentModel.fromJson(json['assessment']) : null,
      assessmentId: json['assessment_id'],
      score: json['score'] != null && json['score'] > 0 ? (json['score'] as num) / 10.0 : 0.0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      files: json['file'] != null ? (json['file'] as List).map((e) => MFileBase.fromJson(e)).toList() : [],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      userId: json['user_id'],
      status: AssessmentCompletionStatusEnum.fromValue(json['status']),
    );
  }

  factory AssessmentCompletionModel.fromAssessment(
    AssessmentModel assessment, {
    required int userId,
    List<MFileBase>? files,
  }) {
    return AssessmentCompletionModel(
      id: 0,
      assessmentId: assessment.id,
      userId: userId,
      files: files,
      status: AssessmentCompletionStatusEnum.waitingCorrection,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment': assessment?.toJson(),
      'assessment_id': assessmentId,
      'score': score != null ? (score! * 10).toInt() : 0,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'file': files?.map((e) => e.toJson()).toList(),
      'user': user?.toJson(),
      'user_id': userId,
      'status': status?.value,
    };
  }

  static List<AssessmentCompletionModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => AssessmentCompletionModel.fromJson(json)).toList();
  }

  AssessmentCompletionModel copyWith({
    int? id,
    AssessmentModel? assessment,
    int? assessmentId,
    double? score,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MFile>? files,
    UserModel? user,
    int? userId,
    AssessmentCompletionStatusEnum? status,
  }) {
    return AssessmentCompletionModel(
      id: id ?? this.id,
      assessment: assessment ?? this.assessment,
      assessmentId: assessmentId ?? this.assessmentId,
      score: score ?? this.score,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      files: files ?? this.files,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }
}
