import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Only known read routes may be opened by a generated AI reference.
String? aiInternalRoute(String href) {
  final value = href.startsWith('#') ? href.substring(1) : href;
  final uri = Uri.tryParse(value);
  if (uri == null || uri.hasScheme || uri.hasAuthority) return null;
  if (RegExp(r'^/space/research/[1-9][0-9]*$').hasMatch(uri.path) &&
      uri.query.isEmpty)
    return uri.path;
  if (uri.path == '/nodes/graph' &&
      uri.queryParameters.length == 1 &&
      RegExp(r'^[1-9][0-9]*$').hasMatch(uri.queryParameters['focus'] ?? ''))
    return value;
  return null;
}

Future<void> openAiReference(
  String? href, {
  VoidCallback? beforeNavigate,
}) async {
  if (href == null) return;
  final internal = aiInternalRoute(href);
  if (internal != null) {
    beforeNavigate?.call();
    await Get.toNamed(internal);
    return;
  }
  final uri = Uri.tryParse(href);
  if (uri == null ||
      !['https', 'http'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty)
    return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
