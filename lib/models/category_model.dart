class CategoryType {
  static const String living = 'Pista Viva';
  static const String data = 'Pista de Dados';
  static const String geographic = 'Pista Georreferenciada';

  static const List<String> values = <String>[
    living,
    data,
    geographic,
  ];

  static String normalize(String? value) {
    final String normalized = value?.trim() ?? '';
    if (normalized == 'Pista Georreferenciada') {
      return geographic;
    }
    return normalized;
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String type;
  final String colorHex;
  final String? iconCode;
  final String? description;
  final String metadataTags;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.colorHex,
    this.iconCode,
    this.description,
    required this.metadataTags,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] ?? '',
      type: CategoryType.normalize(json['type']?.toString()),
      colorHex: json['color_hex'] ?? '',
      iconCode: json['icon_code'],
      description: json['description'],
      metadataTags: json['metadata_tags'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'color_hex': colorHex,
      'icon_code': iconCode,
      'description': description,
      'metadata_tags': metadataTags,
    };
  }

  static List<CategoryModel> fromJsonArray(List<dynamic> json) {
    return json.map((item) => CategoryModel.fromJson(item)).toList();
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? type,
    String? colorHex,
    String? iconCode,
    String? description,
    String? metadataTags,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colorHex: colorHex ?? this.colorHex,
      iconCode: iconCode ?? this.iconCode,
      description: description ?? this.description,
      metadataTags: metadataTags ?? this.metadataTags,
    );
  }
}
