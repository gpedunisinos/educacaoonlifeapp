import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/models/chat_message_model.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/webclients/chat_template_webclient.dart';

const _ink = Color(0xFF050A18);
const _light = Color(0xFFB0E9EF);
const _soft = Color(0xFF9FB5CF);

/// Shares the authenticated platform APIs, with an injectable source for widget tests.
class IntelligenceSource {
  final _api = ChatTemplateWebclient();
  Future<List<ChatTemplateModel>> agents(int offset, {String search = ''}) =>
      _api.fetch(offset: offset, search: search);
  Future<ChatTemplateModel> agent(int id) => _api.fetchById(id);
  Future<List<ChatMessageModel>> history(int id, int offset) =>
      _api.fetchMessages(id, offset: offset);
  Future<List<ChatMessageModel>> send(int id, String text) =>
      _api.sendMessage(id, text);
}

class IntelligenceChamberScreen extends StatefulWidget {
  const IntelligenceChamberScreen({
    super.key,
    this.agentId,
    this.initialAgent,
    this.source,
  });
  final int? agentId;
  final ChatTemplateModel? initialAgent;
  final IntelligenceSource? source;
  @override
  State<IntelligenceChamberScreen> createState() =>
      _IntelligenceChamberScreenState();
}

class _IntelligenceChamberScreenState extends State<IntelligenceChamberScreen>
    with SingleTickerProviderStateMixin {
  late final source = widget.source ?? IntelligenceSource();
  late final AnimationController motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 32),
  );
  final draft = TextEditingController();
  final agentSearch = TextEditingController();
  Timer? searchDebounce;
  String agentQuery = '';
  int agentsRequest = 0;
  final messagesScroll = ScrollController();
  List<ChatTemplateModel> agents = [];
  List<ChatMessageModel> messages = [];
  ChatTemplateModel? selected;
  bool loading = true;
  bool failed = false;
  bool loadingMore = false;
  bool hasMore = false;
  bool historyLoading = false;
  bool historyFailed = false;
  bool historyMore = false;
  bool olderLoading = false;
  bool sending = false;
  String? sendError;
  bool get inConversation => widget.agentId != null;
  String get route =>
      inConversation ? '/space/agents/${widget.agentId}' : '/space/agents';
  late final AiAssistantContextProvider contextProvider = buildContext;
  AiAssistantScreenContext buildContext() => AiAssistantScreenContext(
    screenName: 'Câmara de Inteligências',
    route: route,
    stage: inConversation ? 'conversa com agente' : 'seleção de inteligência',
    goal: 'escolher uma inteligência e conversar com ela',
    references: {if (selected?.id != null) 'agent_id': selected!.id},
    visibleRecords: agents.take(20).map((agent) => AiRecordReference(kind: 'agent', id: agent.id, name: agent.name)).toList(),
    filledFields: {'busca': agentSearch.text, if (selected != null) 'agente': selected!.name},
    notes: const [
      'Presenças holográficas representam agentes reais cadastrados. A Iareté é a anfitriã global; este agente tem conversa própria, distinta da Iareté e do chat da pista.',
    ],
  );
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().registerProvider(
        route,
        contextProvider,
      );
    }
    load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      motion.stop();
    } else if (!motion.isAnimating) {
      motion.repeat();
    }
  }

  void changeAgentSearch(String value) {
    searchDebounce?.cancel();
    agentsRequest++;
    setState(() {
      agentQuery = value.trim();
      loading = true;
      failed = false;
      loadingMore = false;
    });
    searchDebounce = Timer(const Duration(milliseconds: 300), load);
  }

  Future<void> load() async {
    final request = ++agentsRequest;
    setState(() {
      loading = true;
      failed = false;
      loadingMore = false;
    });
    try {
      if (inConversation) {
        final agent = widget.initialAgent?.id == widget.agentId
            ? widget.initialAgent!
            : await source.agent(widget.agentId!);
        if (!mounted) return;
        setState(() {
          selected = agent;
          loading = false;
        });
        await loadHistory();
      } else {
        final result = await source.agents(0, search: agentQuery);
        if (!mounted || request != agentsRequest) return;
        setState(() {
          final matching = result.where((agent) => agent.id == selected?.id);
          agents = result;
          selected = matching.isNotEmpty
              ? matching.first
              : result.isEmpty
              ? null
              : result.first;
          hasMore = result.length == 20;
          loading = false;
        });
      }
    } catch (_) {
      if (mounted && request == agentsRequest) {
        setState(() {
          loading = false;
          failed = true;
        });
      }
    }
  }

  Future<void> moreAgents() async {
    if (loading || loadingMore || !hasMore) return;
    final request = agentsRequest;
    setState(() => loadingMore = true);
    try {
      final result = await source.agents(agents.length, search: agentQuery);
      if (!mounted || request != agentsRequest) return;
      setState(() {
        agents.addAll(result);
        hasMore = result.length == 20;
      });
    } catch (_) {
      if (mounted && request == agentsRequest) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível carregar mais agentes. Tente novamente.',
            ),
          ),
        );
      }
    } finally {
      if (mounted && request == agentsRequest) {
        setState(() => loadingMore = false);
      }
    }
  }

  Future<void> loadHistory({bool older = false}) async {
    if (historyLoading || olderLoading) return;
    setState(() {
      if (older) {
        olderLoading = true;
      } else {
        historyLoading = true;
        historyFailed = false;
      }
    });
    try {
      final result = await source.history(
        widget.agentId!,
        older ? messages.length : 0,
      );
      if (!mounted) return;
      setState(() {
        if (older) {
          messages.insertAll(0, result);
        } else {
          messages = result;
        }
        historyMore = result.length == 50;
      });
    } catch (_) {
      if (mounted) {
        if (older) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível carregar mensagens anteriores.'),
            ),
          );
        } else {
          setState(() => historyFailed = true);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          historyLoading = false;
          olderLoading = false;
        });
      }
    }
  }

  Future<void> send() async {
    final text = draft.text.trim();
    if (text.isEmpty ||
        sending ||
        historyLoading ||
        historyFailed ||
        !inConversation) {
      return;
    }
    final pending = ChatMessageModel(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      role: 'user',
    );
    setState(() {
      sending = true;
      sendError = null;
      messages.add(pending);
    });
    bottom();
    try {
      final result = await source.send(widget.agentId!, text);
      if (!mounted) return;
      setState(() {
        if (result.any((m) => m.isUser && m.text == text)) {
          messages.remove(pending);
        }
        for (final message in result) {
          if (message.id == null || !messages.any((m) => m.id == message.id)) {
            messages.add(message);
          }
        }
        draft.clear();
      });
      bottom();
    } catch (_) {
      if (mounted) {
        setState(() {
          messages.remove(pending);
          sendError =
              'Não foi possível enviar. Sua mensagem foi mantida para tentar novamente.';
        });
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  void bottom() => WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted && messagesScroll.hasClients) {
      messagesScroll.animateTo(
        0,
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  });
  void leave() {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed(inConversation ? '/space/agents' : '/space');
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(
        route,
        contextProvider,
      );
    }
    searchDebounce?.cancel();
    agentSearch.dispose();
    motion.dispose();
    draft.dispose();
    messagesScroll.dispose();
    super.dispose();
  }

  Color colorFor(ChatTemplateModel? agent) => const [
    Color(0xFF7EDCEB),
    Color(0xFFC0A1FF),
    Color(0xFF80E7CB),
    Color(0xFF9DBBFF),
  ][(agent?.id ?? 0) % 4];
  Widget presence(ChatTemplateModel? agent, {bool small = false}) =>
      RepaintBoundary(
        child: AnimatedBuilder(
          animation: motion,
          builder: (context, _) => CustomPaint(
            painter: _PresencePainter(
              motion.value * math.pi * 2,
              colorFor(agent),
              sending,
              agent?.id,
              {
                for (final item in agents) item.id,
                if (agent != null) agent.id,
              }.toList(),
            ),
            child: SizedBox.expand(
              child: Align(
                alignment: const Alignment(0, .85),
                child: Text(
                  small ? '' : 'PONTO EM DESTAQUE · ${agent?.name ?? ''}',
                  style: TextStyle(
                    color: colorFor(agent),
                    letterSpacing: 2,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: _ink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFAAB7F9),
        brightness: Brightness.dark,
      ),
    ),
    child: Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          return Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: AnimatedBuilder(
                    animation: motion,
                    builder: (_, _) => CustomPaint(
                      painter: _ChamberPainter(
                        motion.value * math.pi * 2,
                        inConversation,
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 16 : constraints.maxWidth * .065,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: leave,
                              icon: const Icon(Icons.arrow_back, size: 17),
                              label: Text(
                                inConversation
                                    ? (compact
                                          ? 'Inteligências'
                                          : 'Escolher inteligência')
                                    : compact
                                    ? 'Cockpit'
                                    : 'Voltar ao cockpit',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'EC–01 / CÂMARA DE INTELIGÊNCIAS',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  color: _light,
                                  fontSize: 9,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!inConversation)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: compact ? 8 : 16,
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Outras inteligências.\nNovas perspectivas.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: compact ? 26 : 38,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Escolha com quem você quer explorar.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: _soft, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      if (!inConversation) agentSearchField(compact),
                      Expanded(
                        child: loading
                            ? const Center(
                                child: CircularProgressIndicator(color: _light),
                              )
                            : failed
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Não foi possível acessar as inteligências.',
                                      style: TextStyle(color: _soft),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: load,
                                      child: const Text('Tentar novamente'),
                                    ),
                                  ],
                                ),
                              )
                            : selected == null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    agentQuery.isEmpty
                                        ? 'Nenhum agente disponível.'
                                        : 'Nenhuma inteligência encontrada para “$agentQuery”.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: _soft),
                                  ),
                                ),
                              )
                            : inConversation
                            ? conversation(compact)
                            : selection(compact),
                      ),
                      if (!inConversation &&
                          !loading &&
                          !failed &&
                          agents.isNotEmpty)
                        SizedBox(
                          height: compact ? 110 : 132,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            itemCount: agents.length + (hasMore ? 1 : 0),
                            separatorBuilder: (_, _) =>
                                const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              if (i == agents.length) {
                                return SizedBox(
                                  width: 150,
                                  child: OutlinedButton(
                                    onPressed: loadingMore ? null : moreAgents,
                                    child: Text(
                                      loadingMore
                                          ? 'Carregando…'
                                          : 'Mais inteligências',
                                    ),
                                  ),
                                );
                              }
                              final agent = agents[i];
                              final active = agent.id == selected?.id;
                              return SizedBox(
                                width: compact ? 160 : 200,
                                child: Material(
                                  color: active
                                      ? const Color(0xFF203044)
                                      : const Color(0xCC081321),
                                  borderRadius: BorderRadius.circular(8),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: () =>
                                        setState(() => selected = agent),
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: active
                                              ? colorFor(agent)
                                              : const Color(0xFF2A3E55),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.auto_awesome_outlined,
                                            color: colorFor(agent),
                                            size: 20,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            agent.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (!compact && !inConversation)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Text(
                            'IARETÉ / Cada inteligência abre uma forma de olhar.',
                            style: TextStyle(
                              color: _soft,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  Widget agentSearchField(bool compact) => Padding(
    padding: EdgeInsets.only(bottom: compact ? 8 : 12),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: agentSearch,
              onChanged: changeAgentSearch,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) {
                searchDebounce?.cancel();
                load();
              },
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar agentes por nome ou descrição',
                hintStyle: const TextStyle(color: _soft, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: _light),
                suffixIcon: agentSearch.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.close, color: _light),
                        onPressed: () {
                          agentSearch.clear();
                          changeAgentSearch('');
                        },
                      ),
                filled: true,
                fillColor: const Color(0xE6091525),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF324B65)),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              loading
                  ? 'Buscando inteligências…'
                  : failed
                  ? 'Busca indisponível. Tente novamente.'
                  : '${agents.length} ${agents.length == 1 ? 'inteligência disponível' : 'inteligências disponíveis'}${hasMore ? ' · há mais resultados' : ''}',
              style: const TextStyle(color: _soft, fontSize: 11),
            ),
          ],
        ),
      ),
    ),
  );

  Widget selection(bool compact) {
    final agent = selected!;
    final details = AnimatedSwitcher(
      duration: Duration(
        milliseconds: MediaQuery.disableAnimationsOf(context) ? 0 : 350,
      ),
      child: Container(
        key: ValueKey(agent.id),
        padding: EdgeInsets.all(compact ? 18 : 28),
        decoration: BoxDecoration(
          color: const Color(0xE6091525),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorFor(agent).withValues(alpha: .4)),
          boxShadow: [
            BoxShadow(
              color: colorFor(agent).withValues(alpha: .07),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INTELIGÊNCIA DISPONÍVEL',
              style: TextStyle(
                color: colorFor(agent),
                letterSpacing: 1.8,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              agent.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: compact ? 24 : 32,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              agent.description?.trim().isNotEmpty ?? false
                  ? agent.description!
                  : 'Uma inteligência pronta para acompanhar suas perguntas e explorações.',
              maxLines: compact ? 4 : 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _soft, fontSize: 14, height: 1.6),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: () =>
                  Get.toNamed('/space/agents/${agent.id}', arguments: agent),
              icon: const Icon(Icons.forum_outlined, size: 19),
              label: const Text('Iniciar conversa'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sua conversa com este agente será retomada aqui.',
              style: TextStyle(color: _soft, fontSize: 11, height: 1.4),
            ),
          ],
        ),
      ),
    );
    if (compact) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 190, child: presence(agent)),
            details,
            const SizedBox(height: 10),
          ],
        ),
      );
    }
    return Row(
      children: [
        Expanded(flex: 6, child: presence(agent)),
        const SizedBox(width: 30),
        Expanded(flex: 5, child: SingleChildScrollView(child: details)),
      ],
    );
  }

  Widget conversation(bool compact) {
    final agent = selected!;
    final header = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          agent.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 20 : 27,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          sending ? 'Organizando uma resposta…' : 'Canal de conversa',
          style: TextStyle(
            color: colorFor(agent),
            fontSize: 11,
            letterSpacing: 1,
          ),
        ),
      ],
    );
    final chat = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xEE07111F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF324B65)),
      ),
      child: Column(
        children: [
          if (!compact)
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Icon(Icons.forum_outlined, color: colorFor(agent), size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'CONVERSA / ${agent.name}',
                      style: const TextStyle(
                        color: _light,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: historyLoading
                ? const Center(child: CircularProgressIndicator(color: _light))
                : historyFailed
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Não foi possível carregar a conversa.',
                          style: TextStyle(color: _soft),
                        ),
                        TextButton(
                          onPressed: loadHistory,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  )
                : messages.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: _light,
                            size: 32,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Uma nova conversa começa com uma pergunta.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _soft,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: messagesScroll,
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (historyMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == messages.length) {
                        return TextButton(
                          onPressed: olderLoading
                              ? null
                              : () => loadHistory(older: true),
                          child: Text(
                            olderLoading
                                ? 'Carregando…'
                                : 'Mensagens anteriores',
                          ),
                        );
                      }
                      final message = messages[messages.length - 1 - i];
                      return Align(
                        alignment: message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          constraints: const BoxConstraints(maxWidth: 650),
                          decoration: BoxDecoration(
                            color: message.isUser
                                ? const Color(0xFF243B53)
                                : const Color(0xFF101F30),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: message.isUser
                                  ? const Color(0xFF45617D)
                                  : const Color(0xFF263B51),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.isUser
                                    ? 'VOCÊ'
                                    : agent.name.toUpperCase(),
                                style: TextStyle(
                                  color: message.isUser
                                      ? _soft
                                      : colorFor(agent),
                                  fontSize: 9,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              MarkdownBody(
                                data: message.text,
                                selectable: true,
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(
                                    color: Color(0xFFE0E9F4),
                                    height: 1.6,
                                    fontSize: 14,
                                  ),
                                ),
                                onTapLink: (_, url, _) {
                                  if (url != null &&
                                      [
                                        'https',
                                        'http',
                                      ].contains(Uri.tryParse(url)?.scheme)) {
                                    launchUrlString(url);
                                  }
                                },
                              ),
                              if (message.fileUrl != null)
                                TextButton(
                                  onPressed: () {
                                    final url = message.fileUrl!;
                                    if ([
                                      'https',
                                      'http',
                                    ].contains(Uri.tryParse(url)?.scheme)) {
                                      launchUrlString(url);
                                    }
                                  },
                                  child: const Text('Abrir anexo'),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (sending) const LinearProgressIndicator(minHeight: 2),
          if (sendError != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                sendError!,
                style: const TextStyle(color: Color(0xFFFFC39F), fontSize: 12),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: draft,
                    readOnly: sending,
                    enabled: !historyLoading && !historyFailed,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Converse com ${agent.name}',
                      hintStyle: const TextStyle(color: _soft, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF122236),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  tooltip: 'Enviar mensagem',
                  onPressed: sending || historyLoading || historyFailed
                      ? null
                      : send,
                  icon: const Icon(Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (compact) {
      return Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                SizedBox(width: 80, child: presence(agent, small: true)),
                Expanded(child: header),
              ],
            ),
          ),
          Expanded(child: chat),
        ],
      );
    }
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              Expanded(child: presence(agent)),
              header,
              const SizedBox(height: 40),
            ],
          ),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 7, child: chat),
      ],
    );
  }
}

class _ChamberPainter extends CustomPainter {
  const _ChamberPainter(this.phase, this.dark);
  final double phase;
  final bool dark;
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-.3, -.3),
          radius: 1.15,
          colors: dark
              ? const [Color(0xFF14213D), _ink]
              : const [Color(0xFF223359), Color(0xFF070E20)],
        ).createShader(bounds),
    );
    final metal = Paint()
      ..color = const Color(0xFF25354C)
      ..strokeWidth = 1;
    final glow = Paint()
      ..color = const Color(0x665C93C8)
      ..strokeWidth = 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    final led = Paint()
      ..color = const Color(0xFF6EABC6)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    for (final side in [0.0, 1.0]) {
      final x = w * side;
      final inner = w * (side == 0 ? .11 : .89);
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(inner, h * .12)
        ..lineTo(inner, h * .76)
        ..lineTo(x, h)
        ..close();
      canvas.drawPath(path, Paint()..color = const Color(0xAA040B15));
      canvas.drawPath(path, metal..style = PaintingStyle.stroke);
      canvas.drawLine(Offset(x, h * .06), Offset(inner, h * .16), glow);
      canvas.drawLine(Offset(x, h * .06), Offset(inner, h * .16), led);
      canvas.drawLine(
        Offset(w * (side == 0 ? .04 : .96), h * .34),
        Offset(w * (side == 0 ? .065 : .935), h * .73),
        glow,
      );
    }
    final star = Paint();
    for (var i = 0; i < 28; i++) {
      final x = (.12 + ((math.sin(i * 39.3) + 1) / 2) * .76) * w;
      final y = (.16 + ((math.cos(i * 24.7) + 1) / 2) * .50) * h;
      star.color = Color.fromRGBO(
        142,
        183,
        238,
        .15 + .18 * (.5 + .5 * math.sin(phase + i)),
      );
      canvas.drawCircle(Offset(x, y), i % 4 == 0 ? 2 : 1, star);
      if (i % 3 == 0) {
        canvas.drawLine(
          Offset(x, y),
          Offset(w * .5, h * .38),
          Paint()..color = const Color(0x085EA2DA),
        );
      }
    }
    for (var i = -3; i <= 3; i++) {
      canvas.drawLine(
        Offset(w * .5 + i * w * .04, h * .76),
        Offset(w * .5 + i * w * .20, h),
        metal,
      );
    }
    for (final y in [.8, .88, .98]) {
      canvas.drawLine(Offset(0, h * y), Offset(w, h * y), metal);
    }
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .5, h * .08),
        width: w * .62,
        height: h * .13,
      ),
      led..color = const Color(0x665894BC),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .5, h * .08),
        width: w * .65,
        height: h * .15,
      ),
      metal,
    );
  }

  @override
  bool shouldRepaint(_ChamberPainter old) =>
      phase != old.phase || dark != old.dark;
}

class _PresencePainter extends CustomPainter {
  const _PresencePainter(
    this.phase,
    this.accent,
    this.responding,
    this.selectedId,
    this.agentIds,
  );
  final double phase;
  final Color accent;
  final bool responding;
  final int? selectedId;
  final List<int> agentIds;
  static const tint = Color(0xFF7EDCEB);
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .5, size.height * .43);
    final r = math.min(size.width * .33, size.height * .31);
    final glow = Paint()
      ..shader = RadialGradient(
        colors: [
          tint.withValues(alpha: .12),
          tint.withValues(alpha: .035),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: r * 1.6));
    canvas.drawCircle(center, r * 1.6, glow);
    final pen = Paint()
      ..color = tint.withValues(alpha: .5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    Offset point(double a, double b) {
      final x = math.cos(a) * math.cos(b);
      final y = math.sin(b);
      final z = math.sin(a) * math.cos(b);
      final xr = x * math.cos(phase) - z * math.sin(phase);
      final zr = x * math.sin(phase) + z * math.cos(phase);
      return center + Offset(xr * r, (y * .94 + zr * .18) * r);
    }

    for (var j = 0; j < 7; j++) {
      final path = Path();
      for (var i = 0; i <= 90; i++) {
        final p = point(j * math.pi / 3, i / 90 * math.pi * 2);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, pen..color = tint.withValues(alpha: .24));
    }
    for (final lat in [-.8, -.4, 0.0, .4, .8]) {
      final path = Path();
      for (var i = 0; i <= 90; i++) {
        final p = point(i / 90 * math.pi * 2, lat);
        if (i == 0) {
          path.moveTo(p.dx, p.dy);
        } else {
          path.lineTo(p.dx, p.dy);
        }
      }
      canvas.drawPath(path, pen..color = tint.withValues(alpha: .4));
    }
    for (var orbit = 0; orbit < 3; orbit++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(orbit * 1.1 + phase * .10);
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: r * 2.7, height: r * .65),
        pen..color = tint.withValues(alpha: .38),
      );
      // Real agent IDs keep their own orbit/position across selection and paging.
      // Dim anonymous points complete the field when only a few agents exist.
      final nodes = [...agentIds];
      for (var i = 0; nodes.length < 9; i++) {
        nodes.add(-i - 1);
      }
      for (final id in nodes.where((id) => id.abs() % 3 == orbit)) {
        final a = phase * (orbit.isEven ? 1 : -1) + id * 2.399963229728653;
        final p = Offset(math.cos(a) * r * 1.35, math.sin(a) * r * .325);
        final active = id == selectedId;
        final pulse = .5 + .5 * math.sin(phase * 16);
        final nodeColor = active ? accent : tint;
        if (active) {
          canvas.drawCircle(
            p,
            15 + pulse * 5 + (responding ? 3 : 0),
            Paint()
              ..color = nodeColor.withValues(alpha: .22 + pulse * .12)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
          );
          canvas.drawCircle(
            p,
            8 + pulse * 3,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.1
              ..color = nodeColor.withValues(alpha: .55 + pulse * .3),
          );
        }
        canvas.drawCircle(
          p,
          active ? 5 : 3.3,
          Paint()
            ..color = nodeColor.withValues(alpha: active ? 1 : .65)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
        canvas.drawCircle(
          p,
          active ? 3.2 : 1.5,
          Paint()..color = active ? Colors.white : tint.withValues(alpha: .8),
        );
      }
      canvas.restore();
    }
    final base = Offset(
      center.dx,
      math.min(size.height * .81, center.dy + r * 1.38),
    );
    canvas.drawOval(
      Rect.fromCenter(center: base, width: r * 1.7, height: r * .25),
      Paint()
        ..shader =
            RadialGradient(
              colors: [tint.withValues(alpha: .2), Colors.transparent],
            ).createShader(
              Rect.fromCenter(center: base, width: r * 1.7, height: r * .25),
            ),
    );
    canvas.drawOval(
      Rect.fromCenter(center: base, width: r * 1.65, height: r * .23),
      pen..color = tint.withValues(alpha: .7),
    );
    canvas.drawOval(
      Rect.fromCenter(center: base, width: r * 2, height: r * .34),
      pen..color = tint.withValues(alpha: .22),
    );
    final beam = Path()
      ..moveTo(base.dx - r * .7, base.dy)
      ..lineTo(center.dx - r * .36, center.dy + r * .8)
      ..lineTo(center.dx + r * .36, center.dy + r * .8)
      ..lineTo(base.dx + r * .7, base.dy)
      ..close();
    canvas.drawPath(beam, Paint()..color = tint.withValues(alpha: .025));
  }

  @override
  bool shouldRepaint(_PresencePainter old) =>
      phase != old.phase ||
      accent != old.accent ||
      responding != old.responding ||
      selectedId != old.selectedId ||
      !listEquals(agentIds, old.agentIds);
}
