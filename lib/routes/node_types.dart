import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/node_type_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/screens/node_type/node_type_create_screen.dart';
import 'package:unisinos_usp_app/screens/node_type/node_type_index_screen.dart';
import 'package:unisinos_usp_app/screens/node_type/node_type_update_screen.dart';

List<GetPage> nodeTypeRoutes() => [
      GetPage(
        name: '/node_types',
        page: () => NodeTypeIndexScreen(),
        binding: NodeTypeIndexBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.nodeTypes, action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/node_types/create',
        page: () => const NodeTypeCreateScreen(),
        binding: NodeTypeCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.nodeTypes, action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/node_types/update',
        page: () => const NodeTypeUpdateScreen(),
        binding: NodeTypeUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.nodeTypes, action: AppPermissionAction.manage),
        ],
      ),
    ];
