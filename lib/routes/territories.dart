import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/territory_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/screens/territory/territory_create_screen.dart';
import 'package:unisinos_usp_app/screens/territory/territory_index_screen.dart';
import 'package:unisinos_usp_app/screens/territory/territory_update_screen.dart';

List<GetPage> territoryRoutes() => [
      GetPage(
        name: '/territories',
        page: () => TerritoryIndexScreen(),
        binding: TerritoryIndexBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.territories, action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/territories/create',
        page: () => const TerritoryCreateScreen(),
        binding: TerritoryCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.territories,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/territories/update',
        page: () => const TerritoryUpdateScreen(),
        binding: TerritoryUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.territories,
              action: AppPermissionAction.manage),
        ],
      ),
    ];
