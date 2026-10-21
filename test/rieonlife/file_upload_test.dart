import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/models/mfile_base_model.dart';
import 'package:unisinos_usp_app/models/file_model.dart';
import 'package:unisinos_usp_app/webclients/file_webclient.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:unisinos_usp_app/widgets/clue_attachment_tile.dart';

class UploadClient implements WebClient {
  MFileBase? payload;
  Map<String, String?>? fields;
  int status = 200;
  String accessURL = 'https://bucket.example.test/file?signature=temporary';
  int gets = 0;
  @override
  Future<http.Response> postMultipart(
    String uri,
    MFileBase file,
    List<InterceptorContract> interceptors, {
    int? timeOut,
    Map<String, String?> fileFields = const {},
  }) async {
    payload = file;
    fields = fileFields;
    return http.Response(
      jsonEncode({
        'id': 12,
        'extension': 'txt',
        'name': file.name,
        'living_clue_id': 7,
        'storage_provider': 's3',
        'size': 5,
      }),
      status,
    );
  }

  @override
  Future<http.Response> get(
    String uri,
    List<InterceptorContract>? interceptors,
    Map<String, dynamic>? queryParameters, {
    int? timeOut,
  }) async {
    gets++;
    return http.Response(jsonEncode({'url': accessURL}), status);
  }

  @override
  Future<http.Response> delete(
    String uri,
    List<InterceptorContract>? interceptors, {
    int? timeOut,
  }) async => http.Response('{}', status);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'browser upload prefers bytes over blob path and sends the pista ID',
    () async {
      final client = UploadClient();
      final api = FileWebclient(client: client);
      final uploaded = await api.upload(
        FileModel(
          id: 0,
          extension: 'txt',
          name: 'observação.txt',
          path: 'blob:local-path',
          bytes: Uint8List.fromList(utf8.encode('teste')),
          livingClueId: 7,
        ),
      );
      expect(client.payload!.path, isNull);
      expect(client.payload!.bytes, isNotNull);
      expect(client.fields!['living_clue_id'], '7');
      expect(uploaded.storageProvider, 's3');
      expect(uploaded.size, 5);
    },
  );
  test(
    'large files fail before network and unsuccessful responses do not become attachments',
    () async {
      final client = UploadClient();
      final api = FileWebclient(client: client);
      await expectLater(
        api.upload(
          FileModel(id: 0, extension: 'txt', size: FileWebclient.maxBytes + 1),
        ),
        throwsA(isA<AttachmentException>()),
      );
      expect(client.payload, isNull);
      client.status = 503;
      await expectLater(
        api.upload(FileModel(id: 0, extension: 'txt', bytes: Uint8List(1))),
        throwsA(isA<AttachmentException>()),
      );
      await expectLater(api.delete(12), throwsA(isA<AttachmentException>()));
    },
  );
  test(
    'download access is renewed on each request and rejects active schemes',
    () async {
      final client = UploadClient();
      final api = FileWebclient(client: client);
      expect((await api.access(12)).host, 'bucket.example.test');
      await api.access(12);
      expect(client.gets, 2);
      client.accessURL = 'javascript:alert(1)';
      await expectLater(api.access(12), throwsA(isA<AttachmentException>()));
    },
  );
  testWidgets(
    'attachment controls fit narrow screens and failed access allows retry',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final client = UploadClient()..status = 503;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ClueAttachmentTile(
              file: FileModel(
                id: 12,
                extension: 'pdf',
                name:
                    'Nome de evidência bastante longo para conferir a leitura.pdf',
                size: 1024,
              ),
              client: FileWebclient(client: client),
              onRemove: () {},
            ),
          ),
        ),
      );
      await tester.tap(find.byTooltip('Acessar arquivo'));
      await tester.pumpAndSettle();
      expect(find.text('Não foi possível acessar o arquivo.'), findsOneWidget);
      expect(find.byTooltip('Acessar arquivo'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
