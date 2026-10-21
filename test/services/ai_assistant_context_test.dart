import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/utils/ai_reference.dart';

AiAssistantScreenContext screen(String name, String route) =>
    AiAssistantScreenContext(
      screenName: name,
      route: route,
      stage: 'test',
      goal: 'test',
    );

void main() {
  test(
    'route return restores live origin provider, never a stale different screen',
    () {
      final service = AiAssistantContextService();
      String draft = 'primeiro';
      final map = () => screen('mapa', '/living_clues/map');
      final clue = () => screen(draft, '/space/research/42');
      service.registerProvider('/living_clues/map', map);
      service.setCurrentRoute('/living_clues/map');
      service.registerProvider('/space/research/42', clue);
      service.setCurrentRoute('/space/research/42');
      expect(service.resolveCurrentContext().screenName, 'primeiro');
      draft = 'modificado sem salvar';
      service.setCurrentRoute(''); // Opening an overlay must retain the origin.
      expect(service.resolveCurrentContext().screenName, draft);
      service.unregisterProvider('/space/research/42', clue);
      service.setCurrentRoute('/living_clues/map');
      expect(service.resolveCurrentContext().screenName, 'mapa');
      service.setCurrentRoute('/space/agents');
      expect(service.resolveCurrentContext().screenName, 'Tela desconhecida');
    },
  );

  test(
    'query parameters match route; unregister restores previous same-route owner',
    () {
      final service = AiAssistantContextService();
      final original = () => screen('original', '/nodes/graph');
      final overlay = () => screen('seleção', '/nodes/graph');
      service.registerProvider('/nodes/graph', original);
      service.registerProvider('/nodes/graph', overlay);
      service.registerProvider(
        '/nodes/graph',
        overlay,
      ); // Rebuild is not a new owner.
      service.setCurrentRoute('/nodes/graph?focus=5');
      expect(service.resolveCurrentContext().screenName, 'seleção');
      service.unregisterProvider('/nodes/graph', overlay);
      expect(service.resolveCurrentContext().screenName, 'original');
    },
  );

  test(
    'structured IDs, bounded visible records and unsaved draft reach the API contract',
    () {
      final context = AiAssistantScreenContext(
        screenName: 'edição',
        route: '/living_clues/update?id=42',
        stage: 'rascunho',
        goal: 'revisar',
        references: {'living_clue_id': 42, 'category_id': 0},
        draft: {'unsaved': true, 'name': 'rascunho novo'},
        visibleRecords: List.generate(
          30,
          (i) => AiRecordReference(
            kind: 'living_clue',
            id: i + 1,
            name: 'Pista $i',
          ),
        ),
      );
      final data = context.toJson();
      expect(data['version'], 1);
      expect(data['references'], {'living_clue_id': 42});
      expect(data['visible_records'], hasLength(20));
      expect(data['draft']['unsaved'], true);
    },
  );

  test('AI internal references only navigate to supported read views', () {
    expect(aiInternalRoute('#/space/research/42'), '/space/research/42');
    expect(aiInternalRoute('#/nodes/graph?focus=12'), '/nodes/graph?focus=12');
    for (final href in [
      'javascript:alert(1)',
      '//evil.test/path',
      '/living_clues/delete?id=42',
      '#/nodes/graph?focus=abc',
      '#/space/research/42?edit=true',
    ]) {
      expect(aiInternalRoute(href), isNull, reason: href);
    }
  });
}
