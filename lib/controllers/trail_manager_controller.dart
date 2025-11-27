import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailManagerController extends GetxController {
  final webclient = TrailWebclient();
  final trails = <TrailModel>[].obs;
  final isLoading = false.obs;

  String searchQuery = '';
  int? categoryId;

  TrailManagerController({int? categoryId}) {
    if (categoryId != null && categoryId > 0) {
      this.categoryId = categoryId;
    }
  }

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({String? text, int offset = 0}) async {
    try {
      isLoading.value = true;

      searchQuery = text ?? '';

      Map<String, String?> params = {'category_id': categoryId?.toString()};
      final result = await webclient.fetch(search: searchQuery, offset: offset, params: params);
      if (offset == 0) {
        trails.assignAll(result);
      } else {
        trails.addAll(result);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      final List<TrailModel> fetched = await webclient.fetchByCategory(id);

      trails.addAll(fetched);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela Trilha. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTrail(TrailModel trail) async {
    try {
      await webclient.delete(trail.id);
      trails.remove(trail);

      Get.successSnackbar('A Trilha foi excluída com sucesso'.tlt, duration: Duration(seconds: 5));
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao excluir a Trilha. $error');
      rethrow;
    }
  }

  Future<void> toggleStatus(TrailModel trail) async {
    try {
      final updatedTrail = trail.copyWith(status: !trail.status);

      final result = await webclient.update(updatedTrail);

      final index = trails.indexWhere((t) => t.id == trail.id);
      if (index != -1) {
        trails[index] = result;
      }

      Get.successSnackbar('A trilha ${trail.name} está com o status ${result.status ? 'ativado' : 'desativado'}.');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar o status da Trilha. $e');
    }
  }

  void reorderTrails(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final TrailModel item = trails.removeAt(oldIndex);
    trails.insert(newIndex, item);

    _updateOrderOnServer();
  }

  Future<void> _updateOrderOnServer() async {
    try {
      for (var i = 0; i < trails.length; i++) {
        trails[i] = trails[i].copyWith(order: i + 1);
        await webclient.update(trails[i]);
      }

      Get.snackbar('Sucesso', 'Ordem das trilhas atualizada com sucesso!');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.snackbar('Erro', 'Falha ao salvar a nova ordem das trilhas. $e');

      fetch();
    }
  }
}
