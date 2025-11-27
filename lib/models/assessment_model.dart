import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/models.dart';

enum AssessmentTypeEnum {
  subjective(1, 'Subjetiva'),
  practical(2, 'Prática'),
  mixed(3, 'Mista'),
  objective(4, 'Objetiva');

  final int value;
  final String description;

  const AssessmentTypeEnum(this.value, this.description);

  static AssessmentTypeEnum? fromValue(int value) {
    return AssessmentTypeEnum.values.firstWhereOrNull((e) => e.value == value);
  }
}

class AssessmentModel extends ModelBase {
  final String name;
  final String description;
  final int? classId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ClassModel? classModel;
  final List<AssessmentQuestionModel>? questions;
  final int? limitExecutionTime;
  final AssessmentTypeEnum? type;

  AssessmentModel({
    required super.id,
    required this.name,
    required this.description,
    this.classId,
    this.createdAt,
    this.updatedAt,
    this.classModel,
    this.questions,
    this.limitExecutionTime,
    this.type,
  });

  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      classId: json['class_id'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      classModel: json['class'] != null ? ClassModel.fromJson(json['class']) : null,
      questions: json['questions'] != null ? AssessmentQuestionModel.fromJsonArray(json['questions']) : null,
      limitExecutionTime: json['limit_execution_time'],
      type: json['type'] != null ? AssessmentTypeEnum.fromValue(json['type']) : null,
    );
  }

  int get getExecutionTime {
    int totalMinutes = limitExecutionTime ?? 0;

    return totalMinutes;
  }

  static List<AssessmentModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => AssessmentModel.fromJson(json)).toList();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'class_id': classId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'class': classModel?.toJson(),
      'questions': questions?.map((e) => e.toJson()).toList(),
      'limit_execution_time': limitExecutionTime,
      'type': type?.value,
    };
  }

  AssessmentModel copyWith({
    int? id,
    String? name,
    String? description,
    int? classId,
    DateTime? createdAt,
    DateTime? updatedAt,
    ClassModel? classModel,
    List<AssessmentQuestionModel>? questions,
    int? limitExecutionTime,
    AssessmentTypeEnum? type,
  }) {
    return AssessmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      classModel: classModel ?? this.classModel,
      questions: questions ?? this.questions,
      limitExecutionTime: limitExecutionTime ?? this.limitExecutionTime,
      type: type ?? this.type,
    );
  }
}
