class ReportTeacherScore {
  final double averageScore;
  final int correctionCount;
  final int period;
  final List<double> scoreList;

  ReportTeacherScore({
    required this.averageScore,
    required this.correctionCount,
    required this.period,
    required this.scoreList,
  });

  factory ReportTeacherScore.fromJson(Map<String, dynamic> json) {
    return ReportTeacherScore(
      averageScore: (json['average_score'] ?? 0).toDouble(),
      correctionCount: json['correction_count'] ?? 0,
      period: json['period'] ?? 0,
      scoreList: (json['score_list'] as List<dynamic>? ?? []).map((e) => (e as num).toDouble()).toList(),
    );
  }

  static List<ReportTeacherScore> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((e) => ReportTeacherScore.fromJson(e)).toList();
  }
}
