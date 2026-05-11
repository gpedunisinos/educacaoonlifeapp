import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueMapScreen extends StatefulWidget {
  const LivingClueMapScreen({super.key});

  @override
  State<LivingClueMapScreen> createState() => _LivingClueMapScreenState();
}

class _LivingClueMapScreenState extends State<LivingClueMapScreen> {
  static const String _screenName = 'Mapa de pistas';
  static const LatLng _initialCenter = LatLng(-29.718, -51.143);
  final LivingClueMapController _controller =
      Get.find<LivingClueMapController>();
  final MapController _mapController = MapController();
  bool _isConnectingMode = false;
  LivingClueModel? _connectionSource;
  LivingClueModel? _connectionTarget;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentBounds());
  }

  Future<void> _loadCurrentBounds() async {
    final bounds = _mapController.camera.visibleBounds;
    await _controller.loadByBounds(bounds);
  }

  Future<void> _useCurrentLocation() async {
    final position = await _controller.currentLocation();
    if (position != null) {
      _mapController.move(position, 14);
      await _loadCurrentBounds();
    }
  }

  void _toggleConnectionMode() {
    setState(() {
      final nextValue = !_isConnectingMode;
      _isConnectingMode = nextValue;
      if (!nextValue) {
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

  Future<void> _handleMarkerTap(LivingClueModel item) async {
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
          if (_isConnectingMode)
            IconButton(
              tooltip: 'Cancelar nova conexão',
              icon: const Icon(Icons.close),
              onPressed: _cancelConnectionMode,
            )
          else
            IconButton(
              tooltip: 'Criar conexão no mapa',
              icon: const Icon(Icons.hub_outlined),
              onPressed: _toggleConnectionMode,
            ),
          IconButton(
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
              if (_isConnectingMode)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    _connectionSource == null
                        ? 'Modo nova conexão: toque na pista de origem.'
                        : 'Origem: ${_connectionSource!.name}. Agora toque na pista de destino.',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.my_location),
                      tooltip: 'Usar minha localização',
                      onPressed: _useCurrentLocation,
                    ),
                    IconButton(
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

                  return Stack(
                    children: [
                      FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _initialCenter,
                          initialZoom: 13,
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
                          if (connectionLines.isNotEmpty)
                            PolylineLayer(
                              polylines: connectionLines,
                            ),
                          MarkerLayer(markers: markers),
                        ],
                      ),
                      if (_controller.isLoading.value)
                        const Positioned.fill(
                          child: IgnorePointer(
                            child: Center(child: CircularProgressIndicator()),
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
        'usar minha localização',
        'atualizar área',
        'criar pista por ponto',
      ],
      filledFields: <String, String>{
        'pistas carregadas': _controller.livingClues.length.toString(),
        'conexões visíveis': _controller.connections.length.toString(),
        'modo criação de conexão': _isConnectingMode ? 'ativo' : 'inativo',
        if (_connectionSource != null)
          'origem da conexão': _connectionSource!.name,
        if (_connectionTarget != null)
          'destino da conexão': _connectionTarget!.name,
      },
      notes: <String>[
        'O mapa carrega as pistas pela área visível.',
        if (_isConnectingMode)
          'O usuário está criando uma conexão diretamente no mapa.',
      ],
    );
  }

  Color _categoryColor(LivingClueModel model) {
    final String? hex = model.category?.colorHex ??
        _controller.categoriesById[model.categoryId]?.colorHex;
    if (hex == null || hex.isEmpty) {
      debugPrint(
        '[LivingClueMap] fallback red for clue id=${model.id} '
        'name="${model.name}" categoryId=${model.categoryId} '
        'modelCategory=${model.category?.toJson()} '
        'cachedCategory=${_controller.categoriesById[model.categoryId]?.toJson()}',
      );
      return Colors.redAccent;
    }
    try {
      final colorString = '#${hex.replaceAll('#', '').trim()}';
      if (colorString.length == 7) {
        return Color(int.parse('0xff${colorString.substring(1)}'));
      } else if (colorString.length == 9) {
        return Color(int.parse(colorString.replaceFirst('#', '0x')));
      }
      debugPrint(
        '[LivingClueMap] invalid category color for clue id=${model.id} '
        'categoryId=${model.categoryId} hex="$hex" normalized="$colorString"',
      );
    } catch (error) {
      debugPrint(
        '[LivingClueMap] failed to parse category color for clue id=${model.id} '
        'categoryId=${model.categoryId} hex="$hex" error=$error',
      );
    }
    return Colors.redAccent;
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
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
