import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueMapScreen extends StatefulWidget {
  const LivingClueMapScreen({super.key});

  @override
  State<LivingClueMapScreen> createState() => _LivingClueMapScreenState();
}

class _LivingClueMapScreenState extends State<LivingClueMapScreen>
    with SingleTickerProviderStateMixin {
  static const String _screenName = 'Mapa de pistas';
  static const String _tutorialSeenKey = 'living_clue_map_tutorial_seen';
  static const Color _sonarBlue = Color(0xFF0D47A1);
  final LivingClueMapController _controller =
      Get.find<LivingClueMapController>();
  final MapController _mapController = MapController();
  final GlobalKey _mapKey = GlobalKey();
  final GlobalKey _sonarControlsKey = GlobalKey();
  final GlobalKey _useLocationKey = GlobalKey();
  final GlobalKey _refreshKey = GlobalKey();
  final GlobalKey _repositionKey = GlobalKey();
  final GlobalKey _connectionKey = GlobalKey();
  final GlobalKey _createPointKey = GlobalKey();
  final GlobalKey _searchRadiusKey = GlobalKey();
  LatLng _tapCenter = const LatLng(-29.718, -51.143);
  bool _isConnectingMode = false;
  bool _isRepositionMode = false;
  LivingClueModel? _connectionSource;
  LivingClueModel? _connectionTarget;
  LivingClueModel? _repositioningClue;
  LatLng? _pendingRepositionPoint;
  bool _hasRunSonarScan = false;
  late final AnimationController _sonarPulseController;

  @override
  void initState() {
    super.initState();
    _sonarPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentBounds();
      _showInitialTutorialIfNeeded();
    });
  }

  @override
  void dispose() {
    _sonarPulseController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentBounds() async {
    final bounds = _mapController.camera.visibleBounds;
    await _controller.loadByBounds(bounds);
  }

  Future<void> _useCurrentLocation() async {
    final position = await _controller.currentLocation();
    if (position != null) {
      _mapController.move(position, 14);
      _tapCenter = position;
      _startSonarPulse();
      await _controller.searchAround(position, _controller.sonarRadius.value);
    }
  }

  Future<void> _searchByTap() async {
    _startSonarPulse();
    await _controller.searchAround(_tapCenter, _controller.sonarRadius.value);
    _mapController.move(_tapCenter, _mapController.camera.zoom);
  }

  void _startSonarPulse() {
    setState(() {
      _hasRunSonarScan = true;
    });
    _sonarPulseController.forward(from: 0);
  }

  Future<void> _showInitialTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_tutorialSeenKey) ?? false;
    if (!mounted || seen) return;

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    _showMapTutorial(markAsSeen: true);
  }

  Future<void> _markTutorialAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialSeenKey, true);
  }

  void _toggleConnectionMode() {
    setState(() {
      final nextValue = !_isConnectingMode;
      _isConnectingMode = nextValue;
      if (nextValue) {
        _isRepositionMode = false;
        _repositioningClue = null;
        _pendingRepositionPoint = null;
      } else {
        _connectionSource = null;
        _connectionTarget = null;
      }
    });
  }

  void _cancelConnectionMode() {
    setState(() {
      _isConnectingMode = false;
      _connectionSource = null;
      _connectionTarget = null;
    });
  }

  void _toggleRepositionMode([LivingClueModel? clue]) {
    setState(() {
      final bool nextValue = clue != null ? true : !_isRepositionMode;
      _isRepositionMode = nextValue;
      if (nextValue) {
        _isConnectingMode = false;
        _connectionSource = null;
        _connectionTarget = null;
        _repositioningClue = clue;
        _pendingRepositionPoint = null;
      } else {
        _repositioningClue = null;
        _pendingRepositionPoint = null;
      }
    });
  }

  void _cancelRepositionMode() {
    setState(() {
      _isRepositionMode = false;
      _repositioningClue = null;
      _pendingRepositionPoint = null;
    });
  }

  Future<void> _handleMarkerTap(LivingClueModel item) async {
    if (_isRepositionMode) {
      setState(() {
        _repositioningClue = item;
        _pendingRepositionPoint = null;
      });
      Get.customSnackbar(
        'Reposicionamento',
        'Pista selecionada. Agora pressione e segure no novo ponto do mapa.',
      );
      return;
    }

    if (!_isConnectingMode) {
      _showClueSheet(item);
      return;
    }

    if (_connectionSource == null) {
      setState(() {
        _connectionSource = item;
        _connectionTarget = null;
      });
      Get.customSnackbar(
        'Nova conexão',
        'Origem selecionada. Agora toque na pista de destino.',
      );
      return;
    }

    if (_connectionSource!.id == item.id) {
      Get.customSnackbar(
        'Atenção',
        'Selecione uma pista diferente como destino.',
      );
      return;
    }

    setState(() {
      _connectionTarget = item;
    });

    final created = await Get.toNamed(
      '/clue_connections/create',
      arguments: {
        'sourceId': _connectionSource!.id,
        'sourceName': _connectionSource!.name,
        'targetId': item.id,
        'targetName': item.name,
      },
    );

    if (!mounted) return;

    if (created == true) {
      await _loadCurrentBounds();
      _cancelConnectionMode();
      Get.successSnackbar('Conexão criada e mapa atualizado.');
      return;
    }

    setState(() {
      _connectionTarget = null;
    });
  }

  Future<void> _handleRepositionLongPress(LatLng point) async {
    if (!_isRepositionMode || _repositioningClue == null) {
      return;
    }

    setState(() {
      _pendingRepositionPoint = point;
    });

    final bool? confirmed = await Get.bottomSheet<bool>(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reposicionar pista viva',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text('Pista: ${_repositioningClue!.name}'),
            const SizedBox(height: 8),
            Text(
              'Atual: ${_repositioningClue!.latitude.toStringAsFixed(6)}, ${_repositioningClue!.longitude.toStringAsFixed(6)}',
            ),
            Text(
              'Nova: ${point.latitude.toStringAsFixed(6)}, ${point.longitude.toStringAsFixed(6)}',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    child: const Text('Salvar posição'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );

    if (confirmed != true || _repositioningClue == null) {
      return;
    }

    final saved = await _controller.updatePosition(_repositioningClue!, point);
    if (!mounted || !saved) return;

    await _loadCurrentBounds();
    _mapController.move(point, _mapController.camera.zoom);
    _cancelRepositionMode();
    Get.successSnackbar('Posição da pista atualizada com sucesso.');
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      Get.currentRoute,
      _buildAiContext,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Mapa de pistas'),
        actions: [
          IconButton(
            tooltip: 'Ajuda do mapa',
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showMapTutorial(),
          ),
          if (_isRepositionMode)
            IconButton(
              key: _repositionKey,
              tooltip: 'Cancelar reposicionamento',
              icon: const Icon(Icons.close),
              onPressed: _cancelRepositionMode,
            )
          else
            IconButton(
              key: _repositionKey,
              tooltip: 'Reposicionar pista no mapa',
              icon: const Icon(Icons.open_with),
              onPressed: _toggleRepositionMode,
            ),
          if (_isConnectingMode)
            IconButton(
              key: _connectionKey,
              tooltip: 'Cancelar nova conexão',
              icon: const Icon(Icons.close),
              onPressed: _cancelConnectionMode,
            )
          else
            IconButton(
              key: _connectionKey,
              tooltip: 'Criar conexão no mapa',
              icon: const Icon(Icons.hub_outlined),
              onPressed: _toggleConnectionMode,
            ),
          IconButton(
            key: _createPointKey,
            tooltip: 'Criar pista por ponto',
            icon: const Icon(Icons.add_location_alt),
            onPressed: () async {
              final center = _mapController.camera.center;
              final created = await Get.toNamed(
                '/living_clues/map/create',
                arguments: {
                  'latitude': center.latitude,
                  'longitude': center.longitude,
                },
              );
              if (_isCreatedResult(created)) {
                await _refreshAfterCreate(created);
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          const Positioned.fill(child: CidigScenicBackground()),
          Column(
            children: [
              if (_isConnectingMode || _isRepositionMode)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: _isRepositionMode
                        ? Colors.teal.withValues(alpha: 0.72)
                        : Colors.deepPurple.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    _isRepositionMode
                        ? (_repositioningClue == null
                            ? 'Modo reposicionamento: toque na pista que deseja mover.'
                            : 'Reposicionando ${_repositioningClue!.name}. Agora pressione e segure no novo ponto do mapa.')
                        : (_connectionSource == null
                            ? 'Modo nova conexão: toque na pista de origem.'
                            : 'Origem: ${_connectionSource!.name}. Agora toque na pista de destino.'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Container(
                key: _sonarControlsKey,
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          TextButton.icon(
                            key: _searchRadiusKey,
                            icon: const Icon(Icons.radar),
                            label: const Text('Sonar'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                            ),
                            onPressed: _searchByTap,
                          ),
                          Expanded(
                            child: Obx(() {
                              return Slider(
                                activeColor: Colors.indigo,
                                value: _controller.sonarRadius.value,
                                min: 1000,
                                max: 1000000,
                                divisions: 999,
                                label: _formatRadius(
                                    _controller.sonarRadius.value),
                                onChanged: (value) =>
                                    _controller.sonarRadius.value = value,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: _useLocationKey,
                      color: Colors.white,
                      icon: const Icon(Icons.my_location),
                      tooltip: 'Usar minha localização',
                      onPressed: _useCurrentLocation,
                    ),
                    IconButton(
                      key: _refreshKey,
                      color: Colors.white,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Atualizar área',
                      onPressed: _loadCurrentBounds,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final markers = _controller.livingClues
                      .map(
                        (item) => Marker(
                          point: LatLng(item.latitude, item.longitude),
                          width: 52,
                          height: 52,
                          child: GestureDetector(
                            onTap: () => _handleMarkerTap(item),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_connectionSource?.id == item.id)
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.blue.withValues(alpha: 0.22),
                                      border: Border.all(
                                          color: Colors.blueAccent, width: 2),
                                    ),
                                  ),
                                if (_repositioningClue?.id == item.id)
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.teal.withValues(alpha: 0.22),
                                      border: Border.all(
                                        color: Colors.tealAccent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                if (_connectionTarget?.id == item.id)
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.orange.withValues(alpha: 0.22),
                                      border: Border.all(
                                          color: Colors.orangeAccent, width: 2),
                                    ),
                                  ),
                                Icon(
                                  Icons.location_on,
                                  color: _categoryColor(item),
                                  size: 36,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList();

                  final Map<int, LatLng> pointsById = {
                    for (final clue in _controller.livingClues)
                      clue.id: LatLng(clue.latitude, clue.longitude),
                  };
                  final Map<int, LivingClueModel> cluesById = {
                    for (final clue in _controller.livingClues) clue.id: clue,
                  };
                  final connectionLines = _controller.connections
                      .map(
                        (conn) {
                          final start = pointsById[conn.sourceClueId];
                          final end = pointsById[conn.targetClueId];
                          if (start == null || end == null) return null;
                          final sourceClue = cluesById[conn.sourceClueId];
                          final targetClue = cluesById[conn.targetClueId];
                          return _connectionPolyline(
                            points: [start, end],
                            sourceColor: sourceClue == null
                                ? Colors.redAccent
                                : _categoryColor(sourceClue),
                            targetColor: targetClue == null
                                ? Colors.redAccent
                                : _categoryColor(targetClue),
                          );
                        },
                      )
                      .whereType<Polyline>()
                      .toList();

                  if (_connectionSource != null && _connectionTarget != null) {
                    final sourcePoint = pointsById[_connectionSource!.id] ??
                        LatLng(
                          _connectionSource!.latitude,
                          _connectionSource!.longitude,
                        );
                    final targetPoint = pointsById[_connectionTarget!.id] ??
                        LatLng(
                          _connectionTarget!.latitude,
                          _connectionTarget!.longitude,
                        );
                    connectionLines.add(
                      _connectionPolyline(
                        points: [sourcePoint, targetPoint],
                        sourceColor: _categoryColor(_connectionSource!),
                        targetColor: _categoryColor(_connectionTarget!),
                        strokeWidth: 4,
                      ),
                    );
                  }

                  final circles = <CircleMarker>[];
                  if (_controller.sonarCenter.value != null) {
                    final isPulsing = _sonarPulseController.isAnimating;
                    circles.add(
                      CircleMarker(
                        point: _controller.sonarCenter.value!,
                        color: _hasRunSonarScan
                            ? _sonarBlue.withValues(alpha: 0.18)
                            : _sonarBlue.withValues(alpha: 0),
                        borderStrokeWidth: isPulsing ? 3 : 2,
                        borderColor: _sonarBlue,
                        radius: _visibleSonarRadius(),
                        useRadiusInMeter: true,
                      ),
                    );
                  }
                  if (_pendingRepositionPoint != null) {
                    circles.add(
                      CircleMarker(
                        point: _pendingRepositionPoint!,
                        color: Colors.teal.withValues(alpha: 0.25),
                        borderColor: Colors.tealAccent,
                        borderStrokeWidth: 2,
                        radius: 18,
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      FlutterMap(
                        key: _mapKey,
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _tapCenter,
                          onLongPress: (_, point) {
                            if (_isRepositionMode) {
                              _handleRepositionLongPress(point);
                              return;
                            }
                            _sonarPulseController.stop();
                            _sonarPulseController.reset();
                            setState(() {
                              _tapCenter = point;
                              _hasRunSonarScan = false;
                            });
                            _controller.sonarCenter.value = point;
                          },
                          onMapEvent: (event) {
                            if (event is MapEventMoveEnd) {
                              _loadCurrentBounds();
                            }
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.br.spotecnologia.uniusp_app',
                          ),
                          if (circles.isNotEmpty) CircleLayer(circles: circles),
                          if (connectionLines.isNotEmpty)
                            PolylineLayer(
                              polylines: connectionLines,
                            ),
                          MarkerLayer(
                            markers: [
                              ...markers,
                              if (_pendingRepositionPoint != null)
                                Marker(
                                  point: _pendingRepositionPoint!,
                                  width: 44,
                                  height: 44,
                                  child: const Icon(
                                    Icons.place,
                                    color: Colors.tealAccent,
                                    size: 34,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      if (_controller.isLoading.value)
                        const Positioned.fill(
                          child: IgnorePointer(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Material(
                          color: Colors.black.withValues(alpha: 0.42),
                          shape: const CircleBorder(),
                          child: IconButton(
                            constraints: const BoxConstraints.tightFor(
                              width: 36,
                              height: 36,
                            ),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            tooltip: 'Ver tutorial',
                            icon: const Icon(Icons.help_outline, size: 20),
                            onPressed: () => _showMapTutorial(),
                          ),
                        ),
                      ),
                      if (_controller.errorMessage.value != null)
                        Positioned(
                          top: 12,
                          left: 16,
                          right: 16,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Color(0x8A46B6EC),
                                width: 1.2,
                              ),
                            ),
                            color: Colors.red.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _controller.errorMessage.value!,
                                style: TextStyle(color: Colors.red.shade800),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: Get.currentRoute,
      stage: 'exploração do mapa',
      goal: 'buscar pistas próximas e iniciar o cadastro de um novo ponto',
      visibleFields: const <String>[
        'mapa',
        'raio do sonar',
        'buscar por raio',
        'usar minha localização',
        'atualizar área',
        'criar pista por ponto',
      ],
      filledFields: <String, String>{
        'raio do sonar': _formatRadius(_controller.sonarRadius.value),
        'centro selecionado':
            '${_tapCenter.latitude.toStringAsFixed(5)}, ${_tapCenter.longitude.toStringAsFixed(5)}',
        'pistas carregadas': _controller.livingClues.length.toString(),
        'conexões visíveis': _controller.connections.length.toString(),
        'modo criação de conexão': _isConnectingMode ? 'ativo' : 'inativo',
        'modo reposicionamento': _isRepositionMode ? 'ativo' : 'inativo',
        if (_connectionSource != null)
          'origem da conexão': _connectionSource!.name,
        if (_connectionTarget != null)
          'destino da conexão': _connectionTarget!.name,
        if (_repositioningClue != null)
          'pista em reposicionamento': _repositioningClue!.name,
      },
      notes: <String>[
        if (_controller.sonarCenter.value != null)
          'O usuário definiu um centro para busca por raio.',
        'Tap longo no mapa escolhe o ponto de referência do sonar.',
        if (_isConnectingMode)
          'O usuário está criando uma conexão diretamente no mapa.',
        if (_isRepositionMode)
          'O usuário está escolhendo uma nova posição para uma pista viva.',
      ],
    );
  }

  void _showMapTutorial({bool markAsSeen = false}) {
    final overlay = Overlay.of(context);
    final steps = _tutorialSteps();
    if (steps.isEmpty) return;

    int currentIndex = 0;
    int animationDirection = 1;
    late OverlayEntry entry;

    void close() {
      entry.remove();
      if (markAsSeen) {
        _markTutorialAsSeen();
      }
    }

    void next() {
      if (currentIndex >= steps.length - 1) {
        close();
        return;
      }
      animationDirection = 1;
      currentIndex++;
      entry.markNeedsBuild();
    }

    void previous() {
      if (currentIndex == 0) return;
      animationDirection = -1;
      currentIndex--;
      entry.markNeedsBuild();
    }

    entry = OverlayEntry(
      builder: (context) {
        final step = steps[currentIndex];
        final targetRect = _targetRect(step.targetKey);
        final screenSize = MediaQuery.of(context).size;
        final calloutAbove = targetRect.center.dy > screenSize.height / 2;
        final calloutTop = calloutAbove
            ? (targetRect.top - 174).clamp(16.0, screenSize.height - 190)
            : (targetRect.bottom + 16).clamp(16.0, screenSize.height - 190);

        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TutorialOverlayPainter(targetRect),
                ),
              ),
              Positioned.fromRect(
                rect: targetRect.inflate(6),
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(color: _sonarBlue, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: calloutTop,
                child: TweenAnimationBuilder<double>(
                  key: ValueKey(currentIndex),
                  tween:
                      Tween<double>(begin: animationDirection * 0.08, end: 0),
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  builder: (context, offset, child) {
                    return Opacity(
                      opacity: 1 - (offset.abs() / 0.08).clamp(0.0, 1.0),
                      child: FractionalTranslation(
                        translation: Offset(offset, 0),
                        child: child,
                      ),
                    );
                  },
                  child: _TutorialCard(
                    current: currentIndex + 1,
                    total: steps.length,
                    title: step.title,
                    description: step.description,
                    canGoBack: currentIndex > 0,
                    isLast: currentIndex == steps.length - 1,
                    onBack: previous,
                    onNext: next,
                    onSkip: close,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    overlay.insert(entry);
  }

  List<_MapTutorialStep> _tutorialSteps() {
    return [
      _MapTutorialStep(
        targetKey: _mapKey,
        title: 'Mapa',
        description:
            'Movimente o mapa e use zoom para navegar. As pistas carregadas aparecem como marcadores coloridos.',
      ),
      _MapTutorialStep(
        targetKey: _sonarControlsKey,
        title: 'Raio do sonar',
        description:
            'Ajuste o alcance da busca. O valor vai de 1 km a 1000 km e o círculo usa a escala real do mapa.',
      ),
      _MapTutorialStep(
        targetKey: _searchRadiusKey,
        title: 'Buscar por raio',
        description:
            'Executa a varredura a partir do centro selecionado e mostra o raio pesquisado no mapa.',
      ),
      _MapTutorialStep(
        targetKey: _useLocationKey,
        title: 'Minha localização',
        description:
            'Centraliza o mapa na sua localização atual e usa esse ponto como referência para o sonar.',
      ),
      _MapTutorialStep(
        targetKey: _refreshKey,
        title: 'Atualizar área',
        description:
            'Recarrega as pistas da área visível quando você muda o enquadramento do mapa.',
      ),
      _MapTutorialStep(
        targetKey: _createPointKey,
        title: 'Criar pista',
        description:
            'Abre o cadastro de uma nova pista usando o centro atual do mapa como posição inicial.',
      ),
      _MapTutorialStep(
        targetKey: _connectionKey,
        title: 'Criar conexão',
        description:
            'Ativa o modo de conexão. Toque em uma pista de origem e depois em uma pista de destino.',
      ),
      _MapTutorialStep(
        targetKey: _repositionKey,
        title: 'Reposicionar pista',
        description:
            'Ativa o modo de reposicionamento para mover uma pista existente para outro ponto do mapa.',
      ),
    ];
  }

  Rect _targetRect(GlobalKey key) {
    final context = key.currentContext;
    if (context == null) {
      final size = MediaQuery.of(this.context).size;
      return Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width * 0.72,
        height: 96,
      );
    }

    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      final size = MediaQuery.of(this.context).size;
      return Rect.fromCenter(
        center: size.center(Offset.zero),
        width: size.width * 0.72,
        height: 96,
      );
    }

    final offset = box.localToGlobal(Offset.zero);
    return offset & box.size;
  }

  Color _categoryColor(LivingClueModel model) {
    final String? hex = model.category?.colorHex ??
        _controller.categoriesById[model.categoryId]?.colorHex;
    if (hex == null || hex.isEmpty) {
      return Colors.redAccent;
    }
    try {
      final colorString = '#${hex.replaceAll('#', '').trim()}';
      if (colorString.length == 7) {
        return Color(int.parse('0xff${colorString.substring(1)}'));
      } else if (colorString.length == 9) {
        return Color(int.parse(colorString.replaceFirst('#', '0x')));
      }
    } catch (_) {}
    return Colors.redAccent;
  }

  String _formatRadius(double radiusMeters) {
    final radiusKm = radiusMeters / 1000;
    if (radiusKm == radiusKm.roundToDouble()) {
      return '${radiusKm.toInt()} km';
    }
    return '${radiusKm.toStringAsFixed(1)} km';
  }

  double _visibleSonarRadius() {
    final radius = _controller.sonarRadius.value;
    if (!_sonarPulseController.isAnimating) {
      return radius;
    }
    final progress = Curves.easeOut.transform(_sonarPulseController.value);
    return (radius * progress).clamp(1, radius);
  }

  Polyline _connectionPolyline({
    required List<LatLng> points,
    required Color sourceColor,
    required Color targetColor,
    double strokeWidth = 3,
  }) {
    return Polyline(
      points: points,
      color: sourceColor,
      gradientColors: [sourceColor, targetColor],
      colorsStop: const [0, 1],
      strokeWidth: strokeWidth,
      borderColor: Colors.black.withValues(alpha: 0.35),
      borderStrokeWidth: 1,
    );
  }

  bool _isCreatedResult(Object? result) {
    return result == true || (result is Map && result['created'] == true);
  }

  Future<void> _refreshAfterCreate(Object? result) async {
    final point = _createdPoint(result);
    if (point != null) {
      setState(() => _tapCenter = point);
      final currentZoom = _mapController.camera.zoom;
      _mapController.move(point, currentZoom < 14 ? 14 : currentZoom);
    }
    await _loadCurrentBounds();
  }

  LatLng? _createdPoint(Object? result) {
    if (result is! Map) return null;
    final latitude = _toDouble(result['latitude']);
    final longitude = _toDouble(result['longitude']);
    if (latitude == null || longitude == null) return null;
    return LatLng(latitude, longitude);
  }

  double? _toDouble(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '');
  }

  void _showClueSheet(LivingClueModel item) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(item.description ?? 'Sem descrição'),
            const SizedBox(height: 10),
            Text(
              'Categoria: ${item.category?.name ?? item.categoryId}',
              style: const TextStyle(color: Colors.black54),
            ),
            Text(
              'Lat ${item.latitude.toStringAsFixed(5)} • Lng ${item.longitude.toStringAsFixed(5)}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Ver pista'),
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/living_clues/show', arguments: item);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit_location_alt_outlined),
                    label: const Text('Editar'),
                    onPressed: () async {
                      Get.back();
                      final updated = await Get.toNamed(
                        '/living_clues/update',
                        parameters: {'id': item.id.toString()},
                      );
                      if (updated == true) {
                        _loadCurrentBounds();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.open_with),
                label: const Text('Mover no mapa'),
                onPressed: () {
                  Get.back();
                  _toggleRepositionMode(item);
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _MapTutorialStep {
  const _MapTutorialStep({
    required this.targetKey,
    required this.title,
    required this.description,
  });

  final GlobalKey targetKey;
  final String title;
  final String description;
}

class _TutorialOverlayPainter extends CustomPainter {
  const _TutorialOverlayPainter(this.targetRect);

  final Rect targetRect;

  @override
  void paint(Canvas canvas, Size size) {
    final overlayPath = ui.Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final targetPath = ui.Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          targetRect.inflate(8),
          const Radius.circular(14),
        ),
      );
    final dimPath = ui.Path.combine(
      ui.PathOperation.difference,
      overlayPath,
      targetPath,
    );

    canvas.drawPath(
      dimPath,
      Paint()..color = Colors.black.withValues(alpha: 0.72),
    );
  }

  @override
  bool shouldRepaint(_TutorialOverlayPainter oldDelegate) {
    return oldDelegate.targetRect != targetRect;
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.current,
    required this.total,
    required this.title,
    required this.description,
    required this.canGoBack,
    required this.isLast,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
  });

  final int current;
  final int total;
  final String title;
  final String description;
  final bool canGoBack;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0D47A1), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                Text(
                  '$current/$total',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.white70, height: 1.35),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: onSkip,
                  child: const Text('Pular'),
                ),
                const Spacer(),
                if (canGoBack)
                  TextButton(
                    onPressed: onBack,
                    child: const Text('Voltar'),
                  ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onNext,
                  child: Text(isLast ? 'Concluir' : 'Próximo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
