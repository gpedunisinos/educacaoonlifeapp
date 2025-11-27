import 'package:unisinos_usp_app/models/configuration_model.dart';
import 'package:unisinos_usp_app/webclients/configuration_webclient.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:widgets_spo/utils.dart';

class ConfigurationController extends GetxController {
  final ConfigurationWebclient webclient = ConfigurationWebclient();

  final RxBool isLoading = false.obs;

  final RxList<ConfigurationModel> configurations = <ConfigurationModel>[].obs;
  final RxString appVersion = ''.obs;
  final RxString versionCode = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fetch();
    getAppVersion();
  }

  Future<void> fetch() async {
    try {
      isLoading.value = true;

      final List<ConfigurationModel> fetched = await webclient.fetch();

      configurations.assignAll(fetched);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Configurações. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = packageInfo.version;
      versionCode.value = packageInfo.buildNumber;
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace, message: 'Falha ao buscar a versão do app');
      appVersion.value = 'Desconhecida';
    }
  }

  Future<void> updateConfiguration(ConfigurationModel model, String newValue) async {
    try {
      isLoading.value = true;

      var updated = model.copyWith(value: newValue);
      updated = await webclient.update(updated);

      final int index = configurations.indexWhere((config) => config.id == updated.id);

      configurations[index] = updated;

      Get.successSnackbar('${updated.name} atualizado!');
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao atualizar a Configuração. $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getValueByTag(String tag) {
    final config = configurations.firstWhereOrNull((c) => c.tag == tag);

    return config?.value ?? '';
  }
}
