import 'package:unisinos_usp_app/models/notification_model.dart';
import 'package:unisinos_usp_app/webclients/notification_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class NotificationController extends GetxController {
  final NotificationWebclient webclient = NotificationWebclient();
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  final RxBool isloading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetch();
  }

  Future<void> fetch({String? search, int? limit, int? offset}) async {
    try {
      isloading.value = true;

      final List<NotificationModel> fetched = await webclient.fetch(search: search, offset: offset, limit: limit);
      if (offset == 0) {
        notifications.assignAll(fetched);
      } else {
        notifications.addAll(fetched);
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Notificações. $e');
    } finally {
      isloading.value = false;
    }
  }
}
