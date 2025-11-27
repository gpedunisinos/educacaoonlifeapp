import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/firebase_options.dart';
import 'package:unisinos_usp_app/services/user_auth_service.dart';
import 'package:widgets_spo/services/auth_provider.dart';
import 'package:widgets_spo/utils.dart';

class Initializer {
  static Future<void> init() async {
    setPathUrlStrategy();

    await Util.initPrefs();
    AuthProvider.register(UserAuthService());
    Get.put<UserController>(UserController(), permanent: true);

    if (_supportsFirebaseCore()) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    NavigationObserver.initialize(homeResolver: () {
      final controller = Get.find<UserController>();
      return controller.isLoggedIn ? '/home' : '/login';
    });
  }
}

bool _supportsFirebaseCore() {
  if (kIsWeb) return true;
  return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
}
