import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class SafeGetSnackbar {
  static bool get _canShow => Get.overlayContext != null || Get.context != null;

  static void success(String message) {
    if (!_canShow) return;
    Get.successSnackbar(message);
  }

  static void error(String title, String message) {
    if (!_canShow) return;
    Get.customSnackbar(title, message);
  }
}
