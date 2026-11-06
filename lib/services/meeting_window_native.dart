import 'package:url_launcher/url_launcher.dart';

/// Native apps hand the authorized room to the system browser. Only the
/// shareable invite is copied by the dialog; host credentials stay transient.
class MeetingWindow {
  bool _cancelled = false;
  static MeetingWindow? reserve() => MeetingWindow();
  Future<bool> navigate(Uri uri) async {
    if (_cancelled) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  void close() {
    _cancelled = true;
  }
}
