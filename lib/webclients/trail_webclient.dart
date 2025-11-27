import 'dart:convert';

import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/models/user_trail_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';
import 'package:widgets_spo/services/mixins/select_mixin.dart';
import 'package:widgets_spo/services/services.dart';

class TrailWebclient with CRUDMixin<TrailModel>, SelectMixin {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'trails';

  @override
  TrailModel fromJson(Map<String, dynamic> json) => TrailModel.fromJson(json);

  @override
  List<TrailModel> fromJsonArray(List<dynamic> json) => TrailModel.fromJsonArray(json);

  Future<List<TrailModel>> fetchByCategory(int id) async {
    Map<String, String> fields = {'category_id': id.toString()};
    List<TrailModel> results = await fetch(params: fields);
    return results;
  }

  Future<void> startTrail(int id) async {
    await webClient.post(
      '/$endpoint/start/$id',
      '',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
    );
  }

  Future<List<UserTrailModel>> fetchUserTrails({int? offset, int? limit}) async {
    Response response = await webClient.get(
      '/user_trails',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {
        'limit': limit?.toString() ?? webClient.defaultLimit.toString(),
        'offset': offset?.toString(),
      },
    );

    List<dynamic> jsonResponse = jsonDecode(response.body);

    return UserTrailModel.fromJsonArray(jsonResponse);
  }

  Future<List<UserTrailModel>> fetchUserTrailsByUserId(int id, {int? offset, int? limit}) async {
    Response response = await webClient.get(
      '/user_trails',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {
        'limit': limit?.toString() ?? webClient.defaultLimit.toString(),
        'offset': offset?.toString(),
        'user_id': id.toString(),
      },
    );

    List<dynamic> jsonResponse = jsonDecode(response.body);

    return UserTrailModel.fromJsonArray(jsonResponse);
  }
}
