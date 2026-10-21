import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/policies/living_clue_policy.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:unisinos_usp_app/screens/space/research_room_painter.dart';
import 'package:unisinos_usp_app/screens/space/clue_moon_hologram.dart';

const _ice = Color(0xFF9CE7DF);
const _muted = Color(0xFFA1B8C7);

class ClueResearchSource {
  Future<LivingClueModel> clue(int id) => LivingClueWebclient().fetchById(id);
  Future<List<LivingClueModel>> search(String query, int offset) =>
      LivingClueWebclient().search(search: query, offset: offset, limit: 20);
}

class ClueResearchRoomScreen extends StatefulWidget {
  const ClueResearchRoomScreen({super.key, this.source});
  final ClueResearchSource? source;
  @override
  State<ClueResearchRoomScreen> createState() => _ClueResearchRoomScreenState();
}

class _ClueResearchRoomScreenState extends State<ClueResearchRoomScreen>
    with SingleTickerProviderStateMixin {
  late final source = widget.source ?? ClueResearchSource();
  late final motion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 28),
  );
  final search = TextEditingController();
  final listScroll = ScrollController();
  final slots = <int, int>{};
  List<LivingClueModel> clues = [];
  LivingClueModel? selected;
  bool loading = true;
  bool failed = false;
  bool more = false;
  bool loadingMore = false;
  bool creating = false;
  String get route => '/space/research';
  int request = 0;
  Timer? debounce;
  late final AiAssistantContextProvider provider = buildContext;
  AiAssistantScreenContext buildContext() => AiAssistantScreenContext(
    screenName: 'Sala da Lua de Pistas',
    route: route,
    references: {if (selected != null) 'living_clue_id': selected!.id},
    visibleRecords: clues
        .take(20)
        .map(
          (clue) => AiRecordReference(
            kind: 'living_clue',
            id: clue.id,
            name: clue.name,
          ),
        )
        .toList(),
    stage: 'busca de pistas',
    goal: 'pesquisar pistas e localizar sua representação na lua holográfica',
    filledFields: {
      'busca': search.text,
      if (selected != null) 'pista selecionada': selected!.name,
    },
    notes: const [
      'A lista usa pistas reais. A lua é uma representação visual dos cards.',
    ],
  );
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().registerProvider(route, provider);
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

  void changed(String value) {
    debounce?.cancel();
    request++;
    setState(() {
      loading = true;
      failed = false;
      loadingMore = false;
    });
    debounce = Timer(const Duration(milliseconds: 300), load);
  }

  Future<void> load({bool next = false}) async {
    if (next && (loading || loadingMore || !more)) return;
    final ticket = next ? request : ++request;
    final query = search.text.trim();
    setState(() {
      if (next) {
        loadingMore = true;
      } else {
        loading = true;
        failed = false;
        loadingMore = false;
      }
    });
    try {
      final result = await source.search(query, next ? clues.length : 0);
      if (!mounted || ticket != request) return;
      setState(() {
        if (next) {
          clues = [...clues, ...result];
        } else {
          clues = result;
        }
        for (final clue in result) {
          // Assign a stable visible band slot for every clue encountered in this room.
          slots.putIfAbsent(clue.id, () => 34 + (slots.length * 7 % 68));
        }
        final matches = clues.where((clue) => clue.id == selected?.id);
        selected = matches.isNotEmpty
            ? matches.first
            : clues.isEmpty
            ? null
            : clues.first;
        more = result.length == 20;
        loading = false;
      });
    } catch (_) {
      if (!mounted || ticket != request) return;
      if (next) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível carregar mais pistas. Tente novamente.',
            ),
          ),
        );
      } else {
        setState(() {
          failed = true;
          loading = false;
        });
      }
    } finally {
      if (mounted && ticket == request) setState(() => loadingMore = false);
    }
  }

  Future<void> openClue(LivingClueModel clue) async {
    setState(() => selected = clue);
    motion.stop();
    await Get.toNamed('/space/research/${clue.id}', arguments: clue);
    if (mounted && !MediaQuery.disableAnimationsOf(context)) motion.repeat();
  }

  Future<void> createClue() async {
    if (creating) return;
    setState(() => creating = true);
    motion.stop();
    try {
      await Get.toNamed('/living_clues/type_select');
      if (mounted) await load();
    } finally {
      if (mounted) {
        setState(() => creating = false);
        if (!MediaQuery.disableAnimationsOf(context)) motion.repeat();
      }
    }
  }

  void leave() {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed('/space');
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(route, provider);
    }
    debounce?.cancel();
    search.dispose();
    listScroll.dispose();
    motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData.dark(
      useMaterial3: true,
    ).copyWith(scaffoldBackgroundColor: const Color(0xFF050C18)),
    child: LayoutBuilder(
      builder: (context, box) {
        final compact = box.maxWidth < 850;
        final projection = moon(compact);
        final keyboard = MediaQuery.viewInsetsOf(context).bottom;
        final projectionHeight = math.min(
          210.0,
          math.max(100.0, (box.maxHeight - keyboard) * .27),
        );
        return Scaffold(
          body: Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: ResearchRoomPainter()),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 16 : 42,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          OutlinedButton.icon(
                            style: compact
                                ? OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    textStyle: const TextStyle(fontSize: 12),
                                  )
                                : null,
                            onPressed: leave,
                            icon: const Icon(Icons.arrow_back, size: 17),
                            label: Text(
                              compact ? 'Cockpit' : 'Voltar ao cockpit',
                            ),
                          ),
                          if (Get.isRegistered<UserController>())
                            Obx(
                              () =>
                                  LivingCluePolicy(
                                    Get.find<UserController>().user.value,
                                  ).create()
                                  ? Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: FilledButton.icon(
                                        onPressed: creating ? null : createClue,
                                        icon: const Icon(Icons.add, size: 18),
                                        label: Text(
                                          compact
                                              ? 'Nova pista'
                                              : 'Criar pista',
                                        ),
                                        style: FilledButton.styleFrom(
                                          padding: compact
                                              ? const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                )
                                              : null,
                                          textStyle: compact
                                              ? const TextStyle(fontSize: 12)
                                              : null,
                                          backgroundColor: _ice,
                                          foregroundColor: const Color(
                                            0xFF09202A,
                                          ),
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          if (!compact) const SizedBox(width: 12),
                          if (!compact)
                            const Expanded(
                              child: Text(
                                'EC–01 / LUA DE PISTAS',
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _ice,
                                  fontSize: 10,
                                  letterSpacing: 1.6,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: compact ? 12 : 22,
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Cada pista, um novo olhar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: compact ? 25 : 36,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Explore o arquivo e encontre seu lugar na Lua de Pistas.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: TextField(
                          controller: search,
                          onChanged: changed,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) {
                            debounce?.cancel();
                            load();
                          },
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Buscar pistas por nome ou descrição',
                            prefixIcon: const Icon(Icons.search, color: _ice),
                            suffixIcon: search.text.isEmpty
                                ? null
                                : IconButton(
                                    tooltip: 'Limpar busca',
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      search.clear();
                                      changed('');
                                    },
                                  ),
                            filled: true,
                            fillColor: const Color(0xE60A1B2B),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: compact
                            ? Column(
                                children: [
                                  SizedBox(
                                    height: projectionHeight,
                                    child: projection,
                                  ),
                                  const SizedBox(height: 12),
                                  Expanded(child: screen()),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(flex: 5, child: screen()),
                                  const SizedBox(width: 28),
                                  Expanded(flex: 6, child: projection),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );

  Widget screen() => Container(
    decoration: BoxDecoration(
      color: const Color(0xE6091725),
      border: Border.all(color: const Color(0xFF2F5661)),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x2224D3BF), blurRadius: 30)],
    ),
    clipBehavior: Clip.antiAlias,
    child: loading
        ? const Center(child: CircularProgressIndicator(color: _ice))
        : failed
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Não foi possível pesquisar as pistas.'),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: load,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          )
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.view_list_outlined, color: _ice, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${clues.length} pistas carregadas${more ? ' · há mais resultados' : ''}',
                        style: const TextStyle(color: _muted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFF23404C)),
              Expanded(
                child: clues.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Nenhuma pista encontrada. Experimente outra busca.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        controller: listScroll,
                        padding: const EdgeInsets.all(10),
                        itemCount: clues.length + (more ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 7),
                        itemBuilder: (_, index) {
                          if (index == clues.length) {
                            return OutlinedButton(
                              onPressed: loadingMore
                                  ? null
                                  : () => load(next: true),
                              child: Text(
                                loadingMore ? 'Carregando…' : 'Mais pistas',
                              ),
                            );
                          }
                          final clue = clues[index];
                          final active = selected?.id == clue.id;
                          return Material(
                            color: active
                                ? const Color(0xFF213B40)
                                : const Color(0xFF0B1B2B),
                            borderRadius: BorderRadius.circular(9),
                            child: InkWell(
                              onTap: () => setState(() => selected = clue),
                              borderRadius: BorderRadius.circular(9),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                    color: active
                                        ? _ice
                                        : const Color(0xFF243B4C),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      color: active
                                          ? const Color(0xFFFFDF9B)
                                          : _ice,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            clue.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          if (clue.description
                                                  ?.trim()
                                                  .isNotEmpty ??
                                              false) ...[
                                            const SizedBox(height: 5),
                                            Text(
                                              clue.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: _muted,
                                                fontSize: 12,
                                                height: 1.5,
                                              ),
                                            ),
                                          ],
                                          const SizedBox(height: 6),
                                          Text(
                                            'PISTA #${clue.id}${clue.category == null ? '' : ' · ${clue.category!.name}'}',
                                            style: const TextStyle(
                                              color: _ice,
                                              fontSize: 10,
                                              letterSpacing: .6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    IconButton(
                                      tooltip: 'Abrir pista ${clue.id}',
                                      icon: const Icon(
                                        Icons.open_in_full,
                                        size: 18,
                                      ),
                                      onPressed: () => openClue(clue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
  );

  Widget moon(bool compact) => Column(
    children: [
      Expanded(
        child: AnimatedBuilder(
          animation: motion,
          builder: (context, _) => ClueMoonHologram(
            phase: motion.value * math.pi * 2,
            slot: loading || failed || selected == null
                ? null
                : slots[selected!.id],
            title: selected?.name ?? '',
            reduced: MediaQuery.disableAnimationsOf(context),
          ),
        ),
      ),
      if (!loading && !failed && selected != null)
        Padding(
          padding: EdgeInsets.only(top: compact ? 4 : 16, bottom: 12),
          child: Column(
            children: [
              Text(
                selected!.name,
                textAlign: TextAlign.center,
                maxLines: compact ? 1 : 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 16 : 23,
                  fontWeight: FontWeight.w300,
                ),
              ),
              ...[
                const SizedBox(height: 10),
                FilledButton.icon(
                  onPressed: () => openClue(selected!),
                  icon: const Icon(Icons.open_in_new, size: 17),
                  label: const Text('Abrir pista'),
                ),
              ],
            ],
          ),
        ),
    ],
  );
}
