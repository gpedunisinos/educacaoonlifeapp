import 'package:widgets_spo/models.dart';

class NotificationModel extends ModelBase {
  final String title;
  final String content;
  final DateTime createdAt;

  NotificationModel({
    required super.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  @override
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'] ?? '',
      content: json['content'] ?? json['payload'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static List<NotificationModel> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => NotificationModel.fromJson(json)).toList();
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
