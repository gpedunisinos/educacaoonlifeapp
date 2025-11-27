import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_completion_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:widgets_spo/models.dart';

class AssessmentCorrectionModel extends ModelBase {
  final int assessmentCompletionId;
  final String? correctionNotes;
  final List<AssessmentQuestionCompletionModel>? corrections;
  final DateTime? createdAt;
  final int teacherId;
  final DateTime? updatedAt;
  final AssessmentCompletionModel? assessmentCompletion;
  final UserModel? teacher;

  AssessmentCorrectionModel({
    required super.id,
    required this.assessmentCompletionId,
    this.correctionNotes,
    this.corrections,
    this.createdAt,
    required this.teacherId,
    this.updatedAt,
    this.assessmentCompletion,
    this.teacher,
  });

  factory AssessmentCorrectionModel.fromJson(Map<String, dynamic> json) {
    return AssessmentCorrectionModel(
      id: json['id'],
      assessmentCompletionId: json['assessment_completion_id'],
      correctionNotes: json['correction_notes'],
      corrections: json['corrections'] is List ? List<AssessmentQuestionCompletionModel>.from(json['corrections']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      teacherId: json['teacher_id'],
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      assessmentCompletion: json['assessment_completion'] != null ? AssessmentCompletionModel.fromJson(json['assessment_completion']) : null,
      teacher: json['teacher'] != null ? UserModel.fromJson(json['teacher']) : null,
    );
  }

  static List<AssessmentCorrectionModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => AssessmentCorrectionModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assessment_completion_id': assessmentCompletionId,
      'correction_notes': correctionNotes,
      'corrections': corrections,
      'created_at': createdAt?.toIso8601String(),
      'teacher_id': teacherId,
      'updated_at': updatedAt?.toIso8601String(),
      'assessment_completion': assessmentCompletion?.toJson(),
      'teacher': teacher?.toJson(),
    };
  }

  AssessmentCorrectionModel copyWith({
    int? id,
    int? assessmentCompletionId,
    String? correctionNotes,
    List<AssessmentQuestionCompletionModel>? corrections,
    DateTime? createdAt,
    int? teacherId,
    DateTime? updatedAt,
    AssessmentCompletionModel? assessmentCompletion,
    UserModel? teacher,
  }) {
    return AssessmentCorrectionModel(
      id: id ?? this.id,
      assessmentCompletionId: assessmentCompletionId ?? this.assessmentCompletionId,
      correctionNotes: correctionNotes ?? this.correctionNotes,
      corrections: corrections ?? this.corrections,
      createdAt: createdAt ?? this.createdAt,
      teacherId: teacherId ?? this.teacherId,
      updatedAt: updatedAt ?? this.updatedAt,
      assessmentCompletion: assessmentCompletion ?? this.assessmentCompletion,
      teacher: teacher ?? this.teacher,
    );
  }
}
