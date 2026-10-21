import 'package:unisinos_usp_app/services/presence/presence_service.dart';
import 'package:unisinos_usp_app/widgets/app_page_viewport.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/routes/routes.dart';
import 'package:unisinos_usp_app/services/initializer.dart';
import 'package:unisinos_usp_app/themes/app_theme.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_launcher.dart';
import 'package:widgets_spo/screens/not_found_screen.dart';
import 'package:widgets_spo/utils.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Initializer.init();

      runApp(
        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Educação OnLIFE',
          initialRoute: '/splash',
          unknownRoute: GetPage(
            name: '/not_found',
            page: () => const NotFoundScreen(),
          ),
          navigatorObservers: [NavigationObserver.instance],
          getPages: appRoutes(),
          routingCallback: (routing) {
            AiAssistantLauncher.didNavigate(routing);
            if (routing?.isDialog != true &&
                routing?.isBottomSheet != true &&
                Get.isRegistered<PresenceService>()) {
              Get.find<PresenceService>().route(routing?.current ?? '');
            }
          },
          theme: AppTheme.theme,
          localizationsDelegates: const [
            FlutterQuillLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR'), Locale('en', 'US')],
          locale: const Locale('pt', 'BR'),
          builder: (context, child) => Overlay.wrap(
            child: AiAssistantLauncher(
              child: AppPageViewport(child: child ?? const SizedBox.shrink()),
            ),
          ),
        ),
      );
    },
    (error, stack) {
      debugPrint(error.toString());
      debugPrint(stack.toString());
    },
  );
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
