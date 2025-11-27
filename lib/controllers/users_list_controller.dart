import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class UsersListController extends GetxController {
  final UserWebclient webclient = UserWebclient();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxString searchQuery = ''.obs;
  final RxString filterByProfile = ''.obs;
  final Rx<bool?> filterByStatus = Rx<bool?>(null);
  final RxString sortBy = ''.obs;
  final RxString orderBy = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({int? offset}) async {
    if (isLoading.value) {
      return;
    }

    try {
      isLoading.value = true;

      final List<UserModel> fetchedUsers = await webclient.fetchUsers(
        search: searchQuery.value,
        profileType: ProfileTypeEnum.values.firstWhereOrNull((e) => e.name == filterByProfile.value),
        status: filterByStatus.value,
        sort: sortBy.value,
        order: orderBy.value,
        offset: offset,
      );

      if (offset == null || offset == 0) {
        users.assignAll(fetchedUsers);
      } else {
        users.addAll(fetchedUsers);
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelos Usuários. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await webclient.deleteAccount(user);

      users.removeWhere((u) => u.id == user.id);
      users.refresh();

      Get.successSnackbar('Usuário ${user.name} excluído com sucesso.');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao excluir o usuário ${user.name}. $e');
    }
  }

  Future<void> toggleUserStatus(UserModel user) async {
    try {
      if (user.id == Get.find<UserController>().user.value!.id) {
        Get.customSnackbar('Erro', 'Não é possível alterar o próprio usuário.');
        return;
      }

      user.password = ''; // must remove pass

      UserModel model = await webclient.update(user.copyWith(status: !user.status));

      final index = users.indexWhere((u) => u.id == model.id);

      if (index != -1) {
        users[index] = model;
      }

      Get.successSnackbar('Usuário ${user.name} está com o status ${model.status ? 'ativado' : 'desativado'}.');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar o status do usuário. $e');
    }
  }
}
