import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unisinos_usp_app/models/sensor_reading_model.dart';

const _sensorAccent = Color(0xFF9CE7DF);
const _sensorMuted = Color(0xFF9DB9C7);

/// Bounded snapshot, newest first, with manual refresh instead of background
/// polling. Values and units come from the device, without inferred units.
class ClueSensorReadings extends StatelessWidget {
  const ClueSensorReadings({
    super.key,
    required this.readings,
    required this.onRefresh,
    this.refreshing = false,
    this.error,
  });
  final List<SensorReadingModel> readings;
  final Future<void> Function() onRefresh;
  final bool refreshing;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final ordered = List<SensorReadingModel>.of(readings)
      ..sort((a, b) => b.id.compareTo(a.id));
    final recent = ordered.take(10).toList();
    return Card(
      key: const ValueKey('clue-sensor-readings'),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 20,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sensors, color: _sensorAccent, size: 22),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        'Leituras dos sensores',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: refreshing ? null : onRefresh,
                  icon: refreshing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh, size: 18),
                  label: Text(
                    refreshing ? 'Atualizando…' : 'Atualizar leituras',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Últimos envios recebidos pela API para esta pista. Atualize para consultar novos registros.',
              style: TextStyle(color: _sensorMuted, height: 1.5),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(
                  error!,
                  style: const TextStyle(color: Color(0xFFF2C0A4)),
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (recent.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Nenhuma leitura de sensor recebida para esta pista.',
                ),
              )
            else ...[
              _LatestReading(reading: recent.first),
              if (recent.length > 1) ...[
                const SizedBox(height: 12),
                ExpansionTile(
                  key: const PageStorageKey('previous-sensor-readings'),
                  tilePadding: EdgeInsets.zero,
                  title: Text('Leituras anteriores (${recent.length - 1})'),
                  subtitle: const Text(
                    'Horários de recebimento neste dispositivo',
                    style: TextStyle(color: _sensorMuted, fontSize: 12),
                  ),
                  children: [
                    for (final reading in recent.skip(1))
                      ExpansionTile(
                        key: PageStorageKey(
                          'sensor-history-${reading.livingClueId}-${reading.id}',
                        ),
                        tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                        title: Text(_receivedLabel(reading)),
                        subtitle: Text('Registro #${reading.id}'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _ReadingContent(reading: reading),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Text(
                '${recent.length} ${recent.length == 1 ? 'registro recebido' : 'registros mais recentes'} · até 10 por consulta',
                style: const TextStyle(color: _sensorMuted, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

String _receivedLabel(SensorReadingModel reading) {
  final date = reading.receivedAt?.toLocal();
  if (date == null) return 'Horário de recebimento não informado';
  String two(int value) => value.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year} às ${two(date.hour)}:${two(date.minute)}:${two(date.second)}';
}

class _LatestReading extends StatelessWidget {
  const _LatestReading({required this.reading});
  final SensorReadingModel reading;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF102C35),
      border: Border.all(color: const Color(0x665EDCD1)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ÚLTIMA LEITURA RECEBIDA',
          style: TextStyle(
            color: _sensorAccent,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _receivedLabel(reading),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const Text(
          'Horário de recebimento neste dispositivo',
          style: TextStyle(color: _sensorMuted, fontSize: 11),
        ),
        const SizedBox(height: 14),
        _ReadingContent(reading: reading),
      ],
    ),
  );
}

class _ReadingContent extends StatelessWidget {
  const _ReadingContent({required this.reading});
  final SensorReadingModel reading;
  @override
  Widget build(BuildContext context) {
    final fields = reading.fields.entries
        .where((e) => e.value is! Map && e.value is! List)
        .toList();
    final units = reading.units;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (reading.markedAsFictitious) ...[
          const Text(
            'Dados sinalizados como fictícios pelo dispositivo',
            style: TextStyle(
              color: Color(0xFFEFBF79),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (fields.isNotEmpty)
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 520
                  ? 1
                  : constraints.maxWidth < 860
                  ? 2
                  : 3;
              final width =
                  (constraints.maxWidth - (columns - 1) * 10) / columns;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final entry in fields.take(12))
                    SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF091B2A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key.replaceAll('_', ' '),
                              style: const TextStyle(
                                color: _sensorMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 5),
                            SelectableText(
                              // EditableText has its own scroll position. Keep it
                              // separate from ExpansionTile's boolean storage.
                              key: PageStorageKey(
                                'sensor-value-${reading.livingClueId}-${reading.id}-${entry.key}',
                              ),
                              '${_value(entry.value)}${units[entry.key] == null ? '' : ' ${units[entry.key]}'}',
                              style: const TextStyle(
                                color: Color(0xFFE2F1F5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        if (fields.length > 12)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Consulte os demais campos nos dados completos.',
              style: TextStyle(color: _sensorMuted),
            ),
          ),
        if (fields.isEmpty) ...[
          Text(
            _excerpt(reading.payloadRaw),
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 8),
        ],
        ExpansionTile(
          key: PageStorageKey(
            'sensor-payload-${reading.livingClueId}-${reading.id}',
          ),
          tilePadding: EdgeInsets.zero,
          title: const Text('Ver dados completos'),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 12,
                children: [
                  Text(
                    'Registro #${reading.id}',
                    style: const TextStyle(color: _sensorMuted, fontSize: 12),
                  ),
                  if (reading.contentType.isNotEmpty)
                    Text(
                      reading.contentType,
                      style: const TextStyle(color: _sensorMuted, fontSize: 12),
                    ),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: reading.payloadRaw),
                      );
                      if (context.mounted)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dados recebidos copiados.'),
                          ),
                        );
                    },
                    icon: const Icon(Icons.copy_outlined, size: 16),
                    label: const Text('Copiar dados'),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: const Color(0xFF050C18),
              constraints: const BoxConstraints(maxHeight: 260),
              child: SingleChildScrollView(
                key: PageStorageKey(
                  'sensor-payload-scroll-${reading.livingClueId}-${reading.id}',
                ),
                child: SelectableText(
                  key: PageStorageKey(
                    'sensor-raw-text-${reading.livingClueId}-${reading.id}',
                  ),
                  _excerpt(reading.formattedPayload, limit: 16000),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static String _value(dynamic value) => value == null
      ? 'Não informado'
      : value == true
      ? 'Sim'
      : value == false
      ? 'Não'
      : value.toString();
  static String _excerpt(String value, {int limit = 400}) => value.isEmpty
      ? 'Envio sem conteúdo.'
      : value.length <= limit
      ? value
      : '${value.substring(0, limit)}…\nConteúdo extenso. Use Copiar dados para consultar o envio integral.';
}
