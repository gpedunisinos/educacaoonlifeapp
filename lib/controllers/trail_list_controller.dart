import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailListController extends GetxController {
  final TrailWebclient webclient = TrailWebclient();
  final RxList<TrailModel> trailsList = RxList<TrailModel>();

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    final categoryId = Get.parameters['category_id'];

    if (categoryId != null) {
      fetchById(categoryId.toInt());
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      final List<TrailModel> fetched = await webclient.fetchByCategory(id);

      trailsList.addAll(fetched);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela Trilha. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
