import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/models/nominatim_place_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/webclients/clue_connection_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:unisinos_usp_app/webclients/nominatim_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

enum LivingClueMapLoadMode { bounds, radius, search }

class LivingClueMapController extends GetxController {
  final LivingClueWebclient _webclient = LivingClueWebclient();
  final ClueConnectionWebclient _connectionWebclient =
      ClueConnectionWebclient();
  final CategoryWebclient _categoryWebclient = CategoryWebclient();
  final NominatimWebclient _nominatimWebclient = NominatimWebclient();

  final RxList<LivingClueModel> livingClues = <LivingClueModel>[].obs;
  final RxList<NominatimPlaceModel> mapPlaces = <NominatimPlaceModel>[].obs;
  final RxList<ClueConnectionModel> connections = <ClueConnectionModel>[].obs;
  final RxMap<int, CategoryModel> categoriesById = <int, CategoryModel>{}.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<LatLng> sonarCenter = Rxn<LatLng>();
  final RxDouble sonarRadius = 1000.0.obs;
  final Rx<LivingClueMapLoadMode> loadMode = LivingClueMapLoadMode.bounds.obs;
  final RxString activeSearch = ''.obs;
  bool _loadingConnections = false;
  bool _loadingCategories = false;
  int _requestSerial = 0;

  Future<void> loadByBounds(LatLngBounds bounds) async {
    final int requestId = ++_requestSerial;
    errorMessage.value = null;
    activeSearch.value = '';
    loadMode.value = LivingClueMapLoadMode.bounds;
    mapPlaces.clear();
    try {
      isLoading.value = true;
      final loadedClues = await _webclient.fetchByBounds(
        north: bounds.north,
        south: bounds.south,
        east: bounds.east,
        west: bounds.west,
      );
      if (requestId != _requestSerial) return;
      livingClues.assignAll(loadedClues);
      await _loadCategories();
      await _loadConnections();
    } catch (error, stackTrace) {
      if (requestId != _requestSerial) return;
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Falha ao carregar pistas no mapa.';
    } finally {
      if (requestId == _requestSerial) {
        isLoading.value = false;
      }
    }
  }

  Future<void> searchAround(LatLng center, double radiusMeters) async {
    final int requestId = ++_requestSerial;
    errorMessage.value = null;
    sonarCenter.value = center;
    sonarRadius.value = radiusMeters;
    activeSearch.value = '';
    loadMode.value = LivingClueMapLoadMode.radius;
    mapPlaces.clear();
    try {
      isLoading.value = true;
      final loadedClues = await _webclient.searchByRadius(
        latitude: center.latitude,
        longitude: center.longitude,
        radiusMeters: radiusMeters,
      );
      if (requestId != _requestSerial) return;
      livingClues.assignAll(loadedClues);
      await _loadCategories();
      await _loadConnections();
    } catch (error, stackTrace) {
      if (requestId != _requestSerial) return;
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Falha ao buscar pelo raio informado.';
    } finally {
      if (requestId == _requestSerial) {
        isLoading.value = false;
      }
    }
  }

  Future<void> searchGlobal(String search) async {
    final trimmedSearch = search.trim();
    if (trimmedSearch.isEmpty) {
      return;
    }

    final int requestId = ++_requestSerial;
    errorMessage.value = null;
    activeSearch.value = trimmedSearch;
    loadMode.value = LivingClueMapLoadMode.search;
    mapPlaces.clear();
    try {
      isLoading.value = true;
      final loadedClues = await _webclient.search(search: trimmedSearch);
      List<NominatimPlaceModel> loadedPlaces = <NominatimPlaceModel>[];
      try {
        loadedPlaces = await _nominatimWebclient.search(search: trimmedSearch);
      } catch (error, stackTrace) {
        Util.debug(exception: error, stackTrace: stackTrace);
      }
      if (requestId != _requestSerial) return;
      livingClues.assignAll(loadedClues);
      mapPlaces.assignAll(loadedPlaces);
      await _loadCategories();
      await _loadConnections();
    } catch (error, stackTrace) {
      if (requestId != _requestSerial) return;
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Falha ao pesquisar pistas.';
    } finally {
      if (requestId == _requestSerial) {
        isLoading.value = false;
      }
    }
  }

  Future<LatLng?> currentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        errorMessage.value = 'Permissão de localização negada.';
        return null;
      }
      final Position position = await Geolocator.getCurrentPosition();
      return LatLng(position.latitude, position.longitude);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Não foi possível obter sua localização.';
      return null;
    }
  }

  Future<void> _loadConnections() async {
    if (_loadingConnections) return;
    _loadingConnections = true;
    try {
      connections.assignAll(await _connectionWebclient.fetch());
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
    } finally {
      _loadingConnections = false;
    }
  }

  Future<bool> updatePosition(
    LivingClueModel clue,
    LatLng newPosition,
  ) async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final LivingClueModel updatedModel = LivingClueModel(
        id: clue.id,
        name: clue.name,
        biomeId: clue.biomeId,
        categoryId: clue.categoryId,
        description: clue.description,
        descriptionDelta: clue.descriptionDelta,
        latitude: newPosition.latitude,
        longitude: newPosition.longitude,
        imageUrl: clue.imageUrl,
        metadata: clue.metadata,
        isActive: clue.isActive,
        createdAt: clue.createdAt,
        updatedAt: clue.updatedAt,
        category: clue.category,
      );

      final saved = await _webclient.update(updatedModel);
      final int index = livingClues.indexWhere((item) => item.id == clue.id);
      if (index >= 0) {
        livingClues[index] = saved;
        livingClues.refresh();
      }
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Não foi possível atualizar a posição da pista.';
      Get.customSnackbar(
          'Erro', 'Não foi possível atualizar a posição da pista.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    if (_loadingCategories || categoriesById.isNotEmpty) return;
    _loadingCategories = true;
    try {
      final categories = await _categoryWebclient.fetch();
      categoriesById.assignAll({
        for (final category in categories) category.id: category,
      });
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
    } finally {
      _loadingCategories = false;
    }
  }
}
