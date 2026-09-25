import 'package:widgets_spo/services/webclient_base.dart';

class WebClient extends WebClientBase {
  @override
  String get host => const String.fromEnvironment(
        'API_HOST',
        defaultValue: 'api.uniusp.gpedu.com.br',
      );

  @override
  String get scheme => const String.fromEnvironment(
        'API_SCHEME',
        defaultValue: 'https',
      );

  @override
  int? get port {
    const value = int.fromEnvironment('API_PORT', defaultValue: 0);
    return value == 0 ? null : value;
  }

  static final WebClient _instance = WebClient._();

  WebClient._();

  static WebClient get instance => _instance;
}
