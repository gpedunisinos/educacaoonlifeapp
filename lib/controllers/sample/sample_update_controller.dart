import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/sample_model.dart';
import 'package:unisinos_usp_app/webclients/sample_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

class SampleUpdateController extends GetxController {
  final SampleWebclient _webclient = SampleWebclient();

  final Rxn<SampleModel> sample = Rxn<SampleModel>();
  final RxBool isLoading = false.obs;

  int? sampleId;

  @override
  void onInit() {
    super.onInit();
    sampleId = int.tryParse(Get.parameters['id'] ?? '');
    if (sampleId != null) {
      loadSample(sampleId!);
    }
  }

  Future<void> loadSample(int id) async {
    try {
      isLoading.value = true;
      sample.value = await _webclient.fetchById(id);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao carregar sample. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> save({
    required String name,
    required String sampleString,
    required String sampleUnique,
    required int sampleDetailId,
    required double sampleDouble,
    required DateTime sampleDate,
    int orderNumber = 0,
    String? nullableString,
  }) async {
    final int? id = sample.value?.id ?? sampleId;
    if (id == null) return false;

    final model = SampleModel(
      id: id,
      name: name.trim(),
      sampleString: sampleString.trim(),
      sampleUnique: sampleUnique.trim(),
      sampleDetailId: sampleDetailId,
      nullableString: nullableString?.trim().isEmpty == true ? null : nullableString?.trim(),
      sampleDouble: sampleDouble,
      sampleDate: sampleDate,
      orderNumber: orderNumber,
    );

    try {
      isLoading.value = true;
      await _webclient.update(model);
      Get.successSnackbar('Sample salvo com sucesso.');
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Não foi possível salvar o sample. $error');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
