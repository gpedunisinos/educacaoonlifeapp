import 'package:unisinos_usp_app/models/assessment_available_answer_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

enum QuestionType {
  subjective(1, 'Subjetiva'),
  objective(2, 'Objetiva');

  final int value;
  final String description;

  const QuestionType(this.value, this.description);

  static QuestionType fromValue(int value) {
    return QuestionType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => QuestionType.subjective,
    );
  }
}

class AssessmentQuestionModel extends ModelBase {
  final String question;
  final QuestionType type;
  final int? assessmentId;
  final int points;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final AssessmentModel? assessment;
  final List<AssessmentAvailableAnswersModel>? availableAnswers;
  final String? localId;

  AssessmentQuestionModel({
    required super.id,
    required this.question,
    required this.type,
    required this.points,
    this.assessmentId,
    this.createdAt,
    this.updatedAt,
    this.assessment,
    this.availableAnswers,
    this.localId,
  });

  factory AssessmentQuestionModel.fromJson(Map<String, dynamic> json) {
    return AssessmentQuestionModel(
      id: json['id'],
      question: json['question'],
      type: QuestionType.fromValue(json['type']),
      points: json['points'] ?? 0,
      assessmentId: json['assessment_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      assessment: json['assessment'] != null ? AssessmentModel.fromJson(json['assessment']) : null,
      availableAnswers: json['available_answers'] != null ? AssessmentAvailableAnswersModel.fromJsonArray(json['available_answers']) : null,
    );
  }

  static List<AssessmentQuestionModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => AssessmentQuestionModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.value,
      'points': points,
      'assessment_id': assessmentId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'assessment': assessment?.toJson(),
      'avaliable_answers': availableAnswers?.map((e) => e.toJson()).toList(),
    };
  }

  AssessmentQuestionModel copyWith({
    int? id,
    String? question,
    QuestionType? type,
    int? assessmentId,
    int? points,
    DateTime? createdAt,
    DateTime? updatedAt,
    AssessmentModel? assessment,
    List<AssessmentAvailableAnswersModel>? availableAnswers,
    String? localId,
  }) {
    return AssessmentQuestionModel(
      id: id ?? this.id,
      question: question ?? this.question,
      type: type ?? this.type,
      assessmentId: assessmentId ?? this.assessmentId,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      assessment: assessment ?? this.assessment,
      availableAnswers: availableAnswers ?? this.availableAnswers,
      localId: localId ?? this.localId,
    );
  }
}
