import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/category/category_create_binding.dart';
import 'package:unisinos_usp_app/bindings/category/category_index_binding.dart';
import 'package:unisinos_usp_app/bindings/category/category_update_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
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
          AppRouteGuard(canActivate: (user) => CategoryPolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/categories/create',
        page: () => const CategoryCreateScreen(),
        binding: CategoryCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => CategoryPolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/categories/update',
        page: () => const CategoryUpdateScreen(),
        binding: CategoryUpdateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => CategoryPolicy(user).create()),
        ],
      ),
    ];
