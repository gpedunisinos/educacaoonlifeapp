import 'package:unisinos_usp_app/services/clue_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';

typedef AppRoutePermissionChecker = bool Function(AuthUser? user);

class AppRouteGuard extends GetMiddleware {
  AppRouteGuard({required this.canActivate});

  final AppRoutePermissionChecker canActivate;

  @override
  RouteSettings? redirect(String? route) {
    final UserController controller = Get.find<UserController>();
    final user = controller.user.value;

    if (user == null) {
      ClueLinks.remember(route);
      return RouteSettings(
        name: ClueLinks.authRoute('/login', ClueLinks.safeTarget(route)),
      );
    }

    if (user.usageMode == null) {
      ClueLinks.remember(route);
      return RouteSettings(
        name: ClueLinks.authRoute('/choose_mode', ClueLinks.safeTarget(route)),
      );
    }

    final authorRoute = RegExp(
      r'/(create|update|connect|pre_create|type_select)(/|$)',
    ).hasMatch(route ?? '');
    if (canActivate(user) && (!authorRoute || user.canAuthor)) {
      // Existing home links are aliases of the new cockpit entry.
      return route == '/home' ? RouteSettings(name: controller.modeHome) : null;
    }

    Future<void>.microtask(() {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          'Acesso negado',
          'Você não tem permissão para acessar esta tela.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFB3261E),
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
        );
      }
    });

    return const RouteSettings(name: '/space');
  }
}
