import 'package:flutter/foundation.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:widgets_spo/services/services.dart' show LoggingInterceptor;
import 'package:widgets_spo/services/webclient_base.dart';

class WebClient extends WebClientBase {
  @override
  String get host => const String.fromEnvironment(
    'API_HOST',
    defaultValue: 'api.uniusp.gpedu.com.br',
  );

  @override
  String get scheme =>
      const String.fromEnvironment('API_SCHEME', defaultValue: 'https');

  @override
  int? get port {
    const value = int.fromEnvironment('API_PORT', defaultValue: 0);
    return value == 0 ? null : value;
  }

  // Request logging in the shared package includes complete form/chat bodies.
  // Keep authentication and API interceptors, without logging personal content.
  List<InterceptorContract>? _privateInterceptors(
    List<InterceptorContract>? items,
  ) => items?.where((item) => item is! LoggingInterceptor).toList();

  @override
  Future<Response> get(
    String uri,
    List<InterceptorContract>? interceptors,
    Map<String, dynamic>? queryParameters, {
    int? timeOut,
  }) => super.get(
    uri,
    _privateInterceptors(interceptors),
    queryParameters,
    timeOut: timeOut,
  );

  @override
  Future<Response> post(
    String uri,
    String body,
    List<InterceptorContract>? interceptors, {
    int? timeOut,
  }) => super.post(
    uri,
    body,
    _privateInterceptors(interceptors),
    timeOut: timeOut,
  );

  @override
  Future<Response> put(
    String uri,
    String body,
    List<InterceptorContract>? interceptors, {
    int? timeOut,
  }) => super.put(
    uri,
    body,
    _privateInterceptors(interceptors),
    timeOut: timeOut,
  );

  @override
  Future<Response> delete(
    String uri,
    List<InterceptorContract>? interceptors, {
    int? timeOut,
  }) => super.delete(uri, _privateInterceptors(interceptors), timeOut: timeOut);

  @override
  void reportError(
    String uri,
    String? body,
    Exception ex, {
    bool fatal = true,
  }) {
    debugPrint('Falha na comunicação com a API (${ex.runtimeType}).');
  }

  static final WebClient _instance = WebClient._();

  WebClient._();

  static WebClient get instance => _instance;
}
