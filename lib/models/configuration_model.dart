import 'package:widgets_spo/models/model_base.dart';

class ConfigurationModel extends ModelBase {
  final String? name;
  final String? tag;
  final String? value;
  final String? createdAt;
  final String? updatedAt;

  ConfigurationModel({
    required super.id,
    this.name,
    this.tag,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory ConfigurationModel.fromJson(Map<String, dynamic> json) {
    return ConfigurationModel(
      id: json['id'] ?? 0,
      name: json['name'],
      tag: json['tag'],
      value: json['value']?.toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tag': tag,
      'value': value,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<ConfigurationModel> fromJsonArray(List json) {
    return json.map((e) => ConfigurationModel.fromJson(e)).toList();
  }

  ConfigurationModel copyWith({
    int? id,
    String? name,
    String? tag,
    String? value,
    String? createdAt,
    String? updatedAt,
  }) {
    return ConfigurationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      value: value ?? this.value,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
