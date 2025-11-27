import 'package:widgets_spo/services/webclient_base.dart';

class WebClient extends WebClientBase {
  @override
  String get host => 'api.efv.spotec.app';

  static final WebClient _instance = WebClient._();

  WebClient._();

  static WebClient get instance => _instance;
}
