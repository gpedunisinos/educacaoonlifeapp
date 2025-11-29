import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';

class LivingClueMapCreateScreen extends StatefulWidget {
  const LivingClueMapCreateScreen({super.key});

  @override
  State<LivingClueMapCreateScreen> createState() => _LivingClueMapCreateScreenState();
}

class _LivingClueMapCreateScreenState extends State<LivingClueMapCreateScreen> {
  final MapController _mapController = MapController();
  LatLng _center = const LatLng(-29.718, -51.143);
  LatLng? _selected;
  bool _loadingLocation = false;

  @override
  void initState() {
    super.initState();
    _prefillFromArgs();
  }

  void _prefillFromArgs() {
    final args = Get.arguments;
    if (args is Map) {
      final lat = args['latitude'];
      final lng = args['longitude'];
      if (lat is num && lng is num) {
        _center = LatLng(lat.toDouble(), lng.toDouble());
        _selected = _center;
      }
    }
  }

  Future<void> _useCurrentLocation() async {
    try {
      setState(() => _loadingLocation = true);
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
        Get.snackbar('Permissão necessária', 'Habilite a localização para usar sua posição atual.');
        return;
      }
      final Position position = await Geolocator.getCurrentPosition();
      final LatLng point = LatLng(position.latitude, position.longitude);
      setState(() {
        _center = point;
        _selected = point;
      });
      _mapController.move(point, 15);
    } catch (_) {
      Get.snackbar('Localização', 'Não foi possível obter sua localização.');
    } finally {
      setState(() => _loadingLocation = false);
    }
  }

  void _onLongPress(TapPosition tapPosition, LatLng latLng) {
    setState(() {
      _selected = latLng;
    });
  }

  void _clearSelection() {
    setState(() => _selected = null);
  }

  Future<void> _goToCreate() async {
    if (_selected == null) {
      Get.snackbar('Selecione um ponto', 'Pressione e segure no mapa para marcar a localização.');
      return;
    }
    final result = await Get.toNamed(
      '/living_clues/pre_create',
      arguments: {
        'latitude': _selected!.latitude,
        'longitude': _selected!.longitude,
      },
    );
    if (result == true) {
      Get.back(result: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedText = _selected == null
        ? 'Nenhum ponto selecionado'
        : 'Ponto selecionado: ${_selected!.latitude.toStringAsFixed(6)}, ${_selected!.longitude.toStringAsFixed(6)}';

    return Scaffold(
      appBar: AppBar(
        leading: const SafeBackButton(),
        title: const Text('Escolher local da pista'),
        actions: [
          IconButton(
            tooltip: 'Usar minha localização',
            icon: _loadingLocation
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            onPressed: _loadingLocation ? null : _useCurrentLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13,
              onLongPress: _onLongPress,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.br.spotecnologia.uniuspapp',
              ),
              if (_selected != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _selected!,
                      color: Colors.blue.withOpacity(0.25),
                      borderColor: Colors.blue,
                      borderStrokeWidth: 2,
                      radius: 18,
                    ),
                  ],
                ),
              if (_selected != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selected!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: Colors.blue, size: 36),
                    ),
                  ],
                ),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Segure no mapa para marcar a latitude/longitude.'),
                    const SizedBox(height: 6),
                    Text(
                      selectedText,
                      style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: _selected == null ? null : _clearSelection,
                          icon: const Icon(Icons.clear),
                          label: const Text('Remover ponto'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Continuar com este ponto'),
              onPressed: _selected == null ? null : _goToCreate,
            ),
          ),
        ],
      ),
    );
  }
}
