import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:widgets_spo/widgets_spo.dart';

class FileUtils {
  static bool hasValidSize(MFileBase file) {
    return file.size != null && file.size! > 0;
  }

  static Future<void> prepareFileStream(MFileBase mFile) async {
    try {
      // MOBILE: se tiver path e não tiver stream/tamanho, cria stream a partir do arquivo
      if (!kIsWeb) {
        if ((mFile.readStream == null) && mFile.path != null && mFile.path!.isNotEmpty) {
          final file = File(mFile.path!);
          mFile.readStream = file.openRead();
          if (mFile.size == null || mFile.size == 0) {
            mFile.size = await file.length();
          }
        } else if ((mFile.size == null || mFile.size == 0) && mFile.path != null && mFile.path!.isNotEmpty) {
          // se só faltava o size, tenta obter pelo path
          mFile.size = await File(mFile.path!).length();
        }
      }
      // WEB: usa bytes ou base64 para criar stream e size
      else {
        // se já tem bytes, garante stream/size
        if (mFile.bytes != null) {
          mFile.readStream ??= Stream.fromIterable([mFile.bytes!]);
          if (mFile.size == null || mFile.size == 0) mFile.size = mFile.bytes!.length;
        }
        // se tiver base64 e não tiver bytes, decodifica e preenche
        else if (mFile.base64 != null && mFile.base64!.isNotEmpty) {
          final decoded = base64Decode(mFile.base64!);
          mFile.readStream ??= Stream.fromIterable([decoded]);
          if (mFile.size == null || mFile.size == 0) mFile.size = decoded.length;
          mFile.bytes ??= decoded;
        }
        // se tiver readStream mas faltar size, tenta inferir de bytes/base64 já em memória
        if (mFile.size == null || mFile.size == 0) {
          if (mFile.bytes != null) {
            mFile.size = mFile.bytes!.length;
          } else if (mFile.base64 != null) {
            mFile.size = base64Decode(mFile.base64!).length;
            mFile.bytes ??= base64Decode(mFile.base64!);
          }
        }
      }
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      rethrow;
    }
  }
}
