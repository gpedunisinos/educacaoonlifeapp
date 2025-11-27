import 'dart:async';
import 'dart:convert';

import 'package:unisinos_usp_app/middlewares/route_middleware.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/services/google_auth_service.dart';
import 'package:unisinos_usp_app/services/user_auth_service.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:widgets_spo/services/auth_provider.dart';
import 'package:widgets_spo/utils.dart';

class UserController extends GetxController implements IAuthService {
  UserWebclient webclient = UserWebclient();
  Rxn<UserModel> user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    this.initializeUser();
  }

  @override
  bool get isAdmin => user.value?.isAdmin ?? false;

  @override
  bool get isStudent => user.value?.isStudent ?? false;

  @override
  bool get isTeacher => user.value?.isTeacher ?? false;

  @override
  bool get isLoggedIn => isUserLoggedIn;

  Future<void> initializeUser() async {
    String? userPref = Util.prefs.getString('user');

    if (userPref != null) {
      UserModel localUser = UserModel.fromJson(jsonDecode(userPref));

      user.value = localUser;
      (AuthProvider.instance as UserAuthService).setUser(user.value!);
    } else {
      this.logout();
    }
  }

  bool get isUserLoggedIn {
    String? userPref = Util.prefs.getString('user');

    if (userPref != null) {
      user.value = UserModel.fromJson(jsonDecode(userPref));
    }

    return user.value != null;
  }

  void redirectLoggedUser() {
    if (!isUserLoggedIn) {
      logout();
      return;
    }

    switch (user.value!.profileType) {
      case ProfileTypeEnum.student:
        Get.offNamed('/student_home');
        break;
      case ProfileTypeEnum.teacher:
        Get.offNamed('/teacher_home');
        break;
      case ProfileTypeEnum.manager:
        Get.offNamed('/admin_home');
        break;
      case ProfileTypeEnum.admin:
        Get.offNamed('/admin_home');
        break;
      case null:
        Get.offNamed('/login');
    }
  }

  /// @method
  Future<void> login(String mail, String password) async {
    try {
      UserModel loggedUser = await webclient.login(mail: mail, password: password);

      await savePrefs(loggedUser);

      if (!kIsWeb || (kIsWeb && await _isFirebaseMessagingSupported())) {
        await _updateFcmToken(loggedUser);
      }

      redirectLoggedUser();
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao realizar login. $error');
      rethrow;
    }
  }

  Future<void> loginGoogle() async {
    try {
      final GoogleAuthService authService = GoogleAuthService();

      await authService.signOut();

      final GoogleSignInAccount? googleUser = await authService.signInWithGoogle();

      if (googleUser != null) {
        final GoogleSignInAuthentication auth = await googleUser.authentication;

        UserModel loggedUser = await webclient.loginGoogle(auth.idToken ?? '', auth.accessToken ?? '');

        await savePrefs(loggedUser);
        if (!kIsWeb || (kIsWeb && await _isFirebaseMessagingSupported())) {
          await _updateFcmToken(loggedUser);
        }

        redirectLoggedUser();
      }
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao logar com Google. $error');
      rethrow;
    }
  }

  Future<bool> _isFirebaseMessagingSupported() async {
    try {
      return await FirebaseMessaging.instance.isSupported();
    } catch (e) {
      print('FCM não suportado: $e');
      return false;
    }
  }

  Future<void> _updateFcmToken(UserModel loggedUser) async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        bool success = await webclient.updateFcmToken(fcmToken, loggedUser.id);
        if (success) {
          loggedUser.fcmToken = fcmToken;
          await savePrefs(loggedUser);
        }
      }
    } catch (e) {
      print('Erro ao atualizar FCM token: $e');
    }
  }

  Future<bool> createAccount(UserModel model) async {
    try {
      user.value = await webclient.add(model);

      Get.successSnackbar('Usuário registrado com sucesso!'.tlt);
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao criar usuário. $error');
      rethrow;
    }
  }

  Future<bool> changePassword(String actualPass, UserModel user) async {
    try {
      var userModel = await webclient.changePassword(actualPass, user);

      await savePrefs(userModel);

      Get.successSnackbar('Usuário atualizado com sucesso!'.tlt);

      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao atualizar usuário. $error');
      rethrow;
    }
  }

  Future<bool> validateRecoverToken(String token) async {
    try {
      return await webclient.validateRecoverToken(token);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao validar Token. $error');
      rethrow;
    }
  }

  Future<bool> sendCode(String email) async {
    try {
      await webclient.forgotPassword(email);
      Get.successSnackbar(
        'Se o email estiver registrado em nossa base, iremos enviar um link de recuperação de senha para você!'.tlt,
        duration: const Duration(seconds: 5),
      );
      return true;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao enviar email. $error');
      rethrow;
    }
  }

  Future<UserModel> recoverPassword(String token, String password) async {
    try {
      user.value = await webclient.recoverPassword(token, password);
      Get.successSnackbar('Senha alterada com sucesso!'.tlt);
      return user.value!;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao alterar a senha. $error');
      rethrow;
    }
  }

  Future<void> logout() async {
    user.value = null;
    WidgetsBinding.instance.addPostFrameCallback((_) async => AuthProvider.instance.logout());
  }

  Future<void> delete() async {
    try {
      await webclient.deleteAccount(user.value!);
      Get.successSnackbar('A sua conta foi excluída. Você será desconectado'.tlt, duration: const Duration(seconds: 5));
      logout();
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao excluir conta. $error');
      rethrow;
    }
  }

  Future<void> updateUser() async {
    try {
      UserModel u = user.value!;

      u.password = ''; // must remove pass

      final updatedUser = await webclient.update(
        u.copyWith(
          sendClassNotification: u.sendClassNotification,
          sendTrailNotification: u.sendTrailNotification,
          sendPlatformNotification: u.sendPlatformNotification,
        ),
      );

      await savePrefs(updatedUser.copyWith(token: u.token));

      Get.successSnackbar('Preferências atualizadas com sucesso.');
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro atualizar as preferencias. $error');
      rethrow;
    }
  }

  Future<void> updatePreferences() async {
    try {
      UserModel u = user.value!;

      u.password = ''; // must remove pass

      final updatedUser = await webclient.updatePreferences(
        u.copyWith(
          sendClassNotification: u.sendClassNotification,
          sendTrailNotification: u.sendTrailNotification,
          sendPlatformNotification: u.sendPlatformNotification,
        ),
      );

      await savePrefs(updatedUser.copyWith(token: u.token));

      Get.successSnackbar('Preferências atualizadas com sucesso.');
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro atualizar as preferencias. $error');
      rethrow;
    }
  }

  Future<void> savePrefs(UserModel loggedUser) async {
    await loggedUser.savePrefs();
    (AuthProvider.instance as UserAuthService).setUser(loggedUser);

    user.value = loggedUser;
  }
}
