class CoverImageFileModel {
  final int id;
  final String name;
  final String extension;
  final String path;
  final String publicUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  CoverImageFileModel({
    required this.id,
    required this.name,
    required this.extension,
    required this.path,
    required this.publicUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CoverImageFileModel.fromJson(Map<String, dynamic> json) {
    return CoverImageFileModel(
      id: json['id'] as int,
      name: json['name'] as String,
      extension: json['extension'] as String,
      path: json['path'] as String,
      publicUrl: json['public_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'extension': extension,
      'path': path,
      'public_url': publicUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
