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
        page: () => LivingClueMapScreen(),
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
        page: () => LivingClueTypeSelectScreen(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/pre_create',
        page: () => LivingCluePreCreateScreen(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/map/create',
        page: () => LivingClueMapCreateScreen(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/create',
        page: () => LivingClueCreateScreen(),
        binding: LivingClueCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/show',
        page: () => LivingClueShowScreen(),
        middlewares: [
          AppRouteGuard(
              canActivate: (user) => LivingCluePolicy(user).viewAny()),
        ],
      ),
      GetPage(
        name: '/living_clues/:id/chat',
        page: () => LivingClueChatScreen(),
        binding: LivingClueChatBinding(),
      ),
      GetPage(
        name: '/living_clues/update',
        page: () => LivingClueUpdateScreen(),
        binding: LivingClueUpdateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
        name: '/living_clues/connect',
        page: () => LivingClueConnectScreen(),
        binding: ClueConnectionCreateBinding(),
        middlewares: [
          AppRouteGuard(canActivate: (user) => LivingCluePolicy(user).create()),
        ],
      ),
      GetPage(
          name: '/living_clues/:id',
          page: () => LivingClueShowScreen(),
          middlewares: [
            AppRouteGuard(canActivate: (u) => LivingCluePolicy(u).viewAny())
          ]),
    ];
