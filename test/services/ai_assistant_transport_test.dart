import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/utils/ai_chat_error.dart';
import 'package:unisinos_usp_app/webclients/ai_assistant_webclient.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';

void main() {
  test(
    'screen IDs and current unsaved values travel in a structured context',
    () async {
      final previous = WebClient.instance.client;
      addTearDown(() => WebClient.instance.client = previous);
      Map<String, dynamic>? request;
      WebClient.instance.client = MockClient((r) async {
        expect(r.url.path, '/api/ai/messages');
        request = jsonDecode(r.body) as Map<String, dynamic>;
        return http.Response('[]', 200);
      });
      await AiAssistantWebclient().sendMessage(
        message: 'Ajude com esta pista',
        context: '',
        screenContext: AiAssistantScreenContext(
          screenName: 'edição',
          route: '/living_clues/update?id=42',
          stage: 'rascunho',
          goal: 'revisar',
          references: {'living_clue_id': 42},
          draft: {'unsaved': true, 'name': 'Ainda não salvo'},
        ),
      );
      expect(request?['screen_context']['references']['living_clue_id'], 42);
      expect(request?['screen_context']['draft']['unsaved'], true);
      expect(request?['context'], '');
      expect(request?.containsKey('history'), false);
    },
  );

  test(
    'context size is bounded and sensitive form keys are excluded recursively',
    () {
      final context = AiAssistantScreenContext(
        screenName: 'form',
        route: '/form',
        stage: 'rascunho',
        goal: 'help',
        filledFields: {'password': 'not-for-ai', 'nome': 'a' * 100000},
        draft: {
          'unsaved': true,
          'metadata': {'api_key': 'private', 'observacao': 'public'},
        },
      );
      final encoded = jsonEncode(context.toJson());
      expect(encoded, isNot(contains('not-for-ai')));
      expect(encoded, isNot(contains('private')));
      expect(encoded.length, lessThan(15000));
      expect(encoded, contains('public'));
    },
  );

  test(
    'quota remains understandable while arbitrary error details remain hidden',
    () {
      const quota =
          'A inteligência artificial está temporariamente sem quota. Tente novamente mais tarde.';
      expect(aiChatError(quota), quota);
      expect(
        aiChatError('https://example.test?key=private'),
        isNot(contains('private')),
      );
    },
  );
}
