import 'package:web/web.dart' as web;

/// Reserve synchronously during the click so API latency cannot block the popup.
class MeetingWindow {
  MeetingWindow._(this._window);
  final web.Window _window;
  static MeetingWindow? reserve() {
    final opened = web.window.open('about:blank', '_blank');
    if (opened == null) return null;
    opened.opener = null;
    opened.document.title = 'Conectando ao encontro — Educação OnLIFE';
    opened.document.body?.textContent = 'Preparando seu encontro…';
    return MeetingWindow._(opened);
  }

  bool navigate(Uri uri) {
    if (_window.closed) return false;
    _window.location.replace(uri.toString());
    return true;
  }

  void close() {
    if (!_window.closed) _window.close();
  }
}
