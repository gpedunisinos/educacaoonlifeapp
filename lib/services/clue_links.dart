import 'package:widgets_spo/utils.dart';

/// Only read-only pista destinations may survive authentication. No arbitrary
/// URLs, authoring routes, credentials or query strings are accepted.
class ClueLinks {
  static const _key = 'onlife_clue_return_v1';
  static String route(int id) {
    if (id <= 0) throw ArgumentError.value(id, 'id');
    return '/space/research/$id';
  }

  static String publicUrl(int id) =>
      'https://educacaoonlife.gpedu.com.br/#${route(id)}';

  static String? safeTarget(String? raw) {
    if (raw == null || raw.length > 150 || raw != raw.trim()) return null;
    final match = RegExp(
      r'^/space/research/([1-9][0-9]{0,14})$',
    ).firstMatch(raw);
    if (match != null) return route(int.parse(match[1]!));
    final legacy = RegExp(
      r'^/living_clues/([1-9][0-9]{0,14})$',
    ).firstMatch(raw);
    if (legacy != null) return route(int.parse(legacy[1]!));
    final show = RegExp(
      r'^/living_clues/show\?id=([1-9][0-9]{0,14})$',
    ).firstMatch(raw);
    return show == null ? null : route(int.parse(show[1]!));
  }

  static void remember(String? raw) {
    final safe = safeTarget(raw);
    if (safe == null) return;
    try {
      Util.prefs.setString(_key, safe);
    } catch (_) {
      /* URL remains authoritative during startup. */
    }
  }

  static String? pending([String? candidate]) {
    final safe = safeTarget(candidate);
    if (safe != null) {
      remember(safe);
      return safe;
    }
    try {
      return safeTarget(Util.prefs.getString(_key));
    } catch (_) {
      return null;
    }
  }

  static void clear() {
    try {
      Util.prefs.remove(_key);
    } catch (_) {
      /* Preferences not initialized in isolated navigation. */
    }
  }

  static String authRoute(String base, String? target) {
    final safe = safeTarget(target);
    return safe == null ? base : '$base?returnTo=${Uri.encodeComponent(safe)}';
  }
}
