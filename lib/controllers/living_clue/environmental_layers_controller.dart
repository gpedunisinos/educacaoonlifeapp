import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/models/environmental_layer_model.dart';
import 'package:unisinos_usp_app/webclients/environmental_layer_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class EnvironmentalLayersController extends GetxController {
  static const _enabledKey = 'environmental_map_enabled_layers';
  static const _opacityPrefix = 'environmental_map_opacity_';
  final EnvironmentalLayerWebclient webclient = EnvironmentalLayerWebclient();
  final layers = <EnvironmentalLayerModel>[].obs;
  final enabledIds = <String>{}.obs;
  final opacities = <String, double>{}.obs;
  final isLoading = false.obs;
  final RxnString errorMessage = RxnString();

  List<EnvironmentalLayerModel> get activeLayers => layers
      .where((layer) => layer.available && enabledIds.contains(layer.id))
      .toList();

  Future<void> load() async {
    if (isLoading.value || layers.isNotEmpty) return;
    isLoading.value = true;
    errorMessage.value = null;
    try {
      final preferences = await SharedPreferences.getInstance();
      final loaded = await webclient.fetch();
      layers.assignAll(loaded);
      enabledIds.assignAll(
        (preferences.getStringList(_enabledKey) ?? const <String>[]).where(
            (id) => loaded.any((layer) => layer.id == id && layer.available)),
      );
      for (final layer in loaded) {
        opacities[layer.id] =
            preferences.getDouble('$_opacityPrefix${layer.id}') ??
                layer.defaultOpacity;
      }
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      errorMessage.value = 'Não foi possível carregar as camadas ambientais.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggle(String id, bool enabled) async {
    enabled ? enabledIds.add(id) : enabledIds.remove(id);
    enabledIds.refresh();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_enabledKey, enabledIds.toList());
  }

  Future<void> setOpacity(String id, double opacity) async {
    opacities[id] = opacity;
    final preferences = await SharedPreferences.getInstance();
    await preferences.setDouble('$_opacityPrefix$id', opacity);
  }

  Future<void> disableAll() async {
    enabledIds.clear();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_enabledKey, const []);
  }
}
