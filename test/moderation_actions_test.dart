import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';
import 'package:unisinos_usp_app/widgets/moderation_actions.dart';

class FakeModerationApi extends EconectivaApi {
  String? path;
  String? method;
  Map<String, dynamic>? body;
  bool fail = false;

  @override
  Future<void> postEmpty(String path) async {
    this.path = path;
    method = 'POST';
    body = null;
    if (fail) throw Exception('unavailable');
  }

  @override
  Future<dynamic> write(
    String method,
    String path, [
    Map<String, dynamic> body = const {},
  ]) async {
    this.path = path;
    this.method = method;
    this.body = body;
    if (fail) throw Exception('unavailable');
    return <String, dynamic>{};
  }
}

void main() {
  testWidgets('reports the target after confirmation', (tester) async {
    final api = FakeModerationApi();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ModerationActions.report(
                context,
                conversationId: 'chat',
                api: api,
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Denunciar conversa'));
    await tester.pumpAndSettle();
    expect(api.path, '/me/conversations/chat/report');
    expect(api.method, 'POST');
    expect(api.body, isEmpty);
    expect(find.text('Denúncia enviada para análise.'), findsOneWidget);
  });

  testWidgets('does not claim success when blocking fails', (tester) async {
    final api = FakeModerationApi()..fail = true;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ModerationActions.block(
                context,
                conversationId: 'chat',
                api: api,
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bloquear'));
    await tester.pumpAndSettle();
    expect(api.path, '/me/conversations/chat/block');
    expect(api.body, isNull);
    expect(
      find.text('Não foi possível bloquear a conversa. Tente novamente.'),
      findsOneWidget,
    );
    expect(find.text('Conversa bloqueada.'), findsNothing);
  });

  testWidgets('unblocks a conversation with DELETE after confirmation', (
    tester,
  ) async {
    final api = FakeModerationApi();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => ModerationActions.block(
                context,
                conversationId: 'chat',
                unblock: true,
                api: api,
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desbloquear'));
    await tester.pumpAndSettle();
    expect(api.method, 'DELETE');
    expect(api.path, '/me/conversations/chat/block');
    expect(find.text('Conversa desbloqueada.'), findsOneWidget);
  });
}
