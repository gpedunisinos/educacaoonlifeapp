import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/clue_connection_binding.dart';
import 'package:unisinos_usp_app/bindings/living_clue_binding.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_chat_screen.dart';
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
              canActivate: (user) => LivingCluePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/living_clues/map',
        page: () => const LivingClueMapScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 900),
        binding: LivingClueMapBinding(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => LivingCluePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/living_clues/type_select',
        page: () => const LivingClueTypeSelectScreen(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/pre_create',
        page: () => const LivingCluePreCreateScreen(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/map/create',
        page: () => const LivingClueMapCreateScreen(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/create',
        page: () => const LivingClueCreateScreen(),
        binding: LivingClueCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/show',
        page: () => const LivingClueShowScreen(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => LivingCluePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/living_clues/:id/chat',
        page: () => const LivingClueChatScreen(),
        binding: LivingClueChatBinding(),
      ),
      GetPage(
        name: '/living_clues/update',
        page: () => const LivingClueUpdateScreen(),
        binding: LivingClueUpdateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/connect',
        page: () => const LivingClueConnectScreen(),
        binding: ClueConnectionCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
          name: '/living_clues/:id',
          page: () => const LivingClueShowScreen(),
          middlewares: [
            AppRouteGuard(canActivate: (u) => LivingCluePolicy(u).viewAny())
          ]),
    ];
