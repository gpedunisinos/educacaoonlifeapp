import 'dart:convert';

import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:widgets_spo/widgets_spo.dart';

import 'webclient.dart';

class FileWebclient {
  final WebClient webClient = WebClient.instance;

  String get endpoint => 'files';

  Future<List<FileModel>> fetch({int? livingClueId}) async {
    final Response response = await webClient.get(
      '/$endpoint',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {
        if (livingClueId != null) 'living_clue_id': livingClueId.toString(),
      },
    );

    return FileModel.fromJsonArray(response.body);
  }

  Future<FileModel> upload(FileModel model) async {
    final uploaded = await webClient.postMultipart(
      '/$endpoint',
      model,
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      fileFields: {
        if (model.livingClueId != null) 'living_clue_id': model.livingClueId.toString(),
        if (model.name != null) 'name': model.name,
        'extension': model.extension,
      },
    );
    return FileModel.fromJson(jsonDecode(uploaded.body) as Map<String, dynamic>);
  }

  Future<void> delete(int id) async {
    await webClient.delete(
      '/$endpoint/$id',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );
  }
}
