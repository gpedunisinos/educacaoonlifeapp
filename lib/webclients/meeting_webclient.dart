import 'dart:convert';
import 'package:widgets_spo/services/services.dart';
import 'package:unisinos_usp_app/models/meeting_room.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';

class MeetingWebclient {
  Future<Uri> authorize(MeetingRoom room) async {
    final response = await WebClient.instance.post(
      '/me/meetings/access',
      jsonEncode({'room': room.uri.pathSegments.single}),
      [ApiInterceptor(), TokenInterceptor()],
      timeOut: 15,
    );
    final data = jsonDecode(response.body);
    if (response.statusCode != 200 || data is! Map<String, dynamic>) {
      throw const FormatException(
        'Não foi possível autorizar o encontro. Tente novamente.',
      );
    }
    return room.authorizedUri(data);
  }
}
