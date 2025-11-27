import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/routes/routes.dart';
import 'package:unisinos_usp_app/services/initializer.dart';
import 'package:unisinos_usp_app/themes/app_theme.dart';
import 'package:widgets_spo/screens/not_found_screen.dart';
import 'package:widgets_spo/utils.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Initializer.init();

      runApp(
        GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Unisinos USP App',
          initialRoute: '/splash',
          unknownRoute: GetPage(
            name: '/not_found',
            page: () => const NotFoundScreen(),
          ),
          navigatorObservers: [NavigationObserver.instance],
          getPages: appRoutes(),
          theme: AppTheme.theme,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('en', 'US'),
          ],
          locale: const Locale('pt', 'BR'),
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
