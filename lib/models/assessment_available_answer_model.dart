import 'package:widgets_spo/models.dart';

class AssessmentAvailableAnswersModel extends ModelBase {
  final int questionId;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? localId;

  AssessmentAvailableAnswersModel({
    required super.id,
    required this.questionId,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.localId,
  });

  factory AssessmentAvailableAnswersModel.fromJson(Map<String, dynamic> json) {
    return AssessmentAvailableAnswersModel(
      id: json['id'],
      questionId: json['question_id'],
      title: json['title'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  static List<AssessmentAvailableAnswersModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => AssessmentAvailableAnswersModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'title': title,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AssessmentAvailableAnswersModel copyWith({
    int? id,
    int? questionId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? localId,
  }) {
    return AssessmentAvailableAnswersModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      localId: localId ?? this.localId,
    );
  }
}
