import 'package:widgets_spo/services/webclient_base.dart';

class WebClient extends WebClientBase {
  @override
  String get host => 'api.uniusp.gpedu.com.br';

  static final WebClient _instance = WebClient._();

  WebClient._();

  static WebClient get instance => _instance;
}
