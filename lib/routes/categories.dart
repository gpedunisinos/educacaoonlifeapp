import 'package:get/get.dart';
import 'package:unisinos_usp_app/bindings/category_binding.dart';
import 'package:unisinos_usp_app/screens/category/category_create_screen.dart';
import 'package:unisinos_usp_app/screens/category/category_index_screen.dart';
import 'package:unisinos_usp_app/screens/category/category_update_screen.dart';

List<GetPage> categoryRoutes() => [
      GetPage(
        name: '/categories',
        page: () => CategoryIndexScreen(),
        binding: CategoryBinding(),
      ),
      GetPage(
        name: '/categories/create',
        page: () => const CategoryCreateScreen(),
        binding: CategoryBinding(),
      ),
      GetPage(
        name: '/categories/update',
        page: () => const CategoryUpdateScreen(),
        binding: CategoryBinding(),
      ),
    ];
