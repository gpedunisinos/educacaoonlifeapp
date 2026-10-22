import 'package:unisinos_usp_app/widgets/anchored_tutorial_layout.dart';
import 'package:unisinos_usp_app/widgets/iarete_reply.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';
import 'package:unisinos_usp_app/services/ship_audio_preferences.dart';
import 'package:unisinos_usp_app/services/iarete_audio/typing_audio.dart';
import 'package:unisinos_usp_app/screens/space/space_map_shell.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_launcher.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/locker_panel.dart';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';
import 'package:unisinos_usp_app/controllers/living_clue/environmental_layers_controller.dart';
import 'package:unisinos_usp_app/models/environmental_layer_model.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/models/nominatim_place_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/location_privacy_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueMapScreen extends StatefulWidget {
  const LivingClueMapScreen({super.key, this.tileProvider});
  final TileProvider? tileProvider;

  @override
  State<LivingClueMapScreen> createState() => _LivingClueMapScreenState();
}

class _LivingClueMapScreenState extends State<LivingClueMapScreen>
    with SingleTickerProviderStateMixin {
  static const String _screenName = 'Mapa de pistas';
  static const String _tutorialSeenKey = 'living_clue_map_tutorial_seen';
  static const Color _sonarBlue = mapIce;
  static const double _minMapZoom = 3;
  static const double _maxMapZoom = 18;
  static const double _zoomStep = 1;
  final LivingClueMapController _controller =
      Get.find<LivingClueMapController>();
  final EnvironmentalLayersController _environmentalController =
      Get.find<EnvironmentalLayersController>();
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
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
  String _searchQuery = '';
  bool _searchResultsExpanded = true;
  bool _hasRunSonarScan = false;
  bool _isUpdatingSearchText = false;
  Timer? _searchDebounce;
  Worker? _routeWorker;
  VoidCallback? _dismissTutorial;
  ModalRoute<dynamic>? _hostRoute;
  bool get _routeIsCurrent => _hostRoute?.isCurrent ?? true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hostRoute = ModalRoute.of(context);
  }

  late final AnimationController _sonarPulseController;

  late final String _contextRoute = Get.currentRoute;
  late final AiAssistantContextProvider _contextProvider = _buildAiContext;

  @override
  void initState() {
    super.initState();
    _routeWorker = ever<String>(AiAssistantLauncher.activeRoute, (route) {
      if (route != '/living_clues/map') _dismissTutorial?.call();
    });
    _sonarPulseController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1200),
        )..addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_routeIsCurrent) return;
      _loadCurrentBounds();
      _environmentalController.openWithSatellite();
      _showInitialTutorialIfNeeded();
    });
  }

  @override
  void dispose() {
    if (Get.isRegistered<AiAssistantContextService>()) {
      Get.find<AiAssistantContextService>().unregisterProvider(
        _contextRoute,
        _contextProvider,
      );
    }
    _searchDebounce?.cancel();
    _routeWorker?.dispose();
    _dismissTutorial?.call();
    _sonarPulseController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentBounds() async {
    final bounds = _mapController.camera.visibleBounds;
    await _controller.loadByBounds(bounds);
  }

  Future<void> _refreshActiveContext() async {
    if (_searchQuery.isNotEmpty) {
      await _controller.searchGlobal(_searchQuery);
      return;
    }
    await _loadCurrentBounds();
  }

  Future<void> _useCurrentLocation() async {
    final position = await _controller.currentLocation();
    if (position != null) {
      _clearSearchText();
      _mapController.move(position, 14);
      _tapCenter = position;
      _startSonarPulse();
      await _controller.searchAround(position, _controller.sonarRadius.value);
    }
  }

  Future<void> _searchByTap() async {
    _clearSearchText();
    _startSonarPulse();
    await _controller.searchAround(_tapCenter, _controller.sonarRadius.value);
    _mapController.move(_tapCenter, _mapController.camera.zoom);
  }

  void _changeMapZoom(double delta) {
    final camera = _mapController.camera;
    final nextZoom = (camera.zoom + delta).clamp(_minMapZoom, _maxMapZoom);
    _mapController.move(camera.center, nextZoom);
  }

  void _startSonarPulse() {
    setState(() {
      _hasRunSonarScan = true;
    });
    _sonarPulseController.forward(from: 0);
  }

  Future<void> _clearSearch() async {
    _clearSearchText();
    _searchFocusNode.unfocus();
    await _loadCurrentBounds();
  }

  void _clearSearchText() {
    _searchDebounce?.cancel();
    _isUpdatingSearchText = true;
    _searchController.clear();
    _isUpdatingSearchText = false;
    setState(() {
      _searchQuery = '';
      _searchResultsExpanded = true;
    });
  }

  void _onSearchChanged(String value) {
    if (_isUpdatingSearchText) return;

    final query = value.trim();
    setState(() {
      _searchQuery = query;
      _searchResultsExpanded = true;
    });

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      if (query.isEmpty) {
        _loadCurrentBounds();
        return;
      }
      _controller.searchGlobal(query);
    });
  }

  void _collapseSearchResults() {
    if (_searchQuery.isNotEmpty && _searchResultsExpanded) {
      setState(() => _searchResultsExpanded = false);
    }
    _searchFocusNode.unfocus();
  }

  void _focusClueOnMap(LivingClueModel clue) {
    _collapseSearchResults();
    if (!clue.hasLocation) {
      Get.toNamed('/living_clues/show', arguments: clue);
      return;
    }
    final point = LatLng(clue.latitude!, clue.longitude!);
    _mapController.move(
      point,
      _mapController.camera.zoom < 14 ? 14 : _mapController.camera.zoom,
    );
    _searchFocusNode.unfocus();
  }

  Future<void> _focusMapPlace(NominatimPlaceModel place) async {
    final point = LatLng(place.latitude, place.longitude);
    _clearSearchText();
    _searchFocusNode.unfocus();
    setState(() => _tapCenter = point);
    _mapController.move(point, 15);
    await _loadCurrentBounds();
  }

  Future<void> _showInitialTutorialIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(_tutorialSeenKey) ?? false;
    if (!mounted || seen) return;

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted || Get.currentRoute != '/living_clues/map') return;
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
    _collapseSearchResults();
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
      await _refreshActiveContext();
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

    if (!await LocationPrivacyService.ensureAcknowledged(context)) return;
    if (!mounted) return;

    setState(() {
      _pendingRepositionPoint = point;
    });

    final bool? confirmed = await Get.bottomSheet<bool>(
      _mapSheet(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: mapPanel,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reposicionar pista viva',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text('Pista: ${_repositioningClue!.name}'),
              const SizedBox(height: 8),
              Text(
                'Atual: ${_repositioningClue!.latitude!.toStringAsFixed(6)}, ${_repositioningClue!.longitude!.toStringAsFixed(6)}',
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
      ),
      isScrollControlled: true,
    );

    if (confirmed != true || _repositioningClue == null) {
      return;
    }

    final saved = await _controller.updatePosition(_repositioningClue!, point);
    if (!mounted || !saved) return;

    await _refreshActiveContext();
    _mapController.move(point, _mapController.camera.zoom);
    _cancelRepositionMode();
    Get.successSnackbar('Posição da pista atualizada com sucesso.');
  }

  void _returnToCockpit() {
    var found = false;
    Get.until((route) {
      found = route.settings.name == '/space';
      return found || route.isFirst;
    });
    if (!found) Get.offNamed('/space');
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: spaceRecordTheme(),
    child: Builder(builder: _buildMap),
  );

  Widget _buildMap(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      _contextRoute,
      _contextProvider,
    );
    return SpaceMapShell(
      back: OutlinedButton.icon(
        onPressed: _returnToCockpit,
        icon: const Icon(Icons.arrow_back, size: 18),
        label: const Text('Voltar ao cockpit'),
      ),
      actions: [
        IconButton(
          tooltip: 'Lista de pistas',
          icon: const Icon(Icons.view_list_outlined),
          onPressed: () => Get.toNamed('/space/research'),
        ),
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
            onPressed: Get.find<UserController>().user.value?.canAuthor == true
                ? _toggleRepositionMode
                : null,
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
            onPressed: Get.find<UserController>().user.value?.canAuthor == true
                ? _toggleConnectionMode
                : null,
          ),
        if (Get.find<UserController>().user.value?.canAuthor == true)
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
      child: Stack(
        children: [
          Column(
            children: [
              if (_isConnectingMode || _isRepositionMode)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
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
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF102A39),
                  border: Border.all(color: const Color(0xFF2F5661)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      style: const TextStyle(color: Colors.white),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Pesquisar pistas em todo o mapa',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: _searchQuery.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpar pesquisa',
                                icon: const Icon(Icons.close),
                                color: Colors.white,
                                onPressed: _clearSearch,
                              ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                    Obx(() => _buildLoadStatus()),
                    const SizedBox(height: 8),
                    Row(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                ),
                                onPressed: _searchByTap,
                              ),
                              Expanded(
                                child: Obx(() {
                                  return Slider(
                                    key: _sonarControlsKey,
                                    activeColor: mapIce,
                                    value: _controller.sonarRadius.value,
                                    min: 1000,
                                    max: 1000000,
                                    divisions: 999,
                                    label: _formatRadius(
                                      _controller.sonarRadius.value,
                                    ),
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
                          tooltip: _searchQuery.isEmpty
                              ? 'Atualizar área'
                              : 'Refazer pesquisa',
                          onPressed: _refreshActiveContext,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final visibleClues = _controller.livingClues
                      .where((clue) => clue.hasLocation)
                      .toList();
                  final visiblePlaces = _controller.mapPlaces.toList();
                  final markers = visibleClues
                      .map(
                        (item) => Marker(
                          point: LatLng(item.latitude!, item.longitude!),
                          width: 52,
                          height: 52,
                          child: GestureDetector(
                            key: ValueKey('map-clue-${item.id}'),
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
                                      color: Colors.blue.withValues(
                                        alpha: 0.22,
                                      ),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                if (_repositioningClue?.id == item.id)
                                  Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.teal.withValues(
                                        alpha: 0.22,
                                      ),
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
                                      color: Colors.orange.withValues(
                                        alpha: 0.22,
                                      ),
                                      border: Border.all(
                                        color: Colors.orangeAccent,
                                        width: 2,
                                      ),
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
                    for (final clue in visibleClues)
                      clue.id: LatLng(clue.latitude!, clue.longitude!),
                  };
                  final Map<int, LivingClueModel> cluesById = {
                    for (final clue in visibleClues) clue.id: clue,
                  };
                  final connectionLines = _controller.connections
                      .map((conn) {
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
                      })
                      .whereType<Polyline>()
                      .toList();

                  if (_connectionSource != null && _connectionTarget != null) {
                    final sourcePoint =
                        pointsById[_connectionSource!.id] ??
                        LatLng(
                          _connectionSource!.latitude!,
                          _connectionSource!.longitude!,
                        );
                    final targetPoint =
                        pointsById[_connectionTarget!.id] ??
                        LatLng(
                          _connectionTarget!.latitude!,
                          _connectionTarget!.longitude!,
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
                              if (_controller.loadMode.value ==
                                  LivingClueMapLoadMode.search) {
                                return;
                              }
                              _loadCurrentBounds();
                            }
                          },
                        ),
                        children: [
                          if (_environmentalController
                                  .selectedExternalBaseMap ==
                              null)
                            TileLayer(
                              tileProvider: widget.tileProvider,
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.br.spotecnologia.uniusp_app',
                            )
                          else
                            TileLayer(
                              key: ValueKey(
                                'basemap-${_environmentalController.selectedBaseMapId.value}',
                              ),
                              urlTemplate: _environmentalController.webclient
                                  .absoluteTileUrl(
                                    _environmentalController
                                        .selectedExternalBaseMap!,
                                  ),
                              tileProvider:
                                  widget.tileProvider ??
                                  NetworkTileProvider(
                                    headers: {
                                      'Authorization':
                                          'Bearer ${AuthProvider.instance.getToken()}',
                                    },
                                  ),
                              minZoom: _environmentalController
                                  .selectedExternalBaseMap!
                                  .minZoom
                                  .toDouble(),
                              maxZoom: _environmentalController
                                  .selectedExternalBaseMap!
                                  .maxZoom
                                  .toDouble(),
                              userAgentPackageName:
                                  'com.br.spotecnologia.uniusp_app',
                            ),
                          ..._environmentalController.activeLayers.map(
                            (layer) => Opacity(
                              key: ValueKey('environmental-${layer.id}'),
                              opacity:
                                  _environmentalController.opacities[layer
                                      .id] ??
                                  layer.defaultOpacity,
                              child: TileLayer(
                                urlTemplate: _environmentalController.webclient
                                    .absoluteTileUrl(layer),
                                tileProvider:
                                    widget.tileProvider ??
                                    NetworkTileProvider(
                                      headers: {
                                        'Authorization':
                                            'Bearer ${AuthProvider.instance.getToken()}',
                                      },
                                    ),
                                minZoom: layer.minZoom.toDouble(),
                                maxZoom: layer.maxZoom.toDouble(),
                                userAgentPackageName:
                                    'com.br.spotecnologia.uniusp_app',
                              ),
                            ),
                          ),
                          if (circles.isNotEmpty) CircleLayer(circles: circles),
                          if (connectionLines.isNotEmpty)
                            PolylineLayer(polylines: connectionLines),
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
                          color: mapPanel,
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
                      Positioned(
                        top: 56,
                        right: 12,
                        child: _buildZoomControl(),
                      ),
                      Positioned(
                        top: 136,
                        right: 12,
                        child: Material(
                          color: mapPanel,
                          shape: const CircleBorder(),
                          child: IconButton(
                            constraints: const BoxConstraints.tightFor(
                              width: 36,
                              height: 36,
                            ),
                            padding: EdgeInsets.zero,
                            color: Colors.white,
                            tooltip: 'Camadas ambientais',
                            icon: Badge(
                              isLabelVisible: _environmentalController
                                  .activeLayers
                                  .isNotEmpty,
                              label: Text(
                                _environmentalController.activeLayers.length
                                    .toString(),
                              ),
                              child: const Icon(
                                Icons.layers_outlined,
                                size: 20,
                              ),
                            ),
                            onPressed: _showEnvironmentalLayers,
                          ),
                        ),
                      ),
                      if (_environmentalController.activeLayers.isNotEmpty)
                        Positioned(
                          left: 12,
                          bottom: _searchQuery.isNotEmpty
                              ? (_searchResultsExpanded ? 338 : 64)
                              : 12,
                          child: _buildEnvironmentalLegend(),
                        ),
                      Positioned(
                        right: 12,
                        bottom: _searchQuery.isNotEmpty
                            ? (_searchResultsExpanded ? 338 : 64)
                            : 12,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.62),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            child: Text(
                              _environmentalController.baseMapAttribution,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
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
                            color: const Color(0xFF3B202B),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _controller.errorMessage.value!,
                                style: TextStyle(
                                  color: const Color(0xFFFFB5BC),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_searchQuery.isNotEmpty)
                        Positioned(
                          left: 12,
                          right: 12,
                          bottom: 12,
                          child: _buildSearchResults(
                            clues: visibleClues,
                            places: visiblePlaces,
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

  Widget _buildZoomControl() {
    return Material(
      color: mapPanel,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _zoomButton(
            icon: Icons.add,
            tooltip: 'Aproximar mapa',
            onPressed: () => _changeMapZoom(_zoomStep),
          ),
          Container(
            width: 28,
            height: 1,
            color: Colors.white.withValues(alpha: 0.22),
          ),
          _zoomButton(
            icon: Icons.remove,
            tooltip: 'Afastar mapa',
            onPressed: () => _changeMapZoom(-_zoomStep),
          ),
        ],
      ),
    );
  }

  void _showEnvironmentalLayers() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: mapPanel,
      builder: (context) => Theme(
        data: spaceRecordTheme(),
        child: Obx(() {
          final controller = _environmentalController;
          return Material(
            color: mapPanel,
            child: SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.72,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Camadas do mapa',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: controller.activeLayers.isEmpty
                                ? null
                                : controller.disableAll,
                            child: const Text('Desativar todas'),
                          ),
                        ],
                      ),
                    ),
                    if (controller.isLoading.value)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (controller.errorMessage.value != null)
                      Expanded(
                        child: Center(
                          child: TextButton.icon(
                            onPressed: controller.load,
                            icon: const Icon(Icons.refresh),
                            label: Text(controller.errorMessage.value!),
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.overlayLayers.length + 2,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildBaseMapSelector(controller);
                            }
                            if (index == 1) {
                              return const Padding(
                                padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
                                child: Text(
                                  'Camadas ambientais',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }
                            final layer = controller.overlayLayers[index - 2];
                            final enabled = controller.enabledIds.contains(
                              layer.id,
                            );
                            return ExpansionTile(
                              enabled: layer.available,
                              leading: Switch(
                                value: enabled,
                                onChanged: layer.available
                                    ? (value) =>
                                          controller.toggle(layer.id, value)
                                    : null,
                              ),
                              title: Text(layer.name),
                              subtitle: Text(
                                layer.available
                                    ? layer.description
                                    : 'Camada temporariamente indisponível',
                              ),
                              childrenPadding: const EdgeInsets.fromLTRB(
                                24,
                                0,
                                24,
                                16,
                              ),
                              children: [
                                Row(
                                  children: [
                                    const Text('Opacidade'),
                                    Expanded(
                                      child: Slider(
                                        value:
                                            controller.opacities[layer.id] ??
                                            layer.defaultOpacity,
                                        onChanged: enabled
                                            ? (value) => controller.setOpacity(
                                                layer.id,
                                                value,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Fonte: ${layer.sourceName} — ${layer.sourceVersion}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBaseMapSelector(EnvironmentalLayersController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Mapa-base',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          RadioListTile<String>(
            value: 'osm',
            groupValue: controller.selectedBaseMapId.value,
            onChanged: (value) => controller.selectBaseMap(value!),
            title: const Text('Mapa claro'),
            subtitle: const Text('OpenStreetMap'),
          ),
          ...controller.baseMaps.map(
            (layer) => RadioListTile<String>(
              value: layer.id,
              groupValue: controller.selectedBaseMapId.value,
              onChanged: layer.available
                  ? (value) => controller.selectBaseMap(value!)
                  : null,
              title: Text(layer.name),
              subtitle: Text(
                layer.available
                    ? layer.description
                    : 'Configure a credencial Esri para habilitar',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalLegend() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 245, maxHeight: 220),
      child: Card(
        color: mapPanel,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _environmentalController.activeLayers
                .map((layer) => _legendLayer(layer))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _legendLayer(EnvironmentalLayerModel layer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            layer.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          ...layer.legend.map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: 6, top: 3),
                  decoration: BoxDecoration(
                    color: _hexColor(item.color),
                    border: Border.all(color: Colors.white54),
                  ),
                ),
                Flexible(
                  child: Text(
                    item.label,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _hexColor(String value) {
    final hex = value.replaceFirst('#', '');
    return Color(int.parse('FF${hex.padLeft(6, '0')}', radix: 16));
  }

  Widget _buildLoadStatus() {
    final int clueTotal = _controller.livingClues.length;
    final int placeTotal = _controller.mapPlaces.length;
    final String label = switch (_controller.loadMode.value) {
      LivingClueMapLoadMode.search =>
        '$clueTotal pistas e $placeTotal locais encontrados',
      LivingClueMapLoadMode.radius => '$clueTotal pistas no raio do sonar',
      LivingClueMapLoadMode.bounds => '$clueTotal pistas nesta area',
    };

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.74),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _zoomButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      padding: EdgeInsets.zero,
      color: Colors.white,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      onPressed: onPressed,
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: _contextRoute,
      references: {
        if (_contextClue != null) 'living_clue_id': _contextClue!.id,
      },
      visibleRecords: _controller.livingClues
          .take(20)
          .map(
            (clue) => AiRecordReference(
              kind: 'living_clue',
              id: clue.id,
              name: clue.name,
            ),
          )
          .toList(),
      stage: 'exploração do mapa',
      goal: 'buscar pistas próximas e iniciar o cadastro de um novo ponto',
      visibleFields: const <String>[
        'mapa',
        'raio do sonar',
        'buscar por raio',
        'usar minha localização',
        'atualizar área',
        'criar pista por ponto',
        'pesquisar pistas em todo o mapa',
        'pesquisar locais do mapa',
      ],
      filledFields: <String, String>{
        'raio do sonar': _formatRadius(_controller.sonarRadius.value),
        'centro selecionado':
            '${_tapCenter.latitude.toStringAsFixed(5)}, ${_tapCenter.longitude.toStringAsFixed(5)}',
        'pistas carregadas': _controller.livingClues.length.toString(),
        'locais encontrados': _controller.mapPlaces.length.toString(),
        'conexões visíveis': _controller.connections.length.toString(),
        if (_searchQuery.isNotEmpty) 'pesquisa': _searchQuery,
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
        'O centro do mapa é uma referência de busca, não a localização física da pessoa.',
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
    FocusManager.instance.primaryFocus?.unfocus();
    final steps = _tutorialSteps()
        .where((step) => step.targetKey.currentContext != null)
        .toList();
    if (steps.isEmpty) return;

    final tutorialAudio = TypingAudio();
    bool closed = false;
    ShipAudioPreferences.restore().then((_) {
      if (!closed && ShipAudioPreferences.enabled.value)
        tutorialAudio.prepare();
    });
    int currentIndex = 0;
    late OverlayEntry entry;

    void close() {
      if (closed) return;
      closed = true;
      _dismissTutorial = null;
      entry.remove();
      tutorialAudio.dispose();
      if (markAsSeen) {
        _markTutorialAsSeen();
      }
    }

    void next() {
      if (ShipAudioPreferences.enabled.value) tutorialAudio.prepare();
      if (currentIndex >= steps.length - 1) {
        close();
        return;
      }
      currentIndex++;
      entry.markNeedsBuild();
    }

    void previous() {
      if (ShipAudioPreferences.enabled.value) tutorialAudio.prepare();
      if (currentIndex == 0) return;
      currentIndex--;
      entry.markNeedsBuild();
    }

    entry = OverlayEntry(
      builder: (context) => LayoutBuilder(
        builder: (context, constraints) {
          if (closed || !mounted || !_routeIsCurrent) {
            return const SizedBox.shrink();
          }
          final step = steps[currentIndex];
          final overlayBox = attachedTutorialBox(overlay.context);
          if (overlayBox == null) return const SizedBox.shrink();
          final viewport = Offset.zero & constraints.biggest;
          final targetRect = _targetRect(
            step.targetKey,
            overlayBox,
          ).intersect(viewport);
          final media = MediaQuery.of(context);
          final bottomInset = media.viewInsets.bottom > media.padding.bottom
              ? media.viewInsets.bottom
              : media.padding.bottom;
          return Material(
            color: Colors.transparent,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _TutorialOverlayPainter(targetRect),
                  ),
                ),
                if (!targetRect.isEmpty)
                  Positioned.fromRect(
                    key: const ValueKey('map-guide-highlight'),
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
                Positioned.fill(
                  child: CustomSingleChildLayout(
                    delegate: AnchoredTutorialLayout(
                      target: targetRect,
                      insets: EdgeInsets.fromLTRB(
                        16 + media.padding.left,
                        16 + media.padding.top,
                        16 + media.padding.right,
                        16 + bottomInset,
                      ),
                    ),
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey(currentIndex),
                      tween: Tween(begin: 0, end: 1),
                      duration: media.disableAnimations
                          ? Duration.zero
                          : const Duration(milliseconds: 220),
                      builder: (context, opacity, child) =>
                          Opacity(opacity: opacity, child: child),
                      child: SingleChildScrollView(
                        key: const ValueKey('map-guide-card-viewport'),
                        child: _TutorialCard(
                          key: const ValueKey('map-guide-card'),
                          onType: () {
                            if (ShipAudioPreferences.enabled.value)
                              tutorialAudio.tick();
                          },
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    _dismissTutorial?.call();
    _dismissTutorial = close;
    overlay.insert(entry);
  }

  List<_MapTutorialStep> _tutorialSteps() {
    return [
          _MapTutorialStep(
            targetKey: _mapKey,
            title: 'Mapa',
            description:
                'Vou acompanhar sua exploração da Terra. Mova o mapa ou use os botões de zoom. Os marcadores coloridos mostram as pistas encontradas.',
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
                'Use este botão para procurar pistas ao redor do ponto escolhido. O círculo mostra a área que estamos explorando.',
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
        ]
        .where(
          (step) =>
              Get.find<UserController>().user.value?.canAuthor == true ||
              ![
                _createPointKey,
                _connectionKey,
                _repositionKey,
              ].contains(step.targetKey),
        )
        .toList();
  }

  Rect _targetRect(GlobalKey key, RenderBox overlayBox) {
    final box = attachedTutorialBox(key.currentContext);
    if (box == null) return Rect.zero;
    return box.localToGlobal(Offset.zero, ancestor: overlayBox) & box.size;
  }

  Color _categoryColor(LivingClueModel model) {
    final String? hex =
        model.category?.colorHex ??
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
    await _refreshActiveContext();
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

  Widget _buildSearchResults({
    required List<LivingClueModel> clues,
    required List<NominatimPlaceModel> places,
  }) {
    final bool hasResults = clues.isNotEmpty || places.isNotEmpty;

    return AnimatedSize(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeInOutCubic,
      alignment: Alignment.bottomCenter,
      child: !_searchResultsExpanded
          ? Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: mapPanel,
                borderRadius: BorderRadius.circular(24),
                child: TextButton.icon(
                  key: const ValueKey('map-show-search-results'),
                  onPressed: () =>
                      setState(() => _searchResultsExpanded = true),
                  icon: const Icon(Icons.keyboard_arrow_up),
                  label: const Text('Mostrar lista'),
                ),
              ),
            )
          : Material(
              key: const ValueKey('map-search-results-panel'),
              color: mapPanel,
              borderRadius: BorderRadius.circular(14),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 320),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14, right: 4),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Resultados da pesquisa',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Recolher lista',
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: _collapseSearchResults,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: !hasResults
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: Text(
                                'Nenhuma pista ou local encontrado para esta pesquisa.',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          : ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: [
                                if (clues.isNotEmpty) ...[
                                  _buildSearchSectionHeader('Pistas'),
                                  ...clues.map(_buildClueSearchTile),
                                ],
                                if (places.isNotEmpty) ...[
                                  _buildSearchSectionHeader('Locais'),
                                  ...places.map(_buildPlaceSearchTile),
                                ],
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.62),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildClueSearchTile(LivingClueModel clue) {
    final category =
        clue.category ?? _controller.categoriesById[clue.categoryId];
    return ListTile(
      dense: true,
      leading: Icon(Icons.location_on, color: _categoryColor(clue)),
      title: Text(
        clue.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        category?.name ?? 'Categoria ${clue.categoryId}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
      ),
      trailing: const Icon(
        Icons.center_focus_strong,
        color: Colors.white,
        size: 20,
      ),
      onTap: () => _focusClueOnMap(clue),
    );
  }

  Widget _buildPlaceSearchTile(NominatimPlaceModel place) {
    return ListTile(
      dense: true,
      leading: const Icon(Icons.public, color: Colors.lightBlueAccent),
      title: Text(
        place.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        _placeSubtitle(place),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
      ),
      trailing: const Icon(Icons.travel_explore, color: Colors.white, size: 20),
      onTap: () => _focusMapPlace(place),
    );
  }

  String _placeSubtitle(NominatimPlaceModel place) {
    final labels = [
      place.category,
      place.type,
    ].where((value) => value != null && value.isNotEmpty).join(' • ');

    if (labels.isNotEmpty) return labels;
    return 'Local do mapa';
  }

  Widget _mapSheet(Widget child) => Theme(
    data: spaceRecordTheme(),
    child: Material(
      color: mapPanel,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .82,
          ),
          child: SingleChildScrollView(child: child),
        ),
      ),
    ),
  );

  LivingClueModel? _contextClue;

  void _showClueSheet(LivingClueModel item) {
    _contextClue = item;
    Get.bottomSheet(
      _mapSheet(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: mapPanel,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.description ?? 'Sem descrição',
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Text(
                'Categoria: ${item.category?.name ?? item.categoryId}',
                style: const TextStyle(color: Color(0xFF9BB4C5)),
              ),
              Text(
                'Lat ${item.latitude?.toStringAsFixed(5) ?? '—'} • Lng ${item.longitude?.toStringAsFixed(5) ?? '—'}',
                style: const TextStyle(color: Color(0xFF9BB4C5)),
              ),
              const SizedBox(height: 14),
              LockerButton(type: 'living_clue', id: item.id),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.visibility_outlined),
                      label: const Text('Ver pista'),
                      onPressed: () {
                        Get.back();
                        Get.toNamed(
                          '/space/research/${item.id}',
                          arguments: item,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (Get.find<UserController>().user.value?.canAuthor == true)
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
                            _refreshActiveContext();
                          }
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              if (Get.find<UserController>().user.value?.canAuthor == true &&
                  item.hasLocation)
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
      ),
      isScrollControlled: true,
    ).whenComplete(() {
      if (identical(_contextClue, item)) _contextClue = null;
    });
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
    if (targetRect.isEmpty) {
      canvas.drawPath(
        overlayPath,
        Paint()..color = Colors.black.withValues(alpha: 0.72),
      );
      return;
    }
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
    super.key,
    required this.current,
    required this.total,
    required this.title,
    required this.description,
    required this.canGoBack,
    required this.isLast,
    required this.onBack,
    required this.onNext,
    required this.onSkip,
    required this.onType,
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
  final VoidCallback onType;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mapIce, width: 1.2),
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
            const Row(
              children: [
                SizedBox(
                  width: 84,
                  height: 36,
                  child: IareteConversationSignal(),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'IARETÉ / GUIA DO MAPA',
                    style: TextStyle(color: mapIce, fontSize: 11),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            IareteReply(
              key: ValueKey(current),
              text: description,
              animate: true,
              reserveCompletionSpace: true,
              onType: onType,
              builder: (visible) => Stack(
                children: [
                  ExcludeSemantics(
                    child: Opacity(
                      opacity: 0,
                      child: Text(
                        description,
                        style: const TextStyle(
                          color: Colors.white70,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    visible,
                    style: const TextStyle(color: Colors.white70, height: 1.35),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 6,
              children: [
                TextButton(onPressed: onSkip, child: const Text('Pular')),
                if (canGoBack)
                  TextButton(onPressed: onBack, child: const Text('Voltar')),
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
