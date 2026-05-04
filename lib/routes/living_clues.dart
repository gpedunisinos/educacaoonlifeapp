import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/clue_connection_binding.dart';
import 'package:unisinos_usp_app/bindings/living_clue_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_connect_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_create_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_index_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_map_create_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_map_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_pre_create_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_show_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_type_select_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_update_screen.dart';

List<GetPage> livingClueRoutes() => [
      GetPage(
        name: '/living_clues',
        page: () => LivingClueIndexScreen(),
        binding: LivingClueIndexBinding(),
        transition: Transition.upToDown,
        transitionDuration: const Duration(milliseconds: 300),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues, action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/living_clues/map',
        page: () => const LivingClueMapScreen(),
        binding: LivingClueMapBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/living_clues/type_select',
        page: () => const LivingClueTypeSelectScreen(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/living_clues/pre_create',
        page: () => const LivingCluePreCreateScreen(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/living_clues/map/create',
        page: () => const LivingClueMapCreateScreen(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/living_clues/create',
        page: () => const LivingClueCreateScreen(),
        binding: LivingClueCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/living_clues/show',
        page: () => const LivingClueShowScreen(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues, action: AppPermissionAction.view),
        ],
      ),
      GetPage(
        name: '/living_clues/update',
        page: () => const LivingClueUpdateScreen(),
        binding: LivingClueUpdateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
      GetPage(
        name: '/living_clues/connect',
        page: () => const LivingClueConnectScreen(),
        binding: ClueConnectionCreateBinding(),
        middlewares: [
          AppRouteGuard(
              module: AppModule.livingClues,
              action: AppPermissionAction.manage),
        ],
      ),
    ];
