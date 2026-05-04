import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/clue_connection_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/clue_connection/clue_connection_create_screen.dart';
import 'package:unisinos_usp_app/screens/clue_connection/clue_connection_index_screen.dart';
import 'package:unisinos_usp_app/screens/clue_connection/clue_connection_update_screen.dart';

List<GetPage> clueConnectionRoutes() => [
      GetPage(
        name: '/clue_connections',
        page: () => ClueConnectionIndexScreen(),
        binding: ClueConnectionIndexBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ClueConnectionPolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/clue_connections/create',
        page: () => const ClueConnectionCreateScreen(),
        binding: ClueConnectionCreateBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ClueConnectionPolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/clue_connections/update',
        page: () => const ClueConnectionUpdateScreen(),
        binding: ClueConnectionUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => ClueConnectionPolicy(user).create()),
        ],
      ),
    ];
