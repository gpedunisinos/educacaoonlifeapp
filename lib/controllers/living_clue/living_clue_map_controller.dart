import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueMapController extends GetxController {
  final LivingClueWebclient _webclient = LivingClueWebclient();

  final RxList<LivingClueModel> livingClues = <LivingClueModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<LatLng> sonarCenter = Rxn<LatLng>();
  final RxDouble sonarRadius = 500.0.obs; // metros

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
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Falha ao carregar pistas no mapa.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchAround(LatLng center, double radiusMeters) async {
    errorMessage.value = null;
    sonarCenter.value = center;
    sonarRadius.value = radiusMeters;
    try {
      isLoading.value = true;
      livingClues.assignAll(await _webclient.searchByRadius(
        latitude: center.latitude,
        longitude: center.longitude,
        radiusMeters: radiusMeters,
      ));
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Falha ao buscar pelo raio informado.';
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
      if (permission == LocationPermission.deniedForever || permission == LocationPermission.denied) {
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
}
