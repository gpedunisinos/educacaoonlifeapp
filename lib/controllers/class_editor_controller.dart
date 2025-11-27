import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/class_webclient.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class ClassEditorController extends GetxController {
  final ClassWebclient webclient = ClassWebclient();
  final TrailWebclient trailWebclient = TrailWebclient();

  final Rxn<ClassModel> classItem = Rxn<ClassModel>();
  final Rxn<TrailModel> trailItem = Rxn<TrailModel>();

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      classItem.value = arguments['class'] as ClassModel?;
      var trailId = arguments['trailId'] as int?;

      if (trailId != null && trailId > 0) {
        fetchTrail(trailId);
      }
    }
  }

  Future<void> saveClass(ClassModel model) async {
    try {
      isLoading.value = true;
      final ClassModel? result;

      if (model.id == 0) {
        result = await createClass(model.copyWith(trailId: trailItem.value?.id));
        Get.successSnackbar('Aula criada com sucesso!');
      } else {
        result = await updateClass(model);
        Get.successSnackbar('Aula atualizada com sucesso!');
      }
      classItem.value = result;
    } catch (e, stack) {
      Util.debug(exception: e, stackTrace: stack);
      Get.customSnackbar('Erro', 'Erro ao salvar Aula. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<ClassModel> createClass(ClassModel model) async {
    try {
      isLoading.value = true;

      return await webclient.add(model);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao criar Aula. $error');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<ClassModel> updateClass(ClassModel model) async {
    try {
      isLoading.value = true;

      return await webclient.update(model);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar Aula. $error');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      webclient.fetchById(id).then((c) => classItem.value = c);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao buscar Aula. $error');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTrail(int id) async {
    try {
      isLoading.value = true;

      trailWebclient.fetchById(id).then((trail) => trailItem.value = trail);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao buscar Trilha. $error');
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
