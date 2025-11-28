import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/controllers/living_clue/living_clue_map_controller.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';

class LivingClueMapScreen extends StatefulWidget {
  const LivingClueMapScreen({super.key});

  @override
  State<LivingClueMapScreen> createState() => _LivingClueMapScreenState();
}

class _LivingClueMapScreenState extends State<LivingClueMapScreen> {
  final LivingClueMapController _controller = Get.find<LivingClueMapController>();
  final MapController _mapController = MapController();
  LatLng _tapCenter = const LatLng(-29.718, -51.143);

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
      _tapCenter = position;
      await _controller.searchAround(position, _controller.sonarRadius.value);
    }
  }

  Future<void> _searchByTap() async {
    await _controller.searchAround(_tapCenter, _controller.sonarRadius.value);
    _mapController.move(_tapCenter, _mapController.camera.zoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de pistas vivas'),
        actions: [
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
              if (created == true) {
                _loadCurrentBounds();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Text('Raio:'),
                      Expanded(
                        child: Obx(() {
                          return Slider(
                            value: _controller.sonarRadius.value,
                            min: 100,
                            max: 2000,
                            divisions: 19,
                            label: '${_controller.sonarRadius.value.toInt()} m',
                            onChanged: (value) => _controller.sonarRadius.value = value,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  tooltip: 'Usar minha localização',
                  onPressed: _useCurrentLocation,
                ),
                IconButton(
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
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () => _showClueSheet(item),
                        child: const Icon(Icons.location_on, color: Colors.red, size: 32),
                      ),
                    ),
                  )
                  .toList();

              final circles = <CircleMarker>[];
              if (_controller.sonarCenter.value != null) {
                circles.add(
                  CircleMarker(
                    point: _controller.sonarCenter.value!,
                    color: Colors.blue.withOpacity(0.2),
                    borderStrokeWidth: 1,
                    borderColor: Colors.blue,
                    radius: _controller.sonarRadius.value,
                  ),
                );
              }

              return Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _tapCenter,
                      initialZoom: 13,
                      onMapEvent: (event) {
                        if (event is MapEventMoveEnd) {
                          _loadCurrentBounds();
                        }
                      },
                      onLongPress: (tapPos, latLng) {
                        setState(() => _tapCenter = latLng);
                        _controller.sonarCenter.value = latLng;
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.br.spotecnologia.uniusp_app',
                      ),
                      if (circles.isNotEmpty) CircleLayer(circles: circles),
                      MarkerLayer(markers: markers),
                    ],
                  ),
                  if (_controller.isLoading.value)
                    const Positioned.fill(
                      child: IgnorePointer(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.radar),
                      label: const Text('Buscar por raio (tap longo para escolher o ponto)'),
                      onPressed: _searchByTap,
                    ),
                  ),
                  if (_controller.errorMessage.value != null)
                    Positioned(
                      top: 12,
                      left: 16,
                      right: 16,
                      child: Card(
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
    );
  }

  void _showClueSheet(LivingClueModel model) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final categoryName = model.category?.name ?? 'Categoria: ${model.categoryId}';
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(categoryName, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(model.description ?? 'Sem descrição'),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.visibility),
                  label: const Text('Ver'),
                  onPressed: () {
                    Get.back(); // fecha o bottomSheet
                    Get.toNamed('/living_clues/show', arguments: model);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
