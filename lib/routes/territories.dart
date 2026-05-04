import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/territory_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/territory/territory_create_screen.dart';
import 'package:unisinos_usp_app/screens/territory/territory_index_screen.dart';
import 'package:unisinos_usp_app/screens/territory/territory_update_screen.dart';

List<GetPage> territoryRoutes() => [
      GetPage(
        name: '/territories',
        page: () => TerritoryIndexScreen(),
        binding: TerritoryIndexBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => TerritoryPolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/territories/create',
        page: () => const TerritoryCreateScreen(),
        binding: TerritoryCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => TerritoryPolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/territories/update',
        page: () => const TerritoryUpdateScreen(),
        binding: TerritoryUpdateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => TerritoryPolicy(user).create()),
        ],
      ),
    ];
