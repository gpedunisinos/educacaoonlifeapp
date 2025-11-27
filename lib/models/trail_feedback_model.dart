import 'package:widgets_spo/models/model_base.dart';

class TrailFeedback extends ModelBase {
  final String content;
  final int trailId;
  final int userId;
  final String createdAt;

  TrailFeedback({
    required super.id,
    required this.content,
    required this.trailId,
    required this.userId,
    required this.createdAt,
  });

  factory TrailFeedback.fromJson(Map<String, dynamic> json) {
    return TrailFeedback(
      id: json['id'] ?? 0,
      content: json['content'] ?? 'Sem conteúdo',
      trailId: json['trail_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'trail_id': trailId,
      'user_id': userId,
      'created_at': createdAt,
    };
  }

  static List<TrailFeedback> fromJsonArray(List json) {
    return json.map((e) => TrailFeedback.fromJson(e)).toList();
  }
}
