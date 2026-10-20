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
      GetPage(name: '/splash', page: () => const SplashScreen()),
      ...authRoutes(),
      GetPage(name: '/choose_mode', page: () => const ModeSelectionScreen()),
      GetPage(
        name: '/home',
        page: () => HomeScreen(),
        middlewares: [AppRouteGuard(canActivate: (u) => u != null)],
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
        middlewares: [
          AppRouteGuard(canActivate: (u) => u != null),
          ...?page.middlewares,
        ],
      );
    }).toList();
