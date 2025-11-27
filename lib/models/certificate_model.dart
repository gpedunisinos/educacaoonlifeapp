import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:widgets_spo/models/model_base.dart';

class CertificateModel extends ModelBase {
  final MFile file;

  CertificateModel({
    required super.id,
    required this.file,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id'] ?? 0,
      file: MFile.fromJson(json['file']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file': file,
    };
  }

  static List<CertificateModel> fromJsonArray(List json) {
    return json.map((e) => CertificateModel.fromJson(e)).toList();
  }
}
