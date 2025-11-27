class CategoryModel {
  final int id;
  final String name;
  final String colorHex;
  final String? iconCode;
  final String? description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.colorHex,
    this.iconCode,
    this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      name: json['name'] ?? '',
      colorHex: json['color_hex'] ?? '',
      iconCode: json['icon_code'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'color_hex': colorHex,
      'icon_code': iconCode,
      'description': description,
    };
  }

  static List<CategoryModel> fromJsonArray(List<dynamic> json) {
    return json.map((item) => CategoryModel.fromJson(item)).toList();
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    String? colorHex,
    String? iconCode,
    String? description,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      colorHex: colorHex ?? this.colorHex,
      iconCode: iconCode ?? this.iconCode,
      description: description ?? this.description,
    );
  }
}
