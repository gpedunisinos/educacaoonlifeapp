import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/class_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class ClassesManagerController extends GetxController {
  final classes = <ClassModel>[].obs;

  final isLoading = false.obs;
  final trail = Rxn<TrailModel>();

  final webclient = ClassWebclient();

  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({String? text, int offset = 0}) async {
    try {
      isLoading.value = true;
      searchQuery = text ?? '';

      final result = await webclient.fetch(search: searchQuery, offset: offset);
      if (offset == 0) {
        classes.assignAll(result);
      } else {
        classes.addAll(result);
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao carregar aulas: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteClass(ClassModel classItem) async {
    try {
      await webclient.delete(classItem.id);
      classes.remove(classItem);
      Get.successSnackbar('A aula foi excluída com sucesso'.tlt, duration: Duration(seconds: 5));
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao excluir a aula. $error');
      rethrow;
    }
  }

  void addClassToList(ClassModel newClass) {
    classes.insert(0, newClass);
  }

  void updateClassInList(ClassModel updatedClass) {
    final index = classes.indexWhere((c) => c.id == updatedClass.id);
    if (index != -1) {
      classes[index] = updatedClass;
    }
  }

  Future<void> fetchByTrail(int selectedId) async {
    try {
      isLoading.value = true;

      final Map<String, String?> params = {'trail_id': selectedId.toString()};

      var result = await webclient.fetch(search: searchQuery, offset: 0, params: params);

      classes.assignAll(result);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao filtrar aulas pela Trilha. $e');
    } finally {
      isLoading.value = false;
    }
  }

  void reorderClasses(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final ClassModel item = classes.removeAt(oldIndex);
    classes.insert(newIndex, item);

    _updateOrderOnServer();
  }

  Future<void> _updateOrderOnServer() async {
    try {
      for (var i = 0; i < classes.length; i++) {
        classes[i] = classes[i].copyWith(order: i + 1);
        await webclient.update(classes[i]);
      }

      Get.successSnackbar('Ordem das aulas atualizada com sucesso!');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.snackbar('Erro', 'Falha ao salvar a nova ordem das aulas. $e');

      fetch();
    }
  }
}
