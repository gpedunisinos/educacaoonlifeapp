import 'package:get/get.dart';
import 'package:unisinos_usp_app/screens/screens.dart';

List<GetPage> authRoutes() => [
      GetPage(name: '/login', page: () => const LoginScreen()),
      GetPage(name: '/create_account', page: () => CreateAccountScreen()),
      GetPage(name: '/recover_password', page: () => RecoverPasswordScreen()),
      GetPage(name: '/code_confirmation', page: () => const CodeConfirmationScreen()),
      GetPage(name: '/create_password', page: () => CreatePasswordScreen()),
    ];
