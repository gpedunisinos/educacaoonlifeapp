import 'dart:convert';

import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';
import 'package:widgets_spo/services/services.dart';

class UserWebclient with SelectMixin {
  @override
  WebClient webClient = WebClient.instance;

  @override
  String get endpoint => 'users';

  /// @method
  Future<UserModel> add(UserModel user) async {
    final Map<String, dynamic> data = {
      ...user.toJson(),
    };

    Response response = await webClient.post('/register', jsonEncode(data), [
      LoggingInterceptor(),
      ApiInterceptor(),
    ]);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  Future<UserModel> createUser(UserModel user, {List<int>? trailIds}) async {
    final Map<String, dynamic> data = {
      ...user.toJson(),
      if (trailIds != null) 'trail_ids': trailIds,
    };

    Response response = await webClient.post('/$endpoint', jsonEncode(data), [
      LoggingInterceptor(),
      ApiInterceptor(),
      TokenInterceptor(),
    ]);

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  /// @method
  Future<UserModel> login({
    required String mail,
    required String password,
    String? fcmToken,
  }) async {
    Response response = await webClient.post(
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

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  Future<UserModel> loginGoogle(String idToken, String accessToken) async {
    Response response = await webClient.post(
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

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  /// @method
  Future<UserModel> update(UserModel user, {List<int>? trailIds}) async {
    final Map<String, dynamic> data = {
      ...user.removeEmptyFields(),
      if (trailIds != null) 'trail_ids': trailIds,
    };

    Response response = await webClient.put(
      '/$endpoint/${user.id}',
      jsonEncode(data),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  Future<UserModel> updatePreferences(UserModel user) async {
    final Map<String, dynamic> data = {
      ...user.removeEmptyFields(),
    };

    Response response = await webClient.put(
      '/$endpoint/preferences/${user.id}',
      jsonEncode(data),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  /// @method
  Future<UserModel> changePassword(String currentPass, UserModel user) async {
    Response response = await webClient.put(
      '/$endpoint/${user.id}',
      jsonEncode({
        ...user.toJson(),
        'actual_password': currentPass,
      }),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  Future<String> forgotPassword(String email) async {
    Response response = await webClient.post(
      '/forgot_password',
      jsonEncode({'email': email}),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return response.body;
  }

  Future<UserModel> recoverPassword(String token, String password) async {
    Response response = await webClient.post(
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

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserModel.fromJson(jsonResponse);
  }

  Future<bool> validateRecoverToken(String token) async {
    Response response = await webClient.post(
      '/validate_recover_code/$token',
      '',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
      ],
    );

    return response.statusCode == 200;
  }

  // sort options: String (name, email, cpf, created_at)
  // order options: String (asc, desc)
  Future<List<UserModel>> fetchUsers({
    String? search,
    ProfileTypeEnum? profileType,
    bool? status,
    int? limit,
    int? offset,
    String? sort,
    String? order,
  }) async {
    Response response = await webClient.get(
      '/$endpoint',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {
        'search': search ?? '',
        'profile': profileType?.value.toString(),
        'status': status == null ? null : (status ? '1' : '0'),
        'limit': limit?.toString() ?? webClient.defaultLimit.toString(),
        'offset': offset?.toString(),
        'sort': sort?.toString(),
        'order': order?.toString(),
      },
    );

    return UserModel.fromJsonArray(jsonDecode(response.body));
  }

  Future<UserModel> fetchById(int id) async {
    Response response = await webClient.get(
      '/$endpoint/$id',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {'id': id.toString()},
    );

    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<UserModel> deleteAccount(UserModel userModel) async {
    Response response = await webClient.delete(
      '/$endpoint/${userModel.id}',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );

    return UserModel.fromJson(jsonDecode(response.body));
  }

  Future<bool> updateFcmToken(String? fcmToken, int id) async {
    await webClient.put(
      '/$endpoint/$id/update_fcm_token',
      jsonEncode({
        'fcm_token': fcmToken,
      }),
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );

    return true;
  }
}
