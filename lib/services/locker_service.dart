import 'package:get/get.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';

class LockerService extends GetxController {
  final items = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final error = RxnString();
  final busy = <String>{}.obs;
  final api = EconectivaApi();
  int generation = 0;
  void clear() {
    generation++;
    busy.clear();
    items.clear();
    error.value = null;
  }

  bool saved(String type, int id) =>
      items.any((e) => e['entity_type'] == type && e['entity_id'] == id);
  Future<void> load() async {
    final version = generation;
    loading.value = true;
    error.value = null;
    try {
      final data = await api.get('/me/locker');
      if (version != generation) return;
      items.assignAll((data as List).map((e) => Map<String, dynamic>.from(e)));
    } catch (_) {
      if (version == generation) {
        error.value = 'Não foi possível carregar seu Locker.';
      }
    } finally {
      if (version == generation) loading.value = false;
    }
  }

  Future<void> toggle(String type, int id) async {
    final version = generation;
    final key = '$type:$id';
    if (busy.contains(key)) return;
    busy.add(key);
    try {
      if (saved(type, id)) {
        await api.write('DELETE', '/me/locker/$type/$id');
        if (version != generation) return;
        items.removeWhere(
            (e) => e['entity_type'] == type && e['entity_id'] == id);
      } else {
        final item = await api.write('PUT', '/me/locker/$type/$id');
        if (version != generation) return;
        items.insert(0, Map<String, dynamic>.from(item));
      }
    } catch (_) {
      Get.snackbar(
          'Locker', 'Não foi possível salvar a alteração. Tente novamente.');
    } finally {
      if (version == generation) busy.remove(key);
    }
  }
}
