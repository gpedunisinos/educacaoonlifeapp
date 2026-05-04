import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/policies/app_access_policy.dart';

class AppRouteGuard extends GetMiddleware {
  AppRouteGuard({required this.module, required this.action});

  final AppModule module;
  final AppPermissionAction action;

  @override
  RouteSettings? redirect(String? route) {
    final UserController controller = Get.find<UserController>();
    final user = controller.user.value;

    if (user == null) {
      return const RouteSettings(name: '/login');
    }

    if (AppAccessPolicy.can(user, module, action)) {
      return null;
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

    return const RouteSettings(name: '/home');
  }
}
