import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/screens/space/meeting_room_dialog.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

Future<Uri> fakeAuthorization(MeetingRoom room) async => room.authorizedUri({
  'room': room.uri.pathSegments.single,
  'public_url': room.uri.toString(),
  'jwt': 'test.payload.signature',
  'expires_at': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
});

void main() {
  test(
    'meeting inputs normalize to a room on the configured HTTPS server only',
    () {
      expect(
        MeetingRoom.parse(' Encontro da Educação OnLIFE ').uri.toString(),
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
                    onAuthorize: fakeAuthorization,
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
      expect(
        opened.single.toString(),
        'https://meet.spotec.app/sala-aurora?jwt=test.payload.signature',
      );
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
              onAuthorize: fakeAuthorization,
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
  testWidgets(
    'authorization failure preserves room and never opens invite as host',
    (tester) async {
      var opens = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeetingRoomDialog(
              onAuthorize: (_) async => throw Exception('unavailable'),
              onOpen: (_) async {
                opens++;
                return true;
              },
            ),
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'Sala preservada');
      await tester.tap(find.text('Entrar na sala'));
      await tester.pumpAndSettle();
      expect(opens, 0);
      expect(
        find.text(
          'Não foi possível autorizar ou abrir o encontro. Sua sala foi preservada; tente novamente.',
        ),
        findsOneWidget,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Sala preservada',
      );
    },
  );

  test(
    'host grant is tied to room, origin and expiration; public invite remains clean',
    () {
      final room = MeetingRoom.parse('Sala');
      Map<String, dynamic> grant() => {
        'room': 'sala',
        'public_url': room.uri.toString(),
        'jwt': 'test.payload.signature',
        'expires_at': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 600,
      };
      expect(
        room.authorizedUri(grant()).queryParameters['jwt'],
        'test.payload.signature',
      );
      expect(room.uri.hasQuery, isFalse);
      for (final field in ['room', 'public_url', 'jwt', 'expires_at']) {
        final bad = grant();
        bad[field] = field == 'expires_at' ? 0 : 'invalid';
        expect(() => room.authorizedUri(bad), throwsFormatException);
      }
    },
  );
  testWidgets('copy invite never requests or copies host credentials', (
    tester,
  ) async {
    String? copied;
    var authorizations = 0;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData')
          copied = (call.arguments as Map)['text'] as String;
        if (call.method == 'Clipboard.hasStrings') return {'value': false};
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MeetingRoomDialog(
            onAuthorize: (room) {
              authorizations++;
              return fakeAuthorization(room);
            },
            onOpen: (_) async => true,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Sala pública');
    await tester.tap(find.text('Copiar link'));
    await tester.pumpAndSettle();
    expect(copied, MeetingRoom.parse('Sala pública').uri.toString());
    expect(Uri.parse(copied!).hasQuery, isFalse);
    expect(authorizations, 0);
  });
}
