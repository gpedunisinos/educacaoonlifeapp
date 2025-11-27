import 'dart:convert';

import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/services/services.dart';

class UserWebclient {
  final WebClient webClient = WebClient.instance;

  String get endpoint => 'users';

  Future<AuthUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final Response response = await webClient.post(
      '/register',
      jsonEncode(data),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return AuthUser.fromJson(jsonDecode(response.body));
  }

  Future<AuthUser> login({
    required String mail,
    required String password,
  }) async {
    final Response response = await webClient.post(
      '/login',
      jsonEncode({
        'email': mail,
        'password': password,
        'device_name': '',
      }),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return AuthUser.fromJson(jsonDecode(response.body));
  }

  Future<AuthUser> loginGoogle(String idToken, String accessToken) async {
    final Response response = await webClient.post(
      '/login/google',
      jsonEncode({
        'id_token': idToken,
        'access_token': accessToken,
      }),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return AuthUser.fromJson(jsonDecode(response.body));
  }

  Future<void> forgotPassword(String email) async {
    await webClient.post(
      '/forgot_password',
      jsonEncode({'email': email}),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );
  }

  Future<AuthUser> recoverPassword(String token, String password) async {
    final Response response = await webClient.post(
      '/recover_password',
      jsonEncode({
        'password': password,
        'recover_code': token,
      }),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return AuthUser.fromJson(jsonDecode(response.body));
  }

  Future<bool> validateRecoverToken(String token) async {
    final Response response = await webClient.post(
      '/validate_recover_code/$token',
      '',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return response.statusCode == 200;
  }
}
