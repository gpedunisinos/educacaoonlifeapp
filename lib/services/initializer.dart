import 'package:dynamic_path_url_strategy/dynamic_path_url_strategy.dart';
import 'package:unisinos_usp_app/controllers/mfile_controller.dart';
import 'package:unisinos_usp_app/controllers/notification_controller.dart';
import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/firebase_options.dart';
import 'package:unisinos_usp_app/middlewares/route_middleware.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/services/local_notification_service.dart';
import 'package:unisinos_usp_app/services/user_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/services/auth_provider.dart';
import 'package:widgets_spo/utils.dart';

class Initializer {
  static Future<void> init() async {
    setPathUrlStrategy();

    await Util.initPrefs();
    AuthProvider.register(UserAuthService());
    Get.put<UserController>(UserController(), permanent: true);
    Get.put<MfileController>(MfileController(), permanent: true);
    Get.lazyPut<IAuthService>(() => Get.find<UserController>(), fenix: true);

    final supportsFirebaseCore = _supportsFirebaseCore();
    final supportsLocalNotifications = _supportsLocalNotifications();
    final supportsFirebaseMessaging = _supportsFirebaseMessaging();

    if (supportsFirebaseCore) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    if (supportsLocalNotifications) {
      await LocalNotificationsService.init();
    }

    if (supportsFirebaseMessaging) {
      if (_supportsBackgroundMessaging()) {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      }

      final messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (_isApplePlatform()) {
        await messaging.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

        messaging.getAPNSToken().then((apnsToken) {
          print('APNs Token: $apnsToken');
        });
      }

      messaging.getToken().then((token) {
        print('Firebase Messaging Token: $token');
      });

      print('User granted permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('Notificação recebida: ${message.notification?.title}');

        final controller = Get.isRegistered<NotificationController>() ? Get.find<NotificationController>() : null;
        controller?.fetch();

        if (!kIsWeb) {
          LocalNotificationsService.showNotification(
            id: message.messageId.hashCode,
            title: message.notification?.title,
            body: message.notification?.body,
          );
        } else if (kIsWeb) {
          final title = message.notification?.title ?? 'Nova Notificação';
          final body = message.notification?.body ?? 'Verifique a lista de notificações.';

          Get.snackbar(
            title,
            body,
            barBlur: 0,
            backgroundColor: Colors.white60,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        }
      });

      if (!kIsWeb) {
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          debugPrint('Usuário clicou na notificação: ${message.data}');
        });
      }
    }

    NavigationObserver.initialize(homeResolver: () {
      UserModel? user = Get.find<UserController>().user.value;
      if (user == null) {
        return '/login';
      } else if (user.isAdmin) {
        return '/teacher_home';
      } else if (user.isStudent) {
        return '/student_home';
      } else if (user.profileType == ProfileTypeEnum.teacher) {
        return '/teacher_home';
      } else {
        return '/login';
      }
    });
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (!_supportsFirebaseCore()) {
    return;
  }

  await Firebase.initializeApp();
  debugPrint('Mensagem recebida em background: ${message.messageId}');

  final controller = Get.isRegistered<NotificationController>() ? Get.find<NotificationController>() : null;
  controller?.fetch();

  if (_supportsLocalNotifications()) {
    await LocalNotificationsService.showNotification(
      id: message.messageId.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
    );
  }
}

bool _isMobilePlatform() {
  if (kIsWeb) {
    return false;
  }
  return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
}

bool _isApplePlatform() {
  if (kIsWeb) {
    return false;
  }
  return defaultTargetPlatform == TargetPlatform.iOS;
}

bool _supportsFirebaseCore() => kIsWeb || _isMobilePlatform();

bool _supportsLocalNotifications() => _isMobilePlatform();

bool _supportsFirebaseMessaging() => kIsWeb || _isMobilePlatform();

bool _supportsBackgroundMessaging() => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
