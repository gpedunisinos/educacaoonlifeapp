import 'dart:convert';

class ChatTemplateFileModel {
  ChatTemplateFileModel({
    this.id,
    required this.name,
    required this.mimeType,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String mimeType;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ChatTemplateFileModel.fromJson(Map<String, dynamic> json) {
    return ChatTemplateFileModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name']?.toString() ?? '',
      mimeType: json['mime_type']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'mime_type': mimeType,
        'content': content,
      };
}

class ChatTemplateModel {
  ChatTemplateModel({
    required this.id,
    required this.name,
    this.description,
    this.systemInstruction,
    this.files = const <ChatTemplateFileModel>[],
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String? description;
  String? systemInstruction;
  List<ChatTemplateFileModel> files;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ChatTemplateModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawFiles = (json['files'] is List<dynamic>)
        ? json['files'] as List<dynamic>
        : ((json['chat_template_files'] is List<dynamic>) ? json['chat_template_files'] as List<dynamic> : const []);

    return ChatTemplateModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      systemInstruction: json['system_instruction']?.toString(),
      files: rawFiles
          .whereType<Map<String, dynamic>>()
          .map(ChatTemplateFileModel.fromJson)
          .toList(),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'system_instruction': systemInstruction,
        'files': files.map((file) => file.toJson()).toList(),
      };

  static List<ChatTemplateModel> fromResponseBody(String body) {
    final dynamic decoded = jsonDecode(body);
    if (decoded is List<dynamic>) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ChatTemplateModel.fromJson)
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      final dynamic collection = decoded['chat_templates'] ?? decoded['data'] ?? decoded['items'];
      if (collection is List<dynamic>) {
        return collection
            .whereType<Map<String, dynamic>>()
            .map(ChatTemplateModel.fromJson)
            .toList();
      }
    }

    return const <ChatTemplateModel>[];
  }
}
