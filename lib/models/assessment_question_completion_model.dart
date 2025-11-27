import 'package:unisinos_usp_app/models/assessment_available_answer_model.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_model.dart';

class AssessmentQuestionCompletionModel {
  final int id;
  final int? questionId;
  final int? answerId;
  final String? answerText;
  final bool? isCorrect;
  final int? assessmentCompletionId;
  final int? assessmentCorrectionId;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  final AssessmentAvailableAnswersModel? assessmentAvailableAnswer;
  final AssessmentCompletionModel? assessmentCompletion;
  final AssessmentQuestionModel? assessmentQuestion;

  AssessmentQuestionCompletionModel({
    required this.id,
    this.questionId,
    this.answerId,
    this.answerText,
    this.isCorrect,
    this.assessmentCompletionId,
    this.assessmentCorrectionId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.assessmentAvailableAnswer,
    this.assessmentCompletion,
    this.assessmentQuestion,
  });

  factory AssessmentQuestionCompletionModel.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestionCompletionModel(
      id: json['id'],
      questionId: json['question_id'],
      answerId: json['answer_id'],
      answerText: json['answer_text'],
      isCorrect: json['is_correct'],
      assessmentCompletionId: json['assessment_completion_id'],
      assessmentCorrectionId: json['assessment_correction_id'],
      userId: json['user_id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.tryParse(json['deleted_at']) : null,
      assessmentAvailableAnswer:
          json['assessment_available_answer'] != null ? AssessmentAvailableAnswersModel.fromJson(json['assessment_available_answer']) : null,
      assessmentCompletion: json['assessment_completion'] != null ? AssessmentCompletionModel.fromJson(json['assessment_completion']) : null,
      assessmentQuestion: json['assessment_question'] != null ? AssessmentQuestionModel.fromJson(json['assessment_question']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'answer_id': answerId,
      'answer_text': answerText,
      'is_correct': isCorrect,
      'assessment_completion_id': assessmentCompletionId,
      'assessment_correction_id': assessmentCorrectionId,
      'user_id': userId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'assessment_available_answer': assessmentAvailableAnswer?.toJson(),
      'assessment_completion': assessmentCompletion?.toJson(),
      'assessment_question': assessmentQuestion?.toJson(),
    };
  }

  static List<AssessmentQuestionCompletionModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => AssessmentQuestionCompletionModel.fromJson(json)).toList();
  }
}
