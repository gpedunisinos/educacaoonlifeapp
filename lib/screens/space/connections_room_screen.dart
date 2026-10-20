import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/connection_type_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/clue_connection_webclient.dart';
import 'package:unisinos_usp_app/webclients/connection_type_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';

const _ice = Color(0xFF9CE7ED);
const _muted = Color(0xFF9BB9C7);

class RoomConnection {
  const RoomConnection(this.model, this.source, this.target, this.type);
  final ClueConnectionModel model;
  final String source;
  final String target;
  final String type;
}

/// Pilot ship interior. Uses real platform data; exploration stays on the wall screen.
class ConnectionsRoomScreen extends StatefulWidget {
  const ConnectionsRoomScreen({super.key, this.loader});
  final Future<List<RoomConnection>> Function()? loader;
  @override
  State<ConnectionsRoomScreen> createState() => _ConnectionsRoomScreenState();
}

class _ConnectionsRoomScreenState extends State<ConnectionsRoomScreen> {
  List<RoomConnection> items = [];
  RoomConnection? selected;
  bool loading = true;
  bool failed = false;
  String query = '';
  final search = TextEditingController();
  late final AiAssistantContextProvider contextProvider = buildContext;
  AiAssistantScreenContext buildContext() => AiAssistantScreenContext(
    screenName: 'Sala de Conexões da nave',
    route: '/space/connections',
    stage: 'exploração de conexões',
    goal: 'explorar vínculos entre pistas na tela da sala',
    filledFields: {
      'busca': query,
      if (selected != null)
        'conexão selecionada': '${selected!.source} → ${selected!.target}',
      'conexões carregadas': items.length.toString(),
    },
    notes: const [
      'Piloto de ambiente interno da nave. A lista e os detalhes usam dados reais da plataforma.',
    ],
  );
  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().registerProvider(
        '/space/connections',
        contextProvider,
      );
    }
    load();
  }

  Future<List<RoomConnection>> fetch() async {
    final results = await Future.wait([
      ClueConnectionWebclient().fetch(),
      LivingClueWebclient().fetch(),
      ConnectionTypeWebclient().fetch(),
    ]);
    final clues = {
      for (final c in results[1] as List<LivingClueModel>) c.id: c.name,
    };
    final types = {
      for (final t in results[2] as List<ConnectionTypeModel>) t.id: t.name,
    };
    return (results[0] as List<ClueConnectionModel>)
        .map(
          (c) => RoomConnection(
            c,
            c.sourceClue?.name ??
                clues[c.sourceClueId] ??
                'Pista #${c.sourceClueId}',
            c.targetClue?.name ??
                clues[c.targetClueId] ??
                'Pista #${c.targetClueId}',
            c.connectionType?.name ??
                types[c.connectionTypeId] ??
                'Tipo #${c.connectionTypeId}',
          ),
        )
        .toList();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      failed = false;
    });
    try {
      final result = await (widget.loader?.call() ?? fetch());
      if (!mounted) return;
      setState(() {
        items = result;
        selected = result.isEmpty ? null : result.first;
        loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          loading = false;
          failed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(
        '/space/connections',
        contextProvider,
      );
    }
    search.dispose();
    super.dispose();
  }

  void leave() {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed('/space');
    }
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _ice,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF030811),
    ),
    child: Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final low = constraints.maxHeight < 600;
          final filtered = items
              .where(
                (c) =>
                    '${c.source} ${c.target} ${c.type} ${c.model.evidence ?? ''}'
                        .toLowerCase()
                        .contains(query.toLowerCase()),
              )
              .toList();
          final visibleSelection = filtered.isEmpty
              ? null
              : filtered.firstWhere(
                  (c) => c.model.id == selected?.model.id,
                  orElse: () => filtered.first,
                );
          return Stack(
            children: [
              const Positioned.fill(
                child: CustomPaint(painter: _RoomPainter()),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        compact ? 12 : 28,
                        12,
                        compact ? 12 : 28,
                        8,
                      ),
                      child: Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: leave,
                            icon: const Icon(Icons.arrow_back, size: 17),
                            label: Text(
                              compact ? 'Cockpit' : 'Voltar ao cockpit',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              compact
                                  ? 'SALA DE CONEXÕES'
                                  : 'EC–01  /  DECK 02  /  SALA DE CONEXÕES',
                              style: TextStyle(
                                color: _ice,
                                letterSpacing: compact ? 1 : 2,
                                fontSize: compact ? 9 : 11,
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          compact ? 12 : constraints.maxWidth * .10,
                          low ? 8 : 24,
                          compact ? 12 : constraints.maxWidth * .10,
                          compact || low ? 20 : constraints.maxHeight * .15,
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(
                            begin: MediaQuery.disableAnimationsOf(context)
                                ? 1
                                : 0,
                            end: 1,
                          ),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) => Opacity(
                            opacity: value,
                            child: Transform.scale(
                              scale: .97 + value * .03,
                              child: child,
                            ),
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF061521),
                              borderRadius: BorderRadius.circular(9),
                              border: Border.all(
                                color: const Color(0xFF4C7887),
                                width: 3,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x9923A8C9),
                                  blurRadius: 35,
                                  spreadRadius: -14,
                                ),
                                BoxShadow(blurRadius: 8, spreadRadius: 7),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(compact ? 12 : 20),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Color(0xFF234657),
                                        ),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF143241),
                                          Color(0xFF071622),
                                        ],
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.hub_outlined,
                                          color: _ice,
                                          size: 27,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Conexões',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: compact ? 22 : 30,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                              const Text(
                                                'Explore os vínculos entre as pistas.',
                                                style: TextStyle(
                                                  color: _muted,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          tooltip: 'Atualizar conexões',
                                          onPressed: loading ? null : load,
                                          icon: const Icon(
                                            Icons.refresh,
                                            color: _ice,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      12,
                                      16,
                                      12,
                                    ),
                                    child: TextField(
                                      controller: search,
                                      onChanged: (v) =>
                                          setState(() => query = v),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText:
                                            'Buscar pistas, tipos ou evidências',
                                        hintStyle: const TextStyle(
                                          color: _muted,
                                          fontSize: 13,
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: _ice,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFF0B202D),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF2A5668),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: loading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: _ice,
                                            ),
                                          )
                                        : failed
                                        ? Center(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Não foi possível carregar as conexões.',
                                                  style: TextStyle(
                                                    color: _muted,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                OutlinedButton(
                                                  onPressed: load,
                                                  child: const Text(
                                                    'Tentar novamente',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : items.isEmpty
                                        ? const _EmptyRoom(
                                            text: 'Nenhuma conexão cadastrada.',
                                            icon: Icons.hub_outlined,
                                          )
                                        : filtered.isEmpty
                                        ? const _EmptyRoom(
                                            text:
                                                'Nenhuma conexão encontrada para essa busca.',
                                            icon: Icons.search_off,
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: ListView.separated(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                        16,
                                                        0,
                                                        16,
                                                        16,
                                                      ),
                                                  itemCount: filtered.length,
                                                  separatorBuilder: (_, _) =>
                                                      const SizedBox(height: 8),
                                                  itemBuilder: (context, index) {
                                                    final c = filtered[index];
                                                    final active =
                                                        selected?.model.id ==
                                                        filtered[index]
                                                            .model
                                                            .id;
                                                    return Material(
                                                      color: active
                                                          ? const Color(
                                                              0xFF173848,
                                                            )
                                                          : const Color(
                                                              0xFF0B202D,
                                                            ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                        side: BorderSide(
                                                          color: active
                                                              ? _ice
                                                              : const Color(
                                                                  0xFF254656,
                                                                ),
                                                        ),
                                                      ),
                                                      child: InkWell(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              5,
                                                            ),
                                                        onTap: () {
                                                          setState(
                                                            () => selected = c,
                                                          );
                                                          if (compact) {
                                                            showModalBottomSheet<
                                                              void
                                                            >(
                                                              context: context,
                                                              backgroundColor:
                                                                  const Color(
                                                                    0xFF0A1B28,
                                                                  ),
                                                              isScrollControlled:
                                                                  true,
                                                              showDragHandle:
                                                                  true,
                                                              builder: (_) => SafeArea(
                                                                child: SizedBox(
                                                                  height:
                                                                      MediaQuery.sizeOf(
                                                                        context,
                                                                      ).height *
                                                                      .6,
                                                                  child: SingleChildScrollView(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          24,
                                                                        ),
                                                                    child: _ConnectionDetail(
                                                                      connection:
                                                                          c,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                14,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                c.type
                                                                    .toUpperCase(),
                                                                style: const TextStyle(
                                                                  color: _ice,
                                                                  fontSize: 10,
                                                                  letterSpacing:
                                                                      1.2,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Text(
                                                                '${c.source} → ${c.target}',
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15,
                                                                  height: 1.4,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 8,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    'Força ${c.model.strength}',
                                                                    style: const TextStyle(
                                                                      color:
                                                                          _muted,
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                  const Spacer(),
                                                                  const Icon(
                                                                    Icons
                                                                        .chevron_right,
                                                                    color: _ice,
                                                                    size: 18,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              if (!compact &&
                                                  visibleSelection != null)
                                                SizedBox(
                                                  width:
                                                      constraints.maxWidth *
                                                      .27,
                                                  child: DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                          border: Border(
                                                            left: BorderSide(
                                                              color: Color(
                                                                0xFF254656,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                    child: SingleChildScrollView(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            22,
                                                          ),
                                                      child: AnimatedSwitcher(
                                                        duration: Duration(
                                                          milliseconds:
                                                              MediaQuery.disableAnimationsOf(
                                                                context,
                                                              )
                                                              ? 0
                                                              : 250,
                                                        ),
                                                        child: _ConnectionDetail(
                                                          key: ValueKey(
                                                            selected!.model.id,
                                                          ),
                                                          connection:
                                                              visibleSelection,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 9,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Color(0xFF234657),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          size: 5,
                                          color: _ice,
                                        ),
                                        const SizedBox(width: 7),
                                        const Text(
                                          'REDE DE CONEXÕES',
                                          style: TextStyle(
                                            color: _muted,
                                            fontSize: 8,
                                            letterSpacing: 1.3,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          loading
                                              ? 'CARREGANDO'
                                              : failed
                                              ? 'CONEXÃO INDISPONÍVEL'
                                              : '${filtered.length} / ${items.length} CONEXÕES',
                                          style: const TextStyle(
                                            color: _ice,
                                            fontSize: 9,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!compact && !low)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 25),
                        child: Text(
                          'IARETÉ  /  Cada vínculo revela uma nova perspectiva.',
                          style: TextStyle(
                            color: _muted,
                            fontSize: 11,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _EmptyRoom extends StatelessWidget {
  const _EmptyRoom({required this.text, required this.icon});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _ice, size: 44),
          const SizedBox(height: 20),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _muted),
          ),
        ],
      ),
    ),
  );
}

class _ConnectionDetail extends StatelessWidget {
  const _ConnectionDetail({super.key, required this.connection});
  final RoomConnection connection;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'VÍNCULO SELECIONADO',
        style: TextStyle(color: _ice, letterSpacing: 1.6, fontSize: 10),
      ),
      const SizedBox(height: 24),
      Text(
        connection.source,
        style: const TextStyle(
          fontSize: 21,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 14),
        child: Icon(Icons.south, color: _ice),
      ),
      Text(
        connection.target,
        style: const TextStyle(
          fontSize: 21,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
      ),
      const SizedBox(height: 24),
      const Divider(color: Color(0xFF2A5668)),
      const SizedBox(height: 12),
      Text(connection.type, style: const TextStyle(color: _ice, fontSize: 14)),
      const SizedBox(height: 8),
      Text(
        'Força da conexão: ${connection.model.strength}',
        style: const TextStyle(color: _muted, fontSize: 13),
      ),
      const SizedBox(height: 24),
      const Text(
        'EVIDÊNCIA',
        style: TextStyle(color: _ice, letterSpacing: 1, fontSize: 10),
      ),
      const SizedBox(height: 10),
      SelectableText(
        connection.model.evidence?.trim().isNotEmpty ?? false
            ? connection.model.evidence!
            : 'Nenhuma evidência informada.',
        style: const TextStyle(color: _muted, height: 1.6, fontSize: 13),
      ),
    ],
  );
}

/// Perspective room shell remains behind the interactive wall display.
class _RoomPainter extends CustomPainter {
  const _RoomPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final bounds = Offset.zero & size;
    canvas.drawRect(
      bounds,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -.35),
          radius: 1.1,
          colors: [Color(0xFF203A49), Color(0xFF02060D)],
        ).createShader(bounds),
    );
    final seams = Paint()
      ..color = const Color(0xFF263C4B)
      ..strokeWidth = 2;
    final light = Paint()
      ..color = const Color(0xFF72D6E6)
      ..strokeWidth = 2;
    final glow = Paint()
      ..color = const Color(0x665CD4F3)
      ..strokeWidth = 5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
    void line(Offset a, Offset b, Paint p) => canvas.drawLine(a, b, p);
    final ceiling = Path()
      ..moveTo(0, 0)
      ..lineTo(w, 0)
      ..lineTo(w * .88, h * .13)
      ..lineTo(w * .12, h * .13)
      ..close();
    canvas.drawPath(ceiling, Paint()..color = const Color(0xFF08111C));
    for (final side in [0.0, 1.0]) {
      final outer = w * side;
      final inner = w * (side == 0 ? .12 : .88);
      final wall = Path()
        ..moveTo(outer, 0)
        ..lineTo(inner, h * .13)
        ..lineTo(inner, h * .78)
        ..lineTo(outer, h)
        ..close();
      canvas.drawPath(
        wall,
        Paint()
          ..shader = LinearGradient(
            begin: side == 0 ? Alignment.centerLeft : Alignment.centerRight,
            end: side == 0 ? Alignment.centerRight : Alignment.centerLeft,
            colors: const [Color(0xFF040A12), Color(0xFF1A2C39)],
          ).createShader(bounds),
      );
      final console = Rect.fromLTWH(
        w * (side == 0 ? .015 : .925),
        h * .48,
        w * .06,
        h * .18,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(console, const Radius.circular(3)),
        Paint()..color = const Color(0xFF06101A),
      );
      for (var slot = 0; slot < 4; slot++) {
        canvas.drawRect(
          Rect.fromLTWH(
            console.left + w * .008,
            console.top + h * (.03 + slot * .028),
            w * (slot.isEven ? .036 : .025),
            2,
          ),
          Paint()..color = const Color(0xFF4F9CAA),
        );
      }
      line(Offset(outer, 0), Offset(inner, h * .13), seams);
      line(Offset(outer, h), Offset(inner, h * .78), seams);
      line(Offset(inner, h * .13), Offset(inner, h * .78), seams);
      final a = Offset(w * (side == 0 ? .035 : .965), h * .20);
      final b = Offset(w * (side == 0 ? .055 : .945), h * .69);
      line(a, b, glow);
      line(a, b, light);
      for (var i = 0; i < 6; i++) {
        final y = h * (.26 + i * .065);
        line(
          Offset(w * (side == 0 ? .015 : .985), y),
          Offset(w * (side == 0 ? .07 : .93), y + 10),
          seams,
        );
      }
    }
    for (var i = -3; i <= 3; i++) {
      line(
        Offset(w * .5 + i * w * .035, h * .77),
        Offset(w * .5 + i * w * .20, h),
        seams,
      );
    }
    for (final y in [.80, .88, .98]) {
      line(Offset(0, h * y), Offset(w, h * y), seams);
    }
    line(Offset(w * .20, h * .055), Offset(w * .80, h * .055), glow);
    line(Offset(w * .20, h * .055), Offset(w * .80, h * .055), light);
    final table = Path()
      ..moveTo(w * .31, h * .97)
      ..lineTo(w * .40, h * .85)
      ..lineTo(w * .60, h * .85)
      ..lineTo(w * .69, h * .97)
      ..close();
    canvas.drawPath(table, Paint()..color = const Color(0xFF0C1C28));
    canvas.drawPath(
      table,
      Paint()
        ..color = const Color(0xFF315C70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * .5, h * .88),
        width: w * .10,
        height: h * .025,
      ),
      Paint()
        ..color = const Color(0x5569D8E7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_RoomPainter oldDelegate) => false;
}
