import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class UserEditorController extends GetxController {
  final UserWebclient webclient = UserWebclient();
  final TrailWebclient trailWebclient = TrailWebclient();
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    String? id = Get.parameters['id'];
    user.value = Get.arguments as UserModel?;

    if (user.value != null) {
      fetchById(user.value!.id);
    } else if (id != null && id != '0') {
      fetchById(id.toInt());
    }
  }

  Future<void> fetchById(int id) async {
    user.value = await webclient.fetchById(id);
    var trails = await trailWebclient.fetchUserTrailsByUserId(id);

    user.value = user.value!.copyWith(userTrails: trails);
  }

  Future<bool> saveUser(UserModel model, [List<int>? trailIds]) async {
    try {
      isLoading.value = true;

      if (model.id == 0) {
        final created = await createUser(model, trailIds);
        user.value = created;
        Get.successSnackbar('Usuário criado com sucesso!');
      } else {
        final updated = await updateUser(model, trailIds);
        user.value = updated;
        Get.successSnackbar('Usuário atualizado com sucesso!');
      }

      var userController = Get.find<UserController>();
      if (user.value!.id == userController.user.value!.id) {
        user.value!.token = userController.user.value!.token;
        userController.savePrefs(user.value!);
      }
    } catch (e, stack) {
      Util.debug(exception: e, stackTrace: stack);
      return false;
    } finally {
      isLoading.value = false;
    }

    return true;
  }

  Future<UserModel> createUser(UserModel user, [List<int>? trailIds]) async {
    try {
      return await webclient.createUser(user, trailIds: trailIds);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao criar Usuário. $error');
      rethrow;
    }
  }

  Future<UserModel> updateUser(UserModel model, [List<int>? trailIds]) async {
    try {
      model.password = '';
      return await webclient.update(model, trailIds: trailIds);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar Usuário. $error');
      rethrow;
    }
  }
}
