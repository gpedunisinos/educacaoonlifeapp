import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/category/category_create_binding.dart';
import 'package:unisinos_usp_app/bindings/category/category_index_binding.dart';
import 'package:unisinos_usp_app/bindings/category/category_update_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/screens/category/category_create_screen.dart';
import 'package:unisinos_usp_app/screens/category/category_index_screen.dart';
import 'package:unisinos_usp_app/screens/category/category_update_screen.dart';

List<GetPage> categoryRoutes() => [
      GetPage(
        name: '/categories',
        page: () => CategoryIndexScreen(),
        binding: CategoryIndexBinding(),
        transition: Transition.downToUp,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [
          AppRouteGuard(
              module: AppModule.categories, action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/categories/create',
        page: () => const CategoryCreateScreen(),
        binding: CategoryCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.categories, action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/categories/update',
        page: () => const CategoryUpdateScreen(),
        binding: CategoryUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.categories, action: AppPermissionAction.manage),
        ],
      ),
    ];
