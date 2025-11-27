import 'package:unisinos_usp_app/models/trail_feedback_model.dart';

class ReportTrailStats {
  final int trailId;
  final String trailName;
  final int studentCount;
  final int conclusionCount;
  final double averageScore;
  final int averageConclusionTimeInDays;
  final List<TrailFeedback> feedbacks;

  ReportTrailStats({
    required this.trailId,
    required this.trailName,
    required this.studentCount,
    required this.conclusionCount,
    required this.averageScore,
    required this.averageConclusionTimeInDays,
    required this.feedbacks,
  });

  factory ReportTrailStats.fromJson(Map<String, dynamic> json) {
    final int students = json['student_count'] ?? 0;
    final int conclusions = json['conclusion_count'] ?? 0;

    return ReportTrailStats(
      trailId: json['trail_id'] ?? 0,
      trailName: json['trail_name'] ?? 'Trilha Sem Nome',
      studentCount: students,
      conclusionCount: conclusions,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      averageConclusionTimeInDays: json['average_conclusion_time_in_days'] ?? 0,
      feedbacks: TrailFeedback.fromJsonArray(json['feedbacks'] as List? ?? []),
    );
  }

  double get conclusionRate => studentCount == 0 ? 0.0 : (conclusionCount / studentCount);

  static List<ReportTrailStats> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((e) => ReportTrailStats.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'trail_id': trailId,
      'trail_name': trailName,
      'student_count': studentCount,
      'conclusion_count': conclusionCount,
      'average_score': averageScore,
      'average_conclusion_time_in_days': averageConclusionTimeInDays,
      'feedbacks': feedbacks.map((f) => f.toJson()).toList(),
    };
  }
}
