import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class IAuthService {
  bool get isAdmin;
  bool get isStudent;
  bool get isTeacher;
  bool get isLoggedIn;
}

enum RequiredRole { admin, teacher, student }

class RouteMiddleware extends GetMiddleware {
  final bool Function(IAuthService authService) accessChecker;

  final IAuthService authService = Get.find<IAuthService>();

  RouteMiddleware({required this.accessChecker}) {
    print(
        '[RouteMiddleware] isAdmin=${authService.isAdmin}, isTeacher=${authService.isTeacher}, isTeacher=${authService.isStudent}, isLoggedIn=${authService.isLoggedIn}');
  }

  @override
  int? get priority => -1;

  @override
  RouteSettings? redirect(String? route) {
    print('[RouteMiddleware] redirect() chamado para rota: $route');
    print(
        '[RouteMiddleware] isAdmin=${authService.isAdmin}, isTeacher=${authService.isTeacher}, isTeacher=${authService.isStudent}, isLoggedIn=${authService.isLoggedIn}');

    if (!authService.isLoggedIn) {
      print('[RouteMiddleware] Usuário não logado. Redirecionando para /login');
      return const RouteSettings(name: '/login');
    }

    if (accessChecker(authService)) {
      print('[RouteMiddleware] Permissão OK, seguindo para rota $route');

      return null;
    } else {
      print('[RouteMiddleware] Redirecionando para /access_denied');
      return const RouteSettings(name: '/access_denied');
    }
  }
}
