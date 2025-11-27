import 'package:get/get.dart';
import 'package:unisinos_usp_app/routes/categories.dart';
import 'package:unisinos_usp_app/routes/samples.dart';
import 'package:unisinos_usp_app/screens/screens.dart';

List<GetPage> appRoutes() => [
      GetPage(name: '/splash', page: () => const SplashScreen()),
      GetPage(name: '/login', page: () => const LoginScreen()),
      GetPage(name: '/create_account', page: () => CreateAccountScreen()),
      GetPage(name: '/recover_password', page: () => RecoverPasswordScreen()),
      GetPage(name: '/code_confirmation', page: () => const CodeConfirmationScreen()),
      GetPage(name: '/create_password', page: () => CreatePasswordScreen()),
      GetPage(name: '/home', page: () => HomeScreen()),
      ...categoryRoutes(),
      ...sampleRoutes(),
    ];
