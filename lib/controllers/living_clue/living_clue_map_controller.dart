import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/webclients/clue_connection_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueMapController extends GetxController {
  final LivingClueWebclient _webclient = LivingClueWebclient();
  final ClueConnectionWebclient _connectionWebclient =
      ClueConnectionWebclient();
  final CategoryWebclient _categoryWebclient = CategoryWebclient();

  final RxList<LivingClueModel> livingClues = <LivingClueModel>[].obs;
  final RxList<ClueConnectionModel> connections = <ClueConnectionModel>[].obs;
  final RxMap<int, CategoryModel> categoriesById = <int, CategoryModel>{}.obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  bool _loadingConnections = false;
  bool _loadingCategories = false;

  Future<void> loadByBounds(LatLngBounds bounds) async {
    errorMessage.value = null;
    try {
      isLoading.value = true;
      livingClues.assignAll(await _webclient.fetchByBounds(
        north: bounds.north,
        south: bounds.south,
        east: bounds.east,
        west: bounds.west,
      ));
      await _loadCategories();
      await _loadConnections();
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Falha ao carregar pistas no mapa.';
    } finally {
      isLoading.value = false;
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
