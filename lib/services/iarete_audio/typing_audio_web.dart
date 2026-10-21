import 'dart:js_interop';
import 'package:web/web.dart' as web;

/// Same quiet triangle notes, envelope and order as the cockpit's SpaceAudio.type.
class TypingAudio {
  web.AudioContext? _context;
  int _index = 0;
  bool _disposed = false;
  Future<void> prepare() async {
    if (_disposed) return;
    try {
      final context = _context ??= web.AudioContext();
      await context.resume().toDart;
    } catch (_) {
      /* Browser autoplay limits must not prevent a conversation. */
    }
  }

  void tick() {
    final context = _context;
    if (_disposed || context == null || context.state != 'running') return;
    try {
      const notes = [523.25, 659.25, 783.99, 987.77, 783.99, 659.25];
      final oscillator = context.createOscillator();
      final gain = context.createGain();
      final now = context.currentTime;
      oscillator.type = 'triangle';
      oscillator.frequency.value = notes[_index++ % notes.length];
      gain.gain.setValueAtTime(0, now);
      gain.gain.linearRampToValueAtTime(.00672, now + .008);
      gain.gain.exponentialRampToValueAtTime(.0001, now + .055);
      oscillator.connect(gain);
      gain.connect(context.destination);
      oscillator.onended = ((web.Event _) {
        oscillator.disconnect();
        gain.disconnect();
      }).toJS;
      oscillator.start(now);
      oscillator.stop(now + .085);
    } catch (_) {}
  }

  void dispose() {
    _disposed = true;
    final context = _context;
    _context = null;
    if (context != null) context.close().toDart.catchError((_) => null);
  }
}
