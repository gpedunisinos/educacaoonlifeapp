import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/biome_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/biome/biome_create_screen.dart';
import 'package:unisinos_usp_app/screens/biome/biome_index_screen.dart';
import 'package:unisinos_usp_app/screens/biome/biome_update_screen.dart';

List<GetPage> biomeRoutes() => [
      GetPage(
        name: '/biomes',
        page: () => BiomeIndexScreen(),
        binding: BiomeIndexBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => BiomePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/biomes/create',
        page: () => const BiomeCreateScreen(),
        binding: BiomeCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => BiomePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/biomes/update',
        page: () => const BiomeUpdateScreen(),
        binding: BiomeUpdateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => BiomePolicy(user).create()),
        ],
      ),
    ];
