import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/living_clue_binding.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_create_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_index_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_map_create_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_map_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_pre_create_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_sow_screen.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_update_screen.dart';

List<GetPage> livingClueRoutes() => [
      GetPage(
        name: '/living_clues',
        page: () => LivingClueIndexScreen(),
        binding: LivingClueIndexBinding(),
      ),
      GetPage(
        name: '/living_clues/map',
        page: () => const LivingClueMapScreen(),
        binding: LivingClueMapBinding(),
      ),
      GetPage(
        name: '/living_clues/pre_create',
        page: () => const LivingCluePreCreateScreen(),
      ),
      GetPage(
        name: '/living_clues/map/create',
        page: () => const LivingClueMapCreateScreen(),
      ),
      GetPage(
        name: '/living_clues/create',
        page: () => const LivingClueCreateScreen(),
        binding: LivingClueCreateBinding(),
      ),
      GetPage(
        name: '/living_clues/show',
        page: () => const LivingClueShowScreen(),
      ),
      GetPage(
        name: '/living_clues/update',
        page: () => const LivingClueUpdateScreen(),
        binding: LivingClueUpdateBinding(),
      ),
    ];
