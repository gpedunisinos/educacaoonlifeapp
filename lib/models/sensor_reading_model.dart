import 'dart:convert';

/// Read-only observations returned with the clue. Never serialized in clue edits.
class SensorReadingModel {
  const SensorReadingModel({
    required this.id,
    required this.livingClueId,
    required this.payloadRaw,
    this.contentType = '',
    this.receivedAt,
  });
  final int id;
  final int livingClueId;
  final String payloadRaw;
  final String contentType;
  final DateTime? receivedAt;

  factory SensorReadingModel.fromJson(Map<String, dynamic> json) =>
      SensorReadingModel(
        id: int.tryParse('${json['id']}') ?? 0,
        livingClueId: int.tryParse('${json['living_clue_id']}') ?? 0,
        payloadRaw: json['payload_raw']?.toString() ?? '',
        contentType: json['content_type']?.toString() ?? '',
        receivedAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      );

  dynamic get decodedPayload {
    try {
      return jsonDecode(payloadRaw);
    } on FormatException {
      return null;
    }
  }

  Map<String, dynamic> get fields {
    final decoded = decodedPayload;
    return decoded is Map ? Map<String, dynamic>.from(decoded) : const {};
  }

  Map<String, dynamic> get units {
    final value = fields['unidades'] ?? fields['units'];
    return value is Map ? Map<String, dynamic>.from(value) : const {};
  }

  bool get markedAsFictitious => fields['dados_ficticios'] == true;

  String get formattedPayload {
    final decoded = decodedPayload;
    return decoded == null
        ? payloadRaw
        : const JsonEncoder.withIndent('  ').convert(decoded);
  }
}
