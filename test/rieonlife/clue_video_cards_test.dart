import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/utils/quill_document_utils.dart';
import 'package:unisinos_usp_app/widgets/clue_media.dart';
import 'package:unisinos_usp_app/widgets/living_clue_description_editor.dart';

void main() {
  testWidgets(
    'description editor keeps legacy playback outside the prose on narrow screens',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = QuillController(
        document: QuillDocumentUtils.fromStored(
          delta:
              '[{"insert":"Texto antes\\n"},{"insert":{"video":"https://youtu.be/dQw4w9WgXcQ"}},{"insert":"\\nTexto depois\\n"}]',
        ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: LivingClueDescriptionEditor(controller: controller),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ClueVideo), findsNothing);
      expect(
        find.descendant(
          of: find.byType(QuillEditor),
          matching: find.text('Vídeo do YouTube'),
        ),
        findsNothing,
      );
      expect(find.text('Vídeo do YouTube'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );

  testWidgets(
    'video cards add, edit and remove without replacing selected prose',
    (tester) async {
      final controller = QuillController.basic();
      controller.document.insert(0, 'Descrição preservada');
      controller.updateSelection(
        const TextSelection(baseOffset: 0, extentOffset: 9),
        ChangeSource.local,
      );
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Builder(
                    builder: (context) => TextButton(
                      onPressed: () => insertYouTube(context, controller),
                      child: const Text('Adicionar'),
                    ),
                  ),
                  ClueVideoCards(controller: controller),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Adicionar'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'https://youtu.be/dQw4w9WgXcQ',
      );
      await tester.tap(find.text('Adicionar vídeo'));
      await tester.pumpAndSettle();
      expect(QuillDocumentUtils.plainText(controller), 'Descrição preservada');
      expect(find.text('Vídeo do YouTube'), findsOneWidget);
      expect(find.byType(ClueVideo), findsNothing);

      final saved = QuillDocumentUtils.encodeDelta(controller);
      controller.document = QuillDocumentUtils.fromStored(delta: saved);
      await tester.pumpAndSettle();
      expect(find.text('Vídeo do YouTube'), findsOneWidget);
      await tester.tap(find.text('Editar vídeo'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextField),
        'https://youtu.be/abcdefghijk',
      );
      await tester.tap(find.text('Salvar vídeo'));
      await tester.pumpAndSettle();
      expect(
        find.text('https://www.youtube.com/watch?v=abcdefghijk'),
        findsOneWidget,
      );
      expect(
        QuillDocumentUtils.encodeDelta(controller),
        isNot(contains('dQw4w9WgXcQ')),
      );
      await tester.tap(find.text('Remover vídeo'));
      await tester.pumpAndSettle();
      expect(find.text('Vídeo do YouTube'), findsNothing);
      expect(QuillDocumentUtils.plainText(controller), 'Descrição preservada');
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );

  testWidgets(
    'legacy videos are managed independently and unrelated embeds survive',
    (tester) async {
      final controller = QuillController(
        document: QuillDocumentUtils.fromStored(
          delta:
              '[{"insert":"Antes\\n"},{"insert":{"video":"https://youtu.be/dQw4w9WgXcQ"}},{"insert":"\\nDepois\\n"},{"insert":{"future":"preservar"}},{"insert":"\\n"},{"insert":{"video":"https://youtu.be/abcdefghijk"}},{"insert":"\\n"}]',
        ),
        selection: const TextSelection.collapsed(offset: 0),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: ClueVideoCards(controller: controller),
            ),
          ),
        ),
      );
      expect(find.text('Vídeo do YouTube'), findsNWidgets(2));
      await tester.tap(find.text('Remover vídeo').first);
      await tester.pumpAndSettle();
      expect(find.text('Vídeo do YouTube'), findsOneWidget);
      expect(QuillDocumentUtils.encodeDelta(controller), contains('preservar'));
      expect(
        QuillDocumentUtils.encodeDelta(controller),
        contains('abcdefghijk'),
      );
      expect(QuillDocumentUtils.plainText(controller), contains('Depois'));
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
}
