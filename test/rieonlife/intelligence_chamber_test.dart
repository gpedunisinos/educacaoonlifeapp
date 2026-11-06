import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/models/chat_message_model.dart';
import 'package:unisinos_usp_app/screens/space/intelligence_chamber_screen.dart';

class ChamberFake extends IntelligenceSource {
  bool failList = false;
  bool failSend = false;
  bool failHistory = false;
  int sent = 0;
  final entries = [
    ChatTemplateModel(
      id: 1,
      name: 'Aurora',
      description: 'Explora territórios.',
    ),
    ChatTemplateModel(id: 2, name: 'Gaia', description: 'Investiga conexões.'),
  ];
  @override
  Future<List<ChatTemplateModel>> agents(
    int offset, {
    String search = '',
  }) async {
    if (failList) throw Exception('offline');
    final filtered = entries
        .where(
          (agent) => '${agent.name} ${agent.description}'
              .toLowerCase()
              .contains(search.toLowerCase()),
        )
        .toList();
    return filtered.skip(offset).take(20).toList();
  }

  @override
  Future<ChatTemplateModel> agent(int id) async =>
      entries.firstWhere((a) => a.id == id);
  @override
  Future<List<ChatMessageModel>> history(int id, int offset) async {
    if (failHistory) throw Exception('offline');
    return [];
  }

  @override
  Future<List<ChatMessageModel>> send(int id, String text) async {
    sent++;
    if (failSend) throw Exception('offline');
    return [
      ChatMessageModel(
        id: 1,
        text: text,
        isUser: true,
        timestamp: DateTime(2026),
      ),
      ChatMessageModel(
        id: 2,
        text: 'Resposta do agente $id',
        isUser: false,
        timestamp: DateTime(2026),
      ),
    ];
  }
}

class DelayedSearchFake extends ChamberFake {
  final slow = Completer<List<ChatTemplateModel>>();
  @override
  Future<List<ChatTemplateModel>> agents(int offset, {String search = ''}) {
    if (search == 'lenta') return slow.future;
    return super.agents(offset, search: search);
  }
}

Widget chamberApp(ChamberFake source) => GetMaterialApp(
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
  home: IntelligenceChamberScreen(source: source),
  getPages: [
    GetPage(
      name: '/space/agents/:id',
      page: () => IntelligenceChamberScreen(
        agentId: int.parse(Get.parameters['id']!),
        initialAgent: Get.arguments as ChatTemplateModel,
        source: source,
      ),
    ),
  ],
);
void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);
  testWidgets(
    'conversation opened from a pista offers the correct return action',
    (tester) async {
      final source = ChamberFake();
      await tester.pumpWidget(
        GetMaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
          home: Scaffold(
            body: TextButton(
              onPressed: () => Get.to(
                () => IntelligenceChamberScreen(
                  agentId: 1,
                  source: source,
                  fromClue: true,
                ),
              ),
              child: const Text('Pista de origem'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Pista de origem'));
      await tester.pumpAndSettle();
      expect(find.text('Voltar à pista'), findsOneWidget);
      await tester.tap(find.text('Voltar à pista'));
      await tester.pumpAndSettle();
      expect(find.text('Pista de origem'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'search reaches agents beyond the first page and paginates filtered results',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final source = ChamberFake();
      source.entries.clear();
      source.entries.addAll(
        List.generate(
          45,
          (i) => ChatTemplateModel(
            id: i + 1,
            name: 'Agente $i',
            description: 'Pesquisa territorial',
          ),
        ),
      );
      source.entries.add(
        ChatTemplateModel(
          id: 99,
          name: 'Oceano',
          description: 'Exploração oceânica',
        ),
      );
      await tester.pumpWidget(chamberApp(source));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('20 inteligências disponíveis'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), 'oceânica');
      await tester.pumpAndSettle();
      expect(find.text('Exploração oceânica'), findsOneWidget);
      expect(find.textContaining('1 inteligência disponível'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Pesquisa');
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Mais inteligências'),
        700,
        scrollable: find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      );
      await tester.tap(find.text('Mais inteligências'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('40 inteligências disponíveis'),
        findsOneWidget,
      );
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pumpAndSettle();
      expect(
        find.text('Nenhuma inteligência encontrada para “inexistente”.'),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Limpar busca'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('20 inteligências disponíveis'),
        findsOneWidget,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    },
  );
  testWidgets('a late search response never replaces a newer result', (
    tester,
  ) async {
    final source = DelayedSearchFake();
    await tester.pumpWidget(chamberApp(source));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'lenta');
    await tester.pump(const Duration(milliseconds: 301));
    await tester.enterText(find.byType(TextField), 'Gaia');
    await tester.pumpAndSettle();
    expect(find.text('Investiga conexões.'), findsOneWidget);
    source.slow.complete([source.entries.first]);
    await tester.pumpAndSettle();
    expect(find.text('Investiga conexões.'), findsOneWidget);
    expect(find.text('Explora territórios.'), findsNothing);
  });
  testWidgets(
    'real agent selection leads to its conversation and sends through the source',
    (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final source = ChamberFake();
      await tester.pumpWidget(chamberApp(source));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gaia').last);
      await tester.pumpAndSettle();
      expect(find.text('Investiga conexões.'), findsOneWidget);
      await tester.ensureVisible(find.text('Iniciar conversa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Iniciar conversa'));
      await tester.pumpAndSettle();
      expect(Get.currentRoute, '/space/agents/2');
      expect(source.sent, 0);
      await tester.enterText(find.byType(TextField), 'Olá, Gaia');
      await tester.tap(find.byTooltip('Enviar mensagem'));
      await tester.pumpAndSettle();
      expect(source.sent, 1);
      expect(find.text('Resposta do agente 2'), findsOneWidget);
      expect(find.text('Olá, Gaia'), findsOneWidget);
      await tester.tap(find.text('Escolher inteligência'));
      await tester.pumpAndSettle();
      expect(find.text('Investiga conexões.'), findsOneWidget);
    },
  );
  testWidgets(
    'failure preserves draft and retry does not duplicate a user message',
    (tester) async {
      final source = ChamberFake()..failSend = true;
      await tester.pumpWidget(chamberApp(source));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Iniciar conversa'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Iniciar conversa'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Minha pergunta');
      await tester.tap(find.byTooltip('Enviar mensagem'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'Minha pergunta',
      );
      expect(find.textContaining('Sua mensagem foi mantida'), findsOneWidget);
      source.failSend = false;
      await tester.tap(find.byTooltip('Enviar mensagem'));
      await tester.pumpAndSettle();
      expect(find.text('Minha pergunta'), findsOneWidget);
    },
  );
  testWidgets('list and history errors can be retried', (tester) async {
    final source = ChamberFake()..failList = true;
    await tester.pumpWidget(chamberApp(source));
    await tester.pumpAndSettle();
    expect(
      find.text('Não foi possível acessar as inteligências.'),
      findsOneWidget,
    );
    source.failList = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    source.failHistory = true;
    await tester.ensureVisible(find.text('Iniciar conversa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar conversa'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível carregar a conversa.'), findsOneWidget);
    source.failHistory = false;
    await tester.tap(find.text('Tentar novamente'));
    await tester.pumpAndSettle();
    expect(
      find.text('Uma nova conversa começa com uma pergunta.'),
      findsOneWidget,
    );
  });
  testWidgets('mobile selection and conversation fit the viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final source = ChamberFake();
    await tester.pumpWidget(chamberApp(source));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Iniciar conversa'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Iniciar conversa'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar conversa'));
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/space/agents/1');
    expect(find.byType(TextField), findsOneWidget);
  });
  testWidgets('long agent names fit the Android portrait cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(411, 914);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final source = ChamberFake();
    source.entries[0] = ChatTemplateModel(
      id: 1,
      name: 'Guia do Território — demonstração',
      description: 'Agente sintético.',
    );
    source.entries[1] = ChatTemplateModel(
      id: 2,
      name: 'Cartógrafa dos territórios e vivências OnLIFE',
      description: 'Agente sintético.',
    );
    await tester.pumpWidget(chamberApp(source));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Guia do Território — demonstração'), findsWidgets);
  });
}
