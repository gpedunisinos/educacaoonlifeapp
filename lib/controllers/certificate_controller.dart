import 'package:unisinos_usp_app/models/certificate_model.dart';
import 'package:unisinos_usp_app/webclients/certificate_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class CertificateController extends GetxController {
  CertificateWebclient webclient = CertificateWebclient();

  final RxList<CertificateModel> certificates = <CertificateModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({int? offset}) async {
    try {
      isLoading.value = true;

      final List<CertificateModel> fetchedList = await webclient.fetch(offset: offset);

      if (offset == 0) {
        certificates.assignAll(fetchedList);
      } else {
        certificates.addAll(fetchedList);
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela lista de Certificados. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
