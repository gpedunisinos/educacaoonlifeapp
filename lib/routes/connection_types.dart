import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/connection_type_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/connection_type/connection_type_create_screen.dart';
import 'package:unisinos_usp_app/screens/connection_type/connection_type_index_screen.dart';
import 'package:unisinos_usp_app/screens/connection_type/connection_type_update_screen.dart';

List<GetPage> connectionTypeRoutes() => [
      GetPage(
        name: '/connection_types',
        page: () => ConnectionTypeIndexScreen(),
        binding: ConnectionTypeIndexBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ConnectionTypePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/connection_types/create',
        page: () => const ConnectionTypeCreateScreen(),
        binding: ConnectionTypeCreateBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ConnectionTypePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/connection_types/update',
        page: () => const ConnectionTypeUpdateScreen(),
        binding: ConnectionTypeUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ConnectionTypePolicy(user).create()),
        ],
      ),
    ];
