import 'package:unisinos_usp_app/screens/management/management_shell.dart';
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
  const ConnectionsRoomScreen({
    super.key,
    this.loader,
    this.management = false,
    this.connectionId,
    this.initialConnection,
  });
  final bool management;
  final int? connectionId;
  final RoomConnection? initialConnection;
  final Future<List<RoomConnection>> Function()? loader;
  @override
  State<ConnectionsRoomScreen> createState() => _ConnectionsRoomScreenState();
}

class _ConnectionsRoomScreenState extends State<ConnectionsRoomScreen> {
  List<RoomConnection> items = [];
  bool get isDetail => widget.connectionId != null;
  String get baseRoute =>
      widget.management ? '/management/connections' : '/space/connections';
  String get route =>
      isDetail ? '$baseRoute/${widget.connectionId}' : baseRoute;
  final listScroll = ScrollController();
  bool loading = true;
  bool failed = false;
  String query = '';
  final search = TextEditingController();
  late final AiAssistantContextProvider contextProvider = buildContext;
  AiAssistantScreenContext buildContext() => AiAssistantScreenContext(
    screenName: widget.management
        ? 'Central de Gestão / Conexões'
        : 'Sala de Conexões da nave',
    route: route,
    stage: 'exploração de conexões',
    goal: 'explorar vínculos entre pistas na tela da sala',
    filledFields: {
      'busca': query,
      if (isDetail && items.isNotEmpty)
        'conexão visualizada': '${items.first.source} → ${items.first.target}',
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
        route,
        contextProvider,
      );
    }
    final initial = widget.initialConnection;
    if (isDetail && initial?.model.id == widget.connectionId) {
      items = [initial!];
      loading = false;
    } else {
      load();
    }
  }

  Future<List<RoomConnection>> fetch() async {
    final results = await Future.wait([
      isDetail
          ? ClueConnectionWebclient()
                .fetchById(widget.connectionId!)
                .then((c) => [c])
          : ClueConnectionWebclient().fetch(),
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
        route,
        contextProvider,
      );
    }
    listScroll.dispose();
    search.dispose();
    super.dispose();
  }

  void leave() {
    if (Navigator.of(context).canPop()) {
      Get.back();
    } else {
      Get.offNamed(
        isDetail
            ? baseRoute
            : widget.management
            ? '/management'
            : '/space',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = items
        .where(
          (c) => '${c.source} ${c.target} ${c.type} ${c.model.evidence ?? ''}'
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();
    return _RoomShell(
      management: widget.management,
      title: isDetail ? 'Detalhes da conexão' : 'Conexões',
      subtitle: isDetail
          ? 'Os vínculos que conectam nossos territórios.'
          : 'Explore os vínculos entre as pistas.',
      backLabel: isDetail
          ? 'Voltar à lista'
          : widget.management
          ? 'Central de Gestão'
          : 'Voltar ao cockpit',
      onBack: leave,
      onRefresh: loading ? null : load,
      status: loading
          ? 'CARREGANDO'
          : failed
          ? 'CONEXÃO INDISPONÍVEL'
          : isDetail
          ? 'CONEXÃO #${widget.connectionId}'
          : '${filtered.length} / ${items.length} CONEXÕES',
      child: Column(
        children: [
          if (!isDetail)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: TextField(
                controller: search,
                onChanged: (v) => setState(() => query = v),
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Buscar pistas, tipos ou evidências',
                  hintStyle: const TextStyle(color: _muted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: _ice),
                  filled: true,
                  fillColor: const Color(0xFF0B202D),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(color: Color(0xFF2A5668)),
                  ),
                ),
              ),
            ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator(color: _ice))
                : failed
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isDetail
                                ? 'Não foi possível carregar a conexão.'
                                : 'Não foi possível carregar as conexões.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: _muted),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton(
                            onPressed: load,
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    ),
                  )
                : items.isEmpty
                ? _EmptyRoom(
                    text: isDetail
                        ? 'Conexão não encontrada.'
                        : 'Nenhuma conexão cadastrada.',
                    icon: Icons.hub_outlined,
                  )
                : isDetail
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 900),
                        child: _ConnectionDetail(connection: items.first),
                      ),
                    ),
                  )
                : filtered.isEmpty
                ? const _EmptyRoom(
                    text: 'Nenhuma conexão encontrada para essa busca.',
                    icon: Icons.search_off,
                  )
                : ListView.separated(
                    controller: listScroll,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final c = filtered[index];
                      return Material(
                        color: const Color(0xFF0B202D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: const BorderSide(color: Color(0xFF254656)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => Get.toNamed(
                            '$baseRoute/${c.model.id}',
                            arguments: c,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c.type.toUpperCase(),
                                  style: const TextStyle(
                                    color: _ice,
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${c.source} → ${c.target}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Força ${c.model.strength}',
                                      style: const TextStyle(
                                        color: _muted,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.chevron_right,
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
        ],
      ),
    );
  }
}

/// Both routes occupy the same ship room and wall display.
class _RoomShell extends StatelessWidget {
  const _RoomShell({
    this.management = false,
    required this.title,
    required this.subtitle,
    required this.backLabel,
    required this.onBack,
    required this.onRefresh,
    required this.status,
    required this.child,
  });
  final bool management;
  final String title;
  final String subtitle;
  final String backLabel;
  final String status;
  final VoidCallback onBack;
  final VoidCallback? onRefresh;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    if (management) {
      return ManagementShell(
        title: title,
        subtitle: subtitle,
        connections: true,
        onBack: onBack,
        backLabel: backLabel,
        onRefresh: onRefresh,
        status: status,
        child: child,
      );
    }
    return Theme(
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
                              onPressed: onBack,
                              icon: const Icon(Icons.arrow_back, size: 17),
                              label: Text(backLabel),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                compact
                                    ? 'SALA DE CONEXÕES'
                                    : 'EC–01  /  DECK 02  /  SALA DE CONEXÕES',
                                textAlign: TextAlign.right,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: _ice,
                                  letterSpacing: compact ? 1 : 2,
                                  fontSize: compact ? 9 : 11,
                                ),
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
                                      padding: EdgeInsets.all(
                                        compact ? 12 : 20,
                                      ),
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
                                                  title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: compact ? 22 : 30,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                                Text(
                                                  subtitle,
                                                  style: const TextStyle(
                                                    color: _muted,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: 'Atualizar conexões',
                                            onPressed: onRefresh,
                                            icon: const Icon(
                                              Icons.refresh,
                                              color: _ice,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(child: child),
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
                                          const Flexible(
                                            child: Text(
                                              'REDE DE CONEXÕES',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: _muted,
                                                fontSize: 8,
                                                letterSpacing: 1.3,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            status,
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
                            'IAraeté  /  Cada vínculo revela uma nova perspectiva.',
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
  const _ConnectionDetail({required this.connection});
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
