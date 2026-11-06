import 'package:geolocator/geolocator.dart';
import 'package:unisinos_usp_app/services/location_privacy_service.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
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
    this.onConfirm,
    this.onPointChanged,
    this.actions = const [],
  });
  final Future<void> Function(LatLng)? onConfirm;
  final ValueChanged<LatLng?>? onPointChanged;
  final List<Widget> actions;
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
  bool _satellite = true;
  bool _searching = false;
  bool _locating = false;
  bool _confirming = false;
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
        _satellite = _satelliteLayer != null;
        if (_satelliteLayer == null) {
          _layerError = 'Imagem de satélite indisponível.';
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _satellite = false;
          _layerError = 'Não foi possível carregar o satélite.';
        });
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
    widget.onPointChanged?.call(point);
    _map.move(point, 16);
  }

  Future<void> _useCurrentLocation() async {
    if (_locating ||
        !await LocationPrivacyService.ensureAcknowledged(context) ||
        !mounted)
      return;
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied)
        permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever)
        throw StateError('location denied');
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      final point = LatLng(position.latitude, position.longitude);
      setState(() => _point = point);
      widget.onPointChanged?.call(point);
      _map.move(point, 16);
    } catch (_) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Não foi possível obter sua localização. Pesquise um local ou escolha no mapa.',
            ),
          ),
        );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Future<void> _confirmPoint() async {
    if (_point == null || _confirming) return;
    if (widget.onConfirm == null) {
      Navigator.of(context).pop(_point);
      return;
    }
    setState(() => _confirming = true);
    try {
      await widget.onConfirm!(_point!);
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
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
    return Theme(
      data: spaceRecordTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Localizar pista viva'),
          actions: [
            IconButton(
              tooltip: 'Usar minha localização',
              onPressed: _locating ? null : _useCurrentLocation,
              icon: const Icon(Icons.my_location),
            ),
            ...widget.actions,
          ],
        ),
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
                    const SizedBox(width: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        ChoiceChip(
                          label: const Text('Mapa'),
                          selected: !_satellite,
                          onSelected: (_) => setState(() => _satellite = false),
                        ),
                        ChoiceChip(
                          label: Text(
                            _loadingLayers ? 'Carregando…' : 'Satélite',
                          ),
                          selected: _satellite,
                          onSelected: _satelliteLayer == null
                              ? null
                              : (_) => setState(() => _satellite = true),
                        ),
                      ],
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
                        onTap: (_, point) {
                          setState(() => _point = point);
                          widget.onPointChanged?.call(point);
                        },
                      ),
                      children: [
                        TileLayer(
                          key: ValueKey(satellite?.id ?? 'osm'),
                          urlTemplate: satellite == null
                              ? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
                              : _layersClient.absoluteTileUrl(satellite),
                          userAgentPackageName:
                              'com.br.spotecnologia.uniusp_app',
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
                        onPressed: _point == null || _confirming
                            ? null
                            : _confirmPoint,
                        icon: const Icon(Icons.check),
                        label: const Text('Usar esta localização'),
                      ),
                    ),
                    if (_point != null)
                      TextButton.icon(
                        onPressed: _confirming
                            ? null
                            : () {
                                setState(() => _point = null);
                                widget.onPointChanged?.call(null);
                              },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Remover ponto'),
                      ),
                    const Text(
                      'Escolha um ponto público ou aproximado. A localização será salva ao salvar a pista.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
