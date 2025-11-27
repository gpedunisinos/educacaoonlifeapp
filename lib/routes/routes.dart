import 'package:get/get.dart';
import 'package:unisinos_usp_app/routes/auth.dart';
import 'package:unisinos_usp_app/routes/categories.dart';
import 'package:unisinos_usp_app/routes/samples.dart';
import 'package:unisinos_usp_app/screens/screens.dart';

List<GetPage> appRoutes() => [
      GetPage(name: '/splash', page: () => const SplashScreen()),
      ...authRoutes(),
      GetPage(name: '/home', page: () => HomeScreen()),
      ...categoryRoutes(),
      ...sampleRoutes(),
    ];
