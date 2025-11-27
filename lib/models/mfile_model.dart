import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:widgets_spo/models/mfile_base_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

class MFile extends MFileBase {
  final int? classId;
  final ClassModel? classModel;

  MFile({
    required super.id,
    required super.extension,
    super.path,
    super.publicUrl,
    super.base64,
    super.bytes,
    super.size,
    super.readStream,
    super.name,
    super.createdAt,
    super.updatedAt,
    super.isDeleted = false,
    this.classId,
    this.classModel,
  });

  factory MFile.fromJson(Map<String, dynamic> json) {
    return MFile(
      id: json['id'],
      extension: json['extension'],
      path: json['path'],
      publicUrl: json['public_url'],
      name: json['name'],
      createdAt: DateTime.tryParse(json['created_at'].toString()),
      updatedAt: DateTime.tryParse(json['updated_at'].toString()),
      isDeleted: json['is_deleted'] ?? false,
      classId: json['class_id'],
      classModel: json['class'] != null ? ClassModel.fromJson(json['class']) : null,
    );
  }

  static List<MFile> fromJsonArray(List<dynamic> jsonArray) {
    return jsonArray.map((json) => MFile.fromJson(json)).toList();
  }

  factory MFile.fromBase(MFileBase base, {int? classId, ClassModel? classModel}) {
    return MFile(
      id: base.id,
      extension: base.extension,
      path: base.path,
      publicUrl: base.publicUrl,
      base64: base.base64,
      bytes: base.bytes,
      size: base.size,
      readStream: base.readStream,
      name: base.name,
      createdAt: base.createdAt,
      updatedAt: base.updatedAt,
      isDeleted: base.isDeleted,
      classId: classId,
      classModel: classModel,
    );
  }

  MFileBase toBase() {
    return MFileBase(
      id: id,
      extension: extension,
      path: path,
      publicUrl: publicUrl,
      base64: base64,
      bytes: bytes,
      size: size,
      readStream: readStream,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'class_id': classId,
      'class': classModel?.toJson(),
    });
    return json;
  }

  MFile copyWith({
    int? id,
    String? extension,
    String? path,
    String? publicUrl,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    int? classId,
    ClassModel? classModel,
  }) {
    return MFile(
      id: id ?? this.id,
      extension: extension ?? this.extension,
      path: path ?? this.path,
      publicUrl: publicUrl ?? this.publicUrl,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      classId: classId ?? this.classId,
      classModel: classModel ?? this.classModel,
    );
  }
}
