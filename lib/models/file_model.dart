import 'dart:convert';
import 'dart:typed_data';

import 'package:widgets_spo/models/mfile_base_model.dart';

class FileModel extends MFileBase {
  final int? livingClueId;
  final int? postId;

  FileModel({
    required super.id,
    required super.extension,
    super.path,
    super.publicUrl,
    super.name,
    super.createdAt,
    super.updatedAt,
    super.base64,
    super.bytes,
    super.readStream,
    super.size,
    super.isDeleted = false,
    this.livingClueId,
    this.postId,
  });

  factory FileModel.fromJson(Map<String, dynamic> json) {
    Uint8List? decodedBytes;
    if (json['bytes'] != null) {
      decodedBytes = json['bytes'] is String
          ? base64Decode(json['bytes'])
          : Uint8List.fromList(List<int>.from(json['bytes']));
    }

    return FileModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      extension: json['extension']?.toString() ?? '',
      path: json['path'],
      publicUrl: json['public_url'],
      name: json['name'],
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      base64: json['base64'],
      bytes: decodedBytes,
      livingClueId: json['living_clue_id'] is int
          ? json['living_clue_id']
          : int.tryParse(json['living_clue_id']?.toString() ?? ''),
      postId:
          json['post_id'] is int ? json['post_id'] : int.tryParse(json['post_id']?.toString() ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'living_clue_id': livingClueId,
      'post_id': postId,
    };
  }

  static List<FileModel> fromJsonArray(String body) {
    return List<FileModel>.from(
      jsonDecode(body).map((map) => FileModel.fromJson(map)),
    );
  }
}
