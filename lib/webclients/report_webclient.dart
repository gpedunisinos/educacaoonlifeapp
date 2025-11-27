import 'dart:convert';

import 'package:unisinos_usp_app/models/report_teacher_score_model.dart';
import 'package:unisinos_usp_app/models/report_trail_stats_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/services.dart';

class ReportWebclient {
  WebClient get webClient => WebClient.instance;

  final String _endpoint = '/reports';

  Future<List<ReportTrailStats>> getReportsByTrail({String? trailId, String? categoryId}) async {
    final response = await webClient.get('$_endpoint/by_trail', [
      LoggingInterceptor(),
      ApiInterceptor(),
      TokenInterceptor(),
    ], {
      'trail_id': trailId,
      'category_id': categoryId,
    });

    if (response.body.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(response.body);
    if (decoded == null) return [];

    return ReportTrailStats.fromJsonArray(decoded);
  }

  Future<List<ReportTeacherScore>> getReportsByTeacher({required int teacherId}) async {
    final response = await webClient.get('$_endpoint/score_by_teacher', [
      LoggingInterceptor(),
      ApiInterceptor(),
      TokenInterceptor(),
    ], {
      'teacher_id': teacherId.toString(),
    });

    if (response.body.isEmpty) {
      return [];
    }

    final decoded = jsonDecode(response.body);
    if (decoded == null) return [];

    return ReportTeacherScore.fromJsonArray(decoded);
  }

  Future<String> exportReports({int? categoryId}) async {
    final response = await webClient.get(
      '$_endpoint/by_trail/export',
      [
        LoggingInterceptor(),
        ApiInterceptor(),
        TokenInterceptor(),
      ],
      {'category_id': categoryId?.toString()},
    );

    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse['url'];
  }
}
