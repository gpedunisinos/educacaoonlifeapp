import 'package:audioplayers/audioplayers.dart';

class TypingAudio {
  AudioPool? _pool;
  Future<void>? _preparing;
  bool _disposed = false;
  Future<void> prepare() => _preparing ??= _prepare();
  Future<void> _prepare() async {
    try {
      final pool = await AudioPool.create(
        source: AssetSource('space/iarete-type.wav'),
        maxPlayers: 3,
      );
      if (_disposed) {
        await pool.dispose();
      } else {
        _pool = pool;
      }
    } catch (_) {}
  }

  void tick() {
    if (!_disposed) _pool?.start(volume: .08).catchError((_) => () async {});
  }

  void dispose() {
    _disposed = true;
    _pool?.dispose();
    _pool = null;
  }
}
