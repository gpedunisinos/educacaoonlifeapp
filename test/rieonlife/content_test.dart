import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unisinos_usp_app/widgets/living_clue_description_view.dart';
import 'package:unisinos_usp_app/widgets/clue_media.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/policies/living_clue_policy.dart';
import 'package:unisinos_usp_app/policies/user_policy.dart';

void main() {
  test('nullable coordinates retain null and explicit zero', () {
    final clue = LivingClueModel.fromJson({'id': 1, 'category_id': 1});
    expect(clue.hasLocation, false);
    expect(clue.toJson()['latitude'], isNull);
    expect(clue.toJson()['remove_location'], true);
    final zero = LivingClueModel.fromJson(
        {'id': 2, 'category_id': 1, 'latitude': 0, 'longitude': 0});
    expect(zero.hasLocation, true);
    expect(zero.toJson()['latitude'], 0);
  });
  test('mode and profile remain independent', () {
    const explorer = AuthUser(
        id: 1,
        name: 'A',
        email: 'a',
        token: 't',
        profile: 40,
        usageMode: 'explorer');
    const inventor = AuthUser(
        id: 2,
        name: 'B',
        email: 'b',
        token: 't',
        profile: 10,
        usageMode: 'inventor');
    expect(LivingCluePolicy(explorer).create(), false);
    expect(LivingCluePolicy(explorer).viewAny(), true);
    expect(LivingCluePolicy(inventor).create(), true);
    expect(UserPolicy(inventor).create(), false);
  });
  test('YouTube only accepts video addresses from allowed hosts', () {
    expect(youtubeId('https://youtu.be/dQw4w9WgXcQ'), 'dQw4w9WgXcQ');
    expect(
        youtubeId('https://youtube.com.evil.test/watch?v=dQw4w9WgXcQ'), isNull);
    expect(youtubeId('https://youtube.com/playlist?list=x'), isNull);
  });
  test(
      'hyperlink destinations deduplicate and embedded video suppresses previews',
      () {
    final c = QuillController(
        document: Document.fromJson([
          {
            'insert': 'Texto',
            'attributes': {'link': 'https://example.org/a#fragment'}
          },
          {'insert': ' https://example.org/a https://youtu.be/dQw4w9WgXcQ\n'},
          {
            'insert': {'video': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'}
          },
          {'insert': '\n'}
        ]),
        selection: const TextSelection.collapsed(offset: 0));
    expect(documentLinks(c), {'https://example.org/a'});
    c.dispose();
  });
  for (final offset in [0, 3, 6]) {
    test('video inserts at $offset with undo redo and storage roundtrip', () {
      final c = QuillController(
          document: Document.fromJson([
            {'insert': 'abcdef\n'}
          ]),
          selection: TextSelection.collapsed(offset: offset));
      c.replaceText(offset, 0, BlockEmbed.video('https://youtu.be/dQw4w9WgXcQ'),
          TextSelection.collapsed(offset: offset + 1));
      final encoded = QuillDocumentUtils.encodeDelta(c)!;
      expect(encoded, contains('video'));
      final document = QuillDocumentUtils.fromStored(delta: encoded);
      expect(jsonEncode(document.toDelta().toJson()), encoded);
      c.undo();
      expect(c.document.toPlainText(), 'abcdef\n');
      c.redo();
      expect(QuillDocumentUtils.encodeDelta(c), contains('video'));
      c.dispose();
    });
  }
  test('video-only document persists without pretending to transcribe it', () {
    final c = QuillController(
        document: Document.fromJson([
          {
            'insert': {'video': 'https://youtu.be/dQw4w9WgXcQ'}
          },
          {'insert': '\n'}
        ]),
        selection: const TextSelection.collapsed(offset: 0));
    expect(QuillDocumentUtils.plainText(c), '');
    expect(QuillDocumentUtils.encodeDelta(c), contains('video'));
    c.dispose();
  });
  testWidgets('reader refreshes the same document after a successful edit',
      (tester) async {
    Widget reader(String text) => MaterialApp(localizationsDelegates: const [
          FlutterQuillLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ], supportedLocales: const [
          Locale('pt', 'BR')
        ], home: Scaffold(body: LivingClueDescriptionView(plainText: text)));
    await tester.pumpWidget(reader('Primeira descrição'));
    await tester.pump();
    expect(find.textContaining('Primeira descrição', findRichText: true),
        findsWidgets);
    await tester.pumpWidget(reader('Descrição atualizada'));
    await tester.pump();
    expect(find.textContaining('Descrição atualizada', findRichText: true),
        findsWidgets);
    expect(find.textContaining('Primeira descrição', findRichText: true),
        findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
