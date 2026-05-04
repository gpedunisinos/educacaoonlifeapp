import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/user_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/screens/user/user_create_screen.dart';
import 'package:unisinos_usp_app/screens/user/user_index_screen.dart';
import 'package:unisinos_usp_app/screens/user/user_update_screen.dart';

List<GetPage> userRoutes() => [
      GetPage(
        name: '/users',
        page: () => const UserIndexScreen(),
        binding: UserIndexBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.users, action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/users/create',
        page: () => const UserCreateScreen(),
        binding: UserCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.users, action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/users/update',
        page: () => const UserUpdateScreen(),
        binding: UserUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.users, action: AppPermissionAction.manage),
        ],
      ),
    ];
