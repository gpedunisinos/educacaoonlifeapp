import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/node_binding.dart';
import 'package:unisinos_usp_app/bindings/node_graph_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/node/node_create_screen.dart';
import 'package:unisinos_usp_app/screens/node/node_index_screen.dart';
import 'package:unisinos_usp_app/screens/node/node_update_screen.dart';
import 'package:unisinos_usp_app/screens/node_graph/node_graph_screen.dart';

List<GetPage> nodeRoutes() => [
      GetPage(
        name: '/nodes',
        page: () => NodeIndexScreen(),
        binding: NodeIndexBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => NodePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/nodes/create',
        page: () => const NodeCreateScreen(),
        binding: NodeCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => NodePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/nodes/update',
        page: () => const NodeUpdateScreen(),
        binding: NodeUpdateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => NodePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/nodes/graph',
        page: () => const NodeGraphScreen(),
        binding: NodeGraphBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => NodePolicy(user).viewAny()),
        ],
      ),
    ];
