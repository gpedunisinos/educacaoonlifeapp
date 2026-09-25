import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unisinos_usp_app/models/environmental_context_model.dart';

class EnvironmentalContextCard extends StatelessWidget {
  final EnvironmentalContextModel? context;
  final VoidCallback? onRetry;

  const EnvironmentalContextCard({
    super.key,
    required this.context,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.context;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.eco_outlined, color: Colors.green),
                SizedBox(width: 8),
                Text('Contexto socioambiental',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Informações estimadas automaticamente a partir da localização da pista.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (data == null) ...[
              const _ContextMessage(
                icon: Icons.info_outline,
                text: 'O contexto deste território ainda não foi analisado.',
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Analisar agora'),
                ),
              ],
            ] else if (data.status == 'pending' || data.status == 'processing')
              const _ContextMessage(
                icon: Icons.hourglass_top,
                text: 'Analisando o contexto do território…',
                showProgress: true,
              )
            else if (data.status == 'failed') ...[
              const _ContextMessage(
                icon: Icons.info_outline,
                text:
                    'O contexto ainda não pôde ser analisado. A pista permanece disponível.',
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ] else ...[
              _value('Bioma', data.biome),
              _value('Cobertura predominante', data.landCover),
              _value('Vegetação no entorno', _percent(data.vegetationPercent)),
              _value(
                  'Corpo d’água mais próximo', _distance(data.waterDistanceM)),
              _value('Altitude', _meters(data.altitudeM)),
              _value('Declividade média', _percent(data.slopePercent)),
              _value('Ocupação construída', _percent(data.builtUpPercent)),
              _value('Densidade populacional',
                  _density(data.populationDensityKm2)),
              if (data.analyzedAt != null) ...[
                const Divider(height: 22),
                Text(
                  'Análise de ${DateFormat('dd/MM/yyyy HH:mm').format(data.analyzedAt!.toLocal())}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (data.sources.isNotEmpty)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  childrenPadding: EdgeInsets.zero,
                  title: const Text('Fontes e versões'),
                  children: data.sources.entries
                      .map((source) => ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            title: Text(_label(source.key)),
                            trailing: Text(source.value.toString()),
                          ))
                      .toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _value(String label, String? value) {
    if (value == null || value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  String? _percent(double? value) =>
      value == null ? null : '${value.toStringAsFixed(1)}%';
  String? _meters(double? value) =>
      value == null ? null : '${value.toStringAsFixed(0)} m';
  String? _distance(double? value) => _meters(value);
  String? _density(double? value) => value == null
      ? null
      : '${NumberFormat.decimalPattern('pt_BR').format(value)} hab./km²';
  String _label(String value) => value
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class _ContextMessage extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool showProgress;

  const _ContextMessage(
      {required this.icon, required this.text, this.showProgress = false});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          if (showProgress)
            const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
          else
            Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      );
}
