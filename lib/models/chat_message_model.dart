class ChatMessageModel {
  ChatMessageModel({
    this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.fileUrl,
    this.role,
  });

  final int? id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? fileUrl;
  final String? role;

  factory ChatMessageModel.fromHistoryJson(Map<String, dynamic> json) {
    final String role = json['role']?.toString().toLowerCase() ?? 'assistant';
    return ChatMessageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      text: json['message']?.toString() ?? '',
      isUser: role == 'user',
      timestamp: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      role: role,
    );
  }
}
