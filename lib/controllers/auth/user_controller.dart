import 'package:unisinos_usp_app/services/clue_links.dart';
import 'dart:convert';
import 'package:unisinos_usp_app/services/locker_service.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/google_auth_service.dart';
import 'package:unisinos_usp_app/services/user_auth_service.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:widgets_spo/services/auth_provider.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/controllers/apple_login_controller.dart';

class UserController extends GetxController {
  UserWebclient webclient = UserWebclient();
  Rxn<AuthUser> user = Rxn<AuthUser>();
  late Future<void> initialization;

  @override
  void onInit() {
    super.onInit();
    initialization = initializeUser();
  }

  String get modeHome =>
      user.value?.usageMode == null ? '/choose_mode' : '/space';
  Future<void> chooseMode(String mode, {bool navigate = true}) async {
    if (!['explorer', 'inventor'].contains(mode)) {
      throw ArgumentError.value(mode, 'mode');
    }
    final current = user.value!;
    await EconectivaApi().write('PUT', '/me/preferences', {'usage_mode': mode});
    if (user.value?.id != current.id) return;
    await savePrefs(
      AuthUser.fromJson({...current.toJson(), 'usage_mode': mode}),
    );
    if (navigate) completeAuthentication();
  }

  void completeAuthentication() {
    final target = ClueLinks.pending(Get.parameters['returnTo']);
    if (user.value?.usageMode == null) {
      Get.offAllNamed(ClueLinks.authRoute('/choose_mode', target));
    } else {
      ClueLinks.clear();
      Get.offAllNamed(target ?? modeHome);
    }
  }

  bool get isLoggedIn => user.value != null;

  Future<void> initializeUser() async {
    final String? userPref = Util.prefs.getString('user');

    if (userPref != null) {
      AuthUser localUser = AuthUser.fromJson(jsonDecode(userPref));

      user.value = localUser;
      (AuthProvider.instance as UserAuthService).setUser(localUser);
      try {
        final prefs = await EconectivaApi().get('/me/preferences');
        if (user.value?.id != localUser.id) return;

        localUser = AuthUser.fromJson({
          ...localUser.toJson(),
          'usage_mode': prefs['usage_mode'],
          'profile': prefs['profile'] ?? localUser.profile,
        });
        await savePrefs(localUser);
      } catch (error, stackTrace) {
        if (Util.prefs.getString('user') == null) user.value = null;
        Util.debug(exception: error, stackTrace: stackTrace);
      }
    }
  }

  void redirectLoggedUser() async {
    await initialization;
    final bool loggedIn = user.value != null;
    if (loggedIn) {
      completeAuthentication();
    } else {
      Get.offAllNamed(
        ClueLinks.authRoute(
          '/login',
          ClueLinks.pending(Get.parameters['returnTo']),
        ),
      );
    }
  }

  /// @method
  Future<void> login(String mail, String password) async {
    try {
      AuthUser loggedUser = await webclient.login(
        mail: mail,
        password: password,
      );
      await savePrefs(loggedUser);
      completeAuthentication();
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao realizar login.');
      rethrow;
    }
  }

  Future<void> loginGoogle() async {
    try {
      final GoogleAuthService authService = GoogleAuthService();

      await authService.signOut();

      final GoogleSignInAccount? googleUser = await authService
          .signInWithGoogle();

      if (googleUser != null) {
        final GoogleSignInAuthentication auth = await googleUser.authentication;

        AuthUser loggedUser = await webclient.loginGoogle(
          auth.idToken ?? '',
          auth.accessToken ?? '',
        );

        await savePrefs(loggedUser);

        completeAuthentication();
      }
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Não foi possível entrar com o Google.');
      rethrow;
    }
  }

  Future<void> loginApple(AppleLoginCredential credential) async {
    try {
      final loggedUser = await webclient.loginWithApple(
        idToken: credential.idToken,
        name: credential.name,
      );
      await savePrefs(loggedUser);
      completeAuthentication();
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Não foi possível entrar com a Apple.');
    }
  }

  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      AuthUser loggedUser = await webclient.register(
        name: name,
        email: email,
        password: password,
      );

      await savePrefs(loggedUser);
      Get.successSnackbar('Usuário registrado com sucesso!'.tlt);
      completeAuthentication();
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar(
        'Erro',
        'Falha ao criar usuário. ${_extractErrorMessage(error)}',
      );
      rethrow;
    }
  }

  String _extractErrorMessage(Object error) {
    String message = error.toString();
    const prefixes = <String>['Exception: ', 'Erro: '];

    for (final prefix in prefixes) {
      if (message.startsWith(prefix)) {
        message = message.substring(prefix.length);
      }
    }

    return message;
  }

  Future<bool> validateRecoverToken(String token) async {
    try {
      return await webclient.validateRecoverToken(token);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Não foi possível validar o código.');
      rethrow;
    }
  }

  Future<bool> sendCode(String email) async {
    try {
      await webclient.forgotPassword(email);
      Get.successSnackbar(
        'Se o email estiver registrado em nossa base, iremos enviar um link de recuperação de senha para você!'
            .tlt,
        duration: const Duration(seconds: 5),
      );
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Não foi possível enviar o e-mail.');
      rethrow;
    }
  }

  Future<AuthUser> recoverPassword(String token, String password) async {
    try {
      user.value = await webclient.recoverPassword(token, password);
      Get.successSnackbar('Senha alterada com sucesso!'.tlt);
      return user.value!;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao alterar a senha.');
      rethrow;
    }
  }

  Future<void> logout() async {
    ClueLinks.clear();
    Get.find<LockerService>().clear();
    user.value = null;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => (AuthProvider.instance as UserAuthService).logout(
        preserveDestination: false,
      ),
    );
  }

  Future<void> savePrefs(AuthUser loggedUser) async {
    if (user.value?.id != loggedUser.id) Get.find<LockerService>().clear();
    await Util.prefs.setString('user', jsonEncode(loggedUser.toJson()));
    (AuthProvider.instance as UserAuthService).setUser(loggedUser);

    user.value = loggedUser;
    await Get.find<LockerService>().load();
  }
}
