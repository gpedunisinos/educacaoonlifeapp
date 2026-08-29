import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';

class QuillDocumentUtils {
  static Document fromStored({String? delta, String? plainText}) {
    if (delta != null && delta.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(delta);
        if (decoded is List) {
          return Document.fromJson(decoded);
        }
      } catch (_) {
        // Conteúdo legado ou inválido usa a descrição em texto como fallback.
      }
    }

    final document = Document();
    final text = plainText?.trim() ?? '';
    if (text.isNotEmpty) {
      document.insert(0, text);
    }
    return document;
  }

  static String plainText(QuillController controller) {
    return controller.document.toPlainText().trim();
  }

  static String? encodeDelta(QuillController controller) {
    if (plainText(controller).isEmpty) return null;
    return jsonEncode(controller.document.toDelta().toJson());
  }
}
