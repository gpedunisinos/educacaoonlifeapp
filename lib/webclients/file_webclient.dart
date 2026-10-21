import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

import 'webclient.dart';

class FileWebclient {
  FileWebclient({WebClient? client}) : webClient = client ?? WebClient.instance;
  final WebClient webClient;
  static const maxBytes = 25 * 1024 * 1024;
  static const allowedExtensions = [
    'pdf',
    'txt',
    'csv',
    'json',
    'md',
    'rtf',
    'doc',
    'docx',
    'odt',
    'xls',
    'xlsx',
    'ods',
    'ppt',
    'pptx',
    'odp',
    'epub',
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'tif',
    'tiff',
    'mp3',
    'wav',
    'wma',
    'aac',
    'flac',
    'ogg',
    'm4a',
    'mp4',
    'mov',
    'webm',
    'zip',
  ];

  String get endpoint => 'files';

  Future<List<FileModel>> fetch({int? livingClueId}) async {
    final Response response = await webClient.get(
      '/$endpoint',
      [LoggingInterceptor(), ApiInterceptor(), TokenInterceptor()],
      {if (livingClueId != null) 'living_clue_id': livingClueId.toString()},
    );

    return FileModel.fromJsonArray(response.body);
  }

  Future<FileModel> upload(FileModel model) async {
    if ((model.size ?? model.bytes?.length ?? 0) > maxBytes) {
      throw const AttachmentException('O arquivo deve ter no máximo 25 MB.');
    }
    // Browsers may supply a blob path alongside the actual bytes. Prefer bytes
    // or a stream so the shared client never treats that path as a local file.
    final payload = FileModel(
      id: 0,
      extension: model.extension,
      name: model.name,
      bytes: model.bytes,
      readStream: model.readStream,
      size: model.size,
      path: model.bytes != null || model.readStream != null ? null : model.path,
      publicUrl: model.bytes != null || model.readStream != null
          ? null
          : model.publicUrl,
      livingClueId: model.livingClueId,
    );
    final uploaded = await webClient.postMultipart(
      '/$endpoint',
      payload,
      [LoggingInterceptor(), ApiInterceptor(), TokenInterceptor()],
      timeOut: 120,
      fileFields: {
        if (model.livingClueId != null)
          'living_clue_id': model.livingClueId.toString(),
        if (model.name != null) 'name': model.name,
        'extension': model.extension,
      },
    );
    if (uploaded.statusCode < 200 || uploaded.statusCode >= 300) {
      throw const AttachmentException(
        'Não foi possível enviar o arquivo. Confira o formato e tente novamente.',
      );
    }
    return FileModel.fromJson(
      jsonDecode(uploaded.body) as Map<String, dynamic>,
    );
  }

  Future<Uri> access(int id) async {
    final response = await webClient.get('/$endpoint/$id/access', [
      ApiInterceptor(),
      TokenInterceptor(),
    ], null);
    if (response.statusCode != 200) {
      throw const AttachmentException('Não foi possível acessar o arquivo.');
    }
    final result = jsonDecode(response.body) as Map<String, dynamic>;
    final uri = Uri.tryParse(result['url']?.toString() ?? '');
    if (uri == null ||
        !['https', 'http'].contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty) {
      throw const AttachmentException('Endereço do arquivo indisponível.');
    }
    return uri;
  }

  Future<void> delete(int id) async {
    final response = await webClient.delete('/$endpoint/$id', [
      LoggingInterceptor(),
      ApiInterceptor(),
      TokenInterceptor(),
    ]);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const AttachmentException('Não foi possível remover o arquivo.');
    }
  }
}

class AttachmentException implements Exception {
  const AttachmentException(this.message);
  final String message;
  @override
  String toString() => message;
}
