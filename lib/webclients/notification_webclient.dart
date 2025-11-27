import 'package:unisinos_usp_app/models/notification_model.dart';
import 'package:unisinos_usp_app/webclients/webclient.dart';
import 'package:widgets_spo/services/mixins/crud_mixin.dart';

class NotificationWebclient with CRUDMixin<NotificationModel> {
  @override
  WebClient get webClient => WebClient.instance;

  @override
  String get endpoint => 'notifications';

  @override
  NotificationModel fromJson(Map<String, dynamic> json) => NotificationModel.fromJson(json);

  @override
  List<NotificationModel> fromJsonArray(List<dynamic> json) => NotificationModel.fromJsonArray(json);
}
