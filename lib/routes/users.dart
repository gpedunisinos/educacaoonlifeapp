import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/user_binding.dart';
import 'package:unisinos_usp_app/screens/user/user_create_screen.dart';
import 'package:unisinos_usp_app/screens/user/user_index_screen.dart';
import 'package:unisinos_usp_app/screens/user/user_update_screen.dart';

List<GetPage> userRoutes() => [
      GetPage(
        name: '/users',
        page: () => const UserIndexScreen(),
        binding: UserIndexBinding(),
      ),
      GetPage(
        name: '/users/create',
        page: () => const UserCreateScreen(),
        binding: UserCreateBinding(),
      ),
      GetPage(
        name: '/users/update',
        page: () => const UserUpdateScreen(),
        binding: UserUpdateBinding(),
      ),
    ];
