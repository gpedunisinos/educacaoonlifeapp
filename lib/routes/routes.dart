import 'package:get/get.dart';
import 'package:unisinos_usp_app/routes/auth.dart';
import 'package:unisinos_usp_app/routes/categories.dart';
import 'package:unisinos_usp_app/routes/samples.dart';
import 'package:unisinos_usp_app/routes/living_clues.dart';
import 'package:unisinos_usp_app/routes/clue_connections.dart';
import 'package:unisinos_usp_app/routes/connection_types.dart';
import 'package:unisinos_usp_app/routes/chat.dart';
import 'package:unisinos_usp_app/routes/chat_templates.dart';
import 'package:unisinos_usp_app/routes/biomes.dart';
import 'package:unisinos_usp_app/routes/territories.dart';
import 'package:unisinos_usp_app/routes/node_links.dart';
import 'package:unisinos_usp_app/routes/node_types.dart';
import 'package:unisinos_usp_app/routes/nodes.dart';
import 'package:unisinos_usp_app/routes/users.dart';
import 'package:unisinos_usp_app/screens/screens.dart';

List<GetPage> appRoutes() => [
      GetPage(name: '/splash', page: () => const SplashScreen()),
      ...authRoutes(),
      GetPage(name: '/home', page: () => HomeScreen()),
      ...biomeRoutes(),
      ...territoryRoutes(),
      ...categoryRoutes(),
      ...livingClueRoutes(),
      ...clueConnectionRoutes(),
      ...connectionTypeRoutes(),
      ...sampleRoutes(),
      ...chatRoutes(),
      ...chatTemplateRoutes(),
      ...nodeTypeRoutes(),
      ...nodeRoutes(),
      ...nodeLinkRoutes(),
      ...userRoutes(),
    ];
