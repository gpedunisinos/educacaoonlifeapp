import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/screens/space/meeting_room_dialog.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

void main() {
  test(
    'meeting inputs normalize to a room on the configured HTTPS server only',
    () {
      expect(
        MeetingRoom.parse(' Encontro da Educação Onlife ').uri.toString(),
        'https://meet.spotec.app/encontro-da-educa%C3%A7%C3%A3o-onlife',
      );
      expect(
        MeetingRoom.parse(
          'https://meet.spotec.app/Sala-123?utm_source=convite#config.startWithAudioMuted=true',
        ).uri.toString(),
        'https://meet.spotec.app/sala-123',
      );
      expect(
        MeetingRoom.parse('meet.spotec.app/Sala-123').uri.toString(),
        'https://meet.spotec.app/sala-123',
      );
      expect(
        MeetingRoom.parse('Sala', baseUrl: 'https://meet.example.org').uri.host,
        'meet.example.org',
      );
      for (final input in [
        '',
        'javascript:alert(1)',
        '<iframe>',
        'https://evil.test/room',
        'https://meet.spotec.app.evil.test/room',
        'https://user:secret@meet.spotec.app/room',
        'http://meet.spotec.app/room',
        'https://meet.spotec.app:444/room',
        'https://meet.spotec.app',
        'https://meet.spotec.app/a/b',
        'https://meet.spotec.app/a%2Fb',
        'https://meet.spotec.app/room?jwt=secret',
        'https://meet.spotec.app/room#password=secret',
        'config.js',
        'http-bind',
      ]) {
        expect(
          () => MeetingRoom.parse(input),
          throwsFormatException,
          reason: input,
        );
      }
      expect(
        () => MeetingRoom.parse('sala', baseUrl: 'http://meet.example.org'),
        throwsFormatException,
      );
    },
  );

  testWidgets(
    'invalid invitation is refused; successful opening returns to the same cockpit',
    (tester) async {
      final opened = <Uri>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: spaceRecordTheme(),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => MeetingRoomDialog(
                    onOpen: (uri) async {
                      opened.add(uri);
                      return true;
                    },
                  ),
                ),
                child: const Text('Cockpit de teste'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Cockpit de teste'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'https://evil.test/room');
      await tester.tap(find.text('Entrar na sala'));
      await tester.pumpAndSettle();
      expect(opened, isEmpty);
      expect(
        find.text('Use um convite do servidor de encontros da plataforma.'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), 'Sala Aurora');
      await tester.tap(find.text('Entrar na sala'));
      await tester.pumpAndSettle();
      expect(opened.single.toString(), 'https://meet.spotec.app/sala-aurora');
      expect(find.byType(MeetingRoomDialog), findsNothing);
      expect(find.text('Cockpit de teste'), findsOneWidget);
    },
  );

  testWidgets(
    'small screen and blocked pop-up preserve the input without duplicate opening',
    (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final gate = Completer<bool>();
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: spaceRecordTheme(),
          home: Scaffold(
            body: MeetingRoomDialog(
              onOpen: (_) {
                calls++;
                return gate.future;
              },
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Sala pequena');
      await tester.ensureVisible(find.text('Entrar na sala'));
      await tester.tap(find.text('Entrar na sala'));
      await tester.pump();
      expect(calls, 1);
      expect(find.text('Abrindo…'), findsOneWidget);
      gate.complete(false);
      await tester.pumpAndSettle();
      expect(
        find.text(
          'O navegador não abriu a nova aba. Permita a abertura ou copie o link da sala.',
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Sala pequena',
      );
      expect(tester.takeException(), isNull);
    },
  );
}
