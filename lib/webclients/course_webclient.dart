import 'dart:convert';

import 'package:unisinos_usp_app/models/course_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:http/http.dart';
import 'package:widgets_spo/services/interceptors/api_interceptor.dart';
import 'package:widgets_spo/services/interceptors/logging_interceptor.dart';
import 'package:widgets_spo/services/interceptors/token_interceptor.dart';

class CourseWebclient {
  WebClient webClient = WebClient.instance;

  Future<List<CourseModel>> fetchCourses([String? search, int? limit]) async {
    Response response = await webClient.get(
      '/courses',
      [LoggingInterceptor(), ApiInterceptor(), TokenInterceptor()],
      {
        // 'limit': limit?.toString() ?? webClient.defaultLimit.toString(),
        'search': search ?? '',
      },
    );

    List<dynamic> jsonResponse = jsonDecode(response.body);

    return CourseModel.fromJsonArray(jsonResponse);
  }
}
