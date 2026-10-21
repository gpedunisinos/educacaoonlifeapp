import 'package:unisinos_usp_app/services/mode_switch_routes.dart';
import 'package:unisinos_usp_app/widgets/mode_aware_page.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_show_screen.dart';
import 'package:unisinos_usp_app/screens/management/management_home_screen.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/screens/space/clue_research_room_screen.dart';
import 'package:unisinos_usp_app/screens/space/intelligence_chamber_screen.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/screens/space/connections_room_screen.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/space/space_screen.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/screens/mode_selection_screen.dart';
import 'package:unisinos_usp_app/middlewares/app_route_guard.dart';
import 'package:unisinos_usp_app/routes/auth.dart';
import 'package:unisinos_usp_app/routes/categories.dart';
import 'package:unisinos_usp_app/routes/samples.dart';
import 'package:unisinos_usp_app/routes/living_clues.dart';
import 'package:unisinos_usp_app/routes/clue_connections.dart';
import 'package:unisinos_usp_app/routes/connection_types.dart';
import 'package:unisinos_usp_app/routes/chat_templates.dart';
import 'package:unisinos_usp_app/routes/node_links.dart';
import 'package:unisinos_usp_app/routes/node_types.dart';
import 'package:unisinos_usp_app/routes/nodes.dart';
import 'package:unisinos_usp_app/routes/users.dart';
import 'package:unisinos_usp_app/screens/screens.dart';

List<GetPage> appRoutes() =>
    [
      GetPage(name: '/splash', page: () => SplashScreen()),
      ...authRoutes(),
      GetPage(name: '/choose_mode', page: () => ModeSelectionScreen()),
      GetPage(
        name: '/home',
        page: () => HomeScreen(),
        middlewares: [AppRouteGuard(canActivate: (u) => u != null)],
      ),
      GetPage(
        name: '/management',
        page: () => ManagementHomeScreen(),
        transition: Transition.fadeIn,
        middlewares: [
          AppRouteGuard(
            canActivate: (u) =>
                (u?.isAdmin ?? false) || ClueConnectionPolicy(u).viewAny(),
          ),
        ],
      ),
      GetPage(
        name: '/management/connections',
        page: () => ConnectionsRoomScreen(management: true),
        transition: Transition.fadeIn,
        middlewares: [
          AppRouteGuard(canActivate: (u) => ClueConnectionPolicy(u).viewAny()),
        ],
      ),
      GetPage(
        name: '/management/connections/:id',
        page: () => ConnectionsRoomScreen(
          management: true,
          connectionId: int.tryParse(Get.parameters['id'] ?? '') ?? -1,
          initialConnection: Get.arguments is RoomConnection
              ? Get.arguments as RoomConnection
              : null,
        ),
        transition: Transition.fadeIn,
        middlewares: [
          AppRouteGuard(canActivate: (u) => ClueConnectionPolicy(u).viewAny()),
        ],
      ),
      GetPage(name: '/space', page: () => SpaceScreen()),
      GetPage(
        name: '/space/research',
        page: () => ClueResearchRoomScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 600),
        middlewares: [
          AppRouteGuard(canActivate: (u) => LivingCluePolicy(u).viewAny()),
        ],
      ),
      GetPage(
        name: '/space/research/:id',
        page: () => LivingClueShowScreen(
          clueId: int.tryParse(Get.parameters['id'] ?? '') ?? -1,
          initialClue: Get.arguments is LivingClueModel
              ? Get.arguments as LivingClueModel
              : null,
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 400),
        middlewares: [
          AppRouteGuard(canActivate: (u) => LivingCluePolicy(u).viewAny()),
        ],
      ),
      GetPage(
        name: '/space/connections',
        page: () => ConnectionsRoomScreen(management: true),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 700),
        middlewares: [
          AppRouteGuard(canActivate: (u) => ClueConnectionPolicy(u).viewAny()),
        ],
      ),
      GetPage(
        name: '/space/connections/:id',
        page: () => ConnectionsRoomScreen(
          management: true,
          connectionId: int.tryParse(Get.parameters['id'] ?? '') ?? -1,
          initialConnection: Get.arguments is RoomConnection
              ? Get.arguments as RoomConnection
              : null,
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 400),
        middlewares: [
          AppRouteGuard(canActivate: (u) => ClueConnectionPolicy(u).viewAny()),
        ],
      ),
      GetPage(
        name: '/space/agents',
        page: () => IntelligenceChamberScreen(),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 600),
        middlewares: [
          AppRouteGuard(canActivate: (u) => ChatTemplatePolicy(u).viewAny()),
        ],
      ),
      GetPage(
        name: '/space/agents/:id',
        page: () => IntelligenceChamberScreen(
          agentId: int.tryParse(Get.parameters['id'] ?? '') ?? -1,
          initialAgent: Get.arguments is ChatTemplateModel
              ? Get.arguments as ChatTemplateModel
              : null,
        ),
        transition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 450),
        middlewares: [
          AppRouteGuard(canActivate: (u) => ChatTemplatePolicy(u).viewAny()),
        ],
      ),
      ...categoryRoutes(),
      ...livingClueRoutes(),
      ...clueConnectionRoutes(),
      ...connectionTypeRoutes(),
      ...sampleRoutes(),
      ...chatTemplateRoutes(),
      ...nodeTypeRoutes(),
      ...nodeRoutes(),
      ...nodeLinkRoutes(),
      ...userRoutes(),
    ].map((page) {
      const public = {
        '/splash',
        '/login',
        '/create_account',
        '/recover_password',
        '/code_confirmation',
        '/create_password',
        '/choose_mode',
      };
      if (public.contains(page.name)) return page;
      return page.copy(
        page: canSwitchModeOnRoute(page.name.replaceAll(':id', '1'))
            ? () => ModeAwarePage(builder: page.page)
            : page.page,
        middlewares: [
          AppRouteGuard(canActivate: (u) => u != null),
          ...?page.middlewares,
        ],
      );
    }).toList();
