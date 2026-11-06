import 'package:unisinos_usp_app/services/participant_chat/participant_chat_service.dart';
import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/services/locker_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/ai_assistant/ai_assistant_controller.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/user_auth_service.dart';
import 'package:widgets_spo/services/auth_provider.dart';
import 'package:widgets_spo/utils.dart';

class Initializer {
  static Future<void> init() async {
    if (kIsWeb) {
      // Keep hash-based routing on web so direct refreshes work without server rewrite rules.
      setUrlStrategy(const HashUrlStrategy());
    }

    await Util.initPrefs();
    AuthProvider.register(UserAuthService());
    Get.put<LockerService>(LockerService(), permanent: true);
    final userController = Get.put<UserController>(
      UserController(),
      permanent: true,
    );
    Get.put<PresenceService>(
      PresenceService(),
      permanent: true,
    ).attach(userController);
    Get.put<ParticipantChatService>(
      ParticipantChatService(),
      permanent: true,
    ).attach(userController, Get.find<PresenceService>());
    // Resolve the account preference before guards evaluate an initial deep link.
    await userController.initialization;
    Get.put<AiAssistantContextService>(
      AiAssistantContextService(),
      permanent: true,
    );
    Get.put<AiAssistantController>(AiAssistantController(), permanent: true);

    NavigationObserver.initialize(
      homeResolver: () {
        final controller = Get.find<UserController>();
        return controller.isLoggedIn ? controller.modeHome : '/login';
      },
    );
  }
}
