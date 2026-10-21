import 'dart:convert';

class AiAssistantScreenContext {
  AiAssistantScreenContext({
    required this.screenName,
    required this.route,
    required this.stage,
    required this.goal,
    this.visibleFields = const <String>[],
    this.filledFields = const <String, String>{},
    this.notes = const <String>[],
    this.references = const <String, int>{},
    this.visibleRecords = const <AiRecordReference>[],
    this.draft = const <String, dynamic>{},
  });

  final String screenName;
  final String route;
  final String stage;
  final String goal;
  final List<String> visibleFields;
  final Map<String, String> filledFields;
  final List<String> notes;
  final Map<String, int> references;
  final List<AiRecordReference> visibleRecords;
  final Map<String, dynamic> draft;

  static String _clip(String text, int limit) =>
      String.fromCharCodes(text.runes.take(limit));
  static bool _sensitive(String key) => RegExp(
    r'password|senha|token|secret|api.?key|authorization|credential',
    caseSensitive: false,
  ).hasMatch(key);
  static dynamic _draftValue(dynamic value, int depth) {
    if (depth > 4) return '[limite de profundidade]';
    if (value is String) return _clip(value, 2000);
    if (value is Map)
      return {
        for (final entry in value.entries.take(25))
          if (!_sensitive(entry.key.toString()))
            _clip(entry.key.toString(), 80): _draftValue(
              entry.value,
              depth + 1,
            ),
      };
    if (value is List)
      return value
          .take(20)
          .map((item) => _draftValue(item, depth + 1))
          .toList();
    return value;
  }

  Map<String, dynamic> toJson() {
    var remaining = 6000;
    final fields = <String, String>{};
    for (final entry in filledFields.entries.take(25)) {
      if (_sensitive(entry.key) || remaining <= 0) continue;
      final text = _clip(entry.value, remaining < 2000 ? remaining : 2000);
      fields[_clip(entry.key, 80)] = text;
      remaining -= text.runes.length;
    }
    dynamic safeDraft = _draftValue(draft, 0);
    if (utf8.encode(jsonEncode(safeDraft)).length > 10000) {
      safeDraft = {
        'unsaved': true,
        'limitation': 'Rascunho extenso; considere os campos resumidos atuais.',
      };
    }
    return {
      'version': 1,
      'screen_name': _clip(screenName, 200),
      'route': _clip(route, 300),
      'stage': _clip(stage, 200),
      'goal': _clip(goal, 800),
      'visible_fields': visibleFields
          .take(40)
          .map((field) => _clip(field, 80))
          .toList(),
      'filled_fields': fields,
      'notes': notes.take(12).map((note) => _clip(note, 300)).toList(),
      'references': Map.fromEntries(
        references.entries.where((e) => e.value > 0).take(10),
      ),
      'visible_records': visibleRecords
          .take(20)
          .map((e) => e.toJson())
          .toList(),
      if (draft.isNotEmpty) 'draft': safeDraft,
    };
  }
}

class AiRecordReference {
  const AiRecordReference({
    required this.kind,
    required this.id,
    required this.name,
  });
  final String kind;
  final int id;
  final String name;
  Map<String, dynamic> toJson() => {
    'kind': kind,
    'id': id,
    'name': AiAssistantScreenContext._clip(name, 200),
  };
}
