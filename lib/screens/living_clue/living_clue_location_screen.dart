import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/models/environmental_layer_model.dart';
import 'package:unisinos_usp_app/models/nominatim_place_model.dart';
import 'package:unisinos_usp_app/webclients/environmental_layer_webclient.dart';
import 'package:unisinos_usp_app/webclients/nominatim_webclient.dart';
import 'package:widgets_spo/services/auth_provider.dart';

class LivingClueLocationScreen extends StatefulWidget {
  const LivingClueLocationScreen({
    super.key,
    this.initialPoint,
    this.searchPlaces,
    this.loadLayers,
    this.tileProvider,
  });
  final LatLng? initialPoint;
  final Future<List<NominatimPlaceModel>> Function(String)? searchPlaces;
  final Future<List<EnvironmentalLayerModel>> Function()? loadLayers;
  final TileProvider? tileProvider;

  @override
  State<LivingClueLocationScreen> createState() =>
      _LivingClueLocationScreenState();
}

class _LivingClueLocationScreenState extends State<LivingClueLocationScreen> {
  final _map = MapController();
  final _search = TextEditingController();
  final _layersClient = EnvironmentalLayerWebclient();
  LatLng? _point;
  EnvironmentalLayerModel? _satelliteLayer;
  List<NominatimPlaceModel> _results = [];
  bool _satellite = false;
  bool _searching = false;
  bool _loadingLayers = true;
  String? _searchError;
  String? _layerError;

  @override
  void initState() {
    super.initState();
    _point = widget.initialPoint;
    _loadLayers();
  }

  Future<void> _loadLayers() async {
    setState(() {
      _loadingLayers = true;
      _layerError = null;
    });
    try {
      final layers = await (widget.loadLayers?.call() ?? _layersClient.fetch())
          .timeout(const Duration(seconds: 30));
      if (!mounted) return;
      final available = layers.where((l) => l.id == 'satellite' && l.available);
      setState(() {
        _satelliteLayer = available.firstOrNull;
        if (_satelliteLayer == null) {
          _layerError = 'Imagem de satélite indisponível.';
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _layerError = 'Não foi possível carregar o satélite.');
      }
    } finally {
      if (mounted) setState(() => _loadingLayers = false);
    }
  }

  Future<void> _findPlace() async {
    final query = _search.text.trim();
    if (query.isEmpty || _searching) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _searching = true;
      _searchError = null;
      _results = [];
    });
    try {
      final results =
          await (widget.searchPlaces?.call(query) ??
                  NominatimWebclient().search(search: query))
              .timeout(const Duration(seconds: 20));
      if (!mounted) return;
      setState(() {
        _results = results;
        if (results.isEmpty) {
          _searchError =
              'Nenhum local encontrado. Tente cidade, endereço ou CEP.';
        }
      });
    } catch (_) {
      if (mounted) {
        setState(
          () => _searchError =
              'Não foi possível pesquisar. Tente novamente ou toque no mapa.',
        );
      }
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _choosePlace(NominatimPlaceModel place) {
    final point = LatLng(place.latitude, place.longitude);
    setState(() {
      _point = point;
      _results = [];
      _search.text = place.displayName;
    });
    _map.move(point, 16);
  }

  @override
  void dispose() {
    _map.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final satellite = _satellite ? _satelliteLayer : null;
    return Scaffold(
      appBar: AppBar(title: const Text('Localizar pista viva')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _search,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _findPlace(),
                decoration: InputDecoration(
                  labelText: 'Pesquisar local',
                  hintText: 'Cidade, endereço, lugar ou CEP',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searching
                      ? const Padding(
                          padding: EdgeInsets.all(14),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          tooltip: 'Pesquisar',
                          onPressed: _findPlace,
                          icon: const Icon(Icons.arrow_forward),
                        ),
                ),
              ),
            ),
            if (_searchError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(_searchError!),
              ),
            if (_results.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * .23,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final place in _results)
                      ListTile(
                        leading: const Icon(Icons.place_outlined),
                        title: Text(
                          place.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _choosePlace(place),
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Toque no mapa para posicionar o marcador.'),
                  ),
                  FilterChip(
                    avatar: const Icon(Icons.satellite_alt, size: 18),
                    label: Text(_loadingLayers ? 'Carregando…' : 'Satélite'),
                    selected: _satellite,
                    onSelected: _satelliteLayer == null
                        ? null
                        : (value) => setState(() => _satellite = value),
                  ),
                ],
              ),
            ),
            if (_layerError != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _layerError!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: _loadingLayers ? null : _loadLayers,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _map,
                    options: MapOptions(
                      initialCenter: _point ?? const LatLng(-29.794, -51.151),
                      initialZoom: _point == null ? 10 : 16,
                      minZoom: 3,
                      maxZoom: 19,
                      onTap: (_, point) => setState(() => _point = point),
                    ),
                    children: [
                      TileLayer(
                        key: ValueKey(satellite?.id ?? 'osm'),
                        urlTemplate: satellite == null
                            ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                            : _layersClient.absoluteTileUrl(satellite),
                        userAgentPackageName: 'com.br.spotecnologia.uniusp_app',
                        maxNativeZoom: satellite?.maxZoom ?? 19,
                        tileProvider:
                            widget.tileProvider ??
                            (satellite == null
                                ? null
                                : NetworkTileProvider(
                                    headers: {
                                      'Authorization':
                                          'Bearer ${AuthProvider.instance.getToken()}',
                                    },
                                  )),
                      ),
                      if (_point != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _point!,
                              width: 48,
                              height: 48,
                              alignment: Alignment.topCenter,
                              child: const Icon(
                                Icons.location_pin,
                                size: 48,
                                color: Color(0xFFDD285D),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: Card(
                      child: Column(
                        children: [
                          IconButton(
                            tooltip: 'Aproximar',
                            onPressed: () => _map.move(
                              _map.camera.center,
                              (_map.camera.zoom + 1).clamp(3, 19),
                            ),
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            tooltip: 'Afastar',
                            onPressed: () => _map.move(
                              _map.camera.center,
                              (_map.camera.zoom - 1).clamp(3, 19),
                            ),
                            icon: const Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ColoredBox(
                      color: const Color(0xDEFFFFFF),
                      child: Text(
                        satellite?.attribution ??
                            '© OpenStreetMap contributors',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _point == null
                        ? 'Selecione um ponto para continuar.'
                        : '${_point!.latitude.toStringAsFixed(6)}, ${_point!.longitude.toStringAsFixed(6)}',
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _point == null
                          ? null
                          : () => Navigator.of(context).pop(_point),
                      icon: const Icon(Icons.check),
                      label: const Text('Usar esta localização'),
                    ),
                  ),
                  const Text(
                    'A localização será salva ao salvar a pista.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
