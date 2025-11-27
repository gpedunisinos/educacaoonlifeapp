import 'package:widgets_spo/models/model_base.dart';

class ClassCompletionModel extends ModelBase {
  final int? assessmentId;
  final int classId;
  final int userId;

  ClassCompletionModel({
    required super.id,
    this.assessmentId,
    required this.classId,
    required this.userId,
  });

  @override
  Map<String, dynamic> toJson() => {
        'id': super.id,
        'assessment_id': assessmentId,
        'class_id': classId,
        'user_id': userId,
      };

  factory ClassCompletionModel.fromJson(Map<String, dynamic> json) {
    return ClassCompletionModel(
      id: json['id'],
      assessmentId: json['assessment_id'],
      classId: json['class_id'] ?? 0,
      userId: json['user_id'] ?? 0,
    );
  }

  static List<ClassCompletionModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => ClassCompletionModel.fromJson(json)).toList();
  }
}
