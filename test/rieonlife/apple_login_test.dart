import 'package:flutter_test/flutter_test.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:widgets_spo/widgets/controllers/apple_login_controller.dart';

class _AppleApi extends UserWebclient {
  String? token;
  String? name;

  @override
  Future<AuthUser> loginWithApple({
    required String idToken,
    required String name,
  }) async {
    token = idToken;
    this.name = name;
    return const AuthUser(
      id: 1,
      name: 'Pessoa',
      email: 'test@example.test',
      token: 'session',
    );
  }
}

class _User extends UserController {
  bool navigated = false;

  @override
  Future<void> savePrefs(AuthUser loggedUser) async => user.value = loggedUser;

  @override
  void completeAuthentication() => navigated = true;
}

void main() {
  test(
    'Apple login sends credentials and completes the existing session flow',
    () async {
      final api = _AppleApi();
      final controller = _User()..webclient = api;
      await controller.loginApple(
        const AppleLoginCredential(idToken: 'apple-token', name: ''),
      );
      expect(api.token, 'apple-token');
      expect(api.name, '');
      expect(controller.user.value?.token, 'session');
      expect(controller.navigated, isTrue);
    },
  );
}
