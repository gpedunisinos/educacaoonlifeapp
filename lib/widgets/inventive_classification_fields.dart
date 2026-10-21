import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/inventive/inventive_catalog.dart';

Future<void> _reference(BuildContext context, String url) async {
  try {
    if (await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication))
      return;
  } catch (_) {
    /* External references never block the form. */
  }
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Não foi possível abrir a referência. Você pode continuar o preenchimento.',
        ),
      ),
    );
  }
}

Future<void> showInventiveConcept(
  BuildContext context,
  InventiveConcept concept,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    backgroundColor: const Color(0xFF10212D),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0x665EDCD1)),
    ),
    title: Text(concept.label),
    content: SizedBox(
      width: 620,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(concept.summary),
            const SizedBox(height: 18),
            Text(concept.reference),
            TextButton.icon(
              onPressed: () => _reference(context, concept.url),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Consultar referência'),
            ),
            if (concept.code == 'vic')
              TextButton(
                onPressed: () => _reference(
                  context,
                  'https://publications.immersivelrn.org/index.php/practitioner/article/view/442',
                ),
                child: const Text(
                  'Sitnievski e Schlemmer, 2025 — referência complementar',
                ),
              ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Voltar'),
      ),
    ],
  ),
);

Future<void> showInventiveGuide(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    backgroundColor: const Color(0xFF10212D),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0x665EDCD1)),
    ),
    title: const Text('Práticas e metodologias'),
    content: SizedBox(
      width: 680,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Práticas são vivências e ações pedagógicas que se desenvolvem nas relações e conexões de cada contexto. Metodologias inventivas são percursos investigativos orientados por pistas, que se constituem no caminhar.',
            ),
            const SizedBox(height: 12),
            const Text(
              'As opções são independentes e opcionais. As referências ajudam a compreender cada abordagem; não constituem um roteiro obrigatório.',
            ),
            for (final key in InventiveCatalog.keys) ...[
              const SizedBox(height: 16),
              Text(
                InventiveCatalog.title(key),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              for (final concept in InventiveCatalog.options(key))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(concept.label),
                  trailing: const Icon(Icons.info_outline),
                  onTap: () => showInventiveConcept(context, concept),
                ),
            ],
            TextButton.icon(
              onPressed: () => _reference(context, InventiveCatalog.sourceUrl),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Consultar documento de referências'),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Voltar'),
      ),
    ],
  ),
);

/// Controlled widget: only explicit edits are returned. Opening explanations,
/// dismissing the selector, or changing category never rewrites saved values.
class InventiveClassificationFields extends StatelessWidget {
  final List<String> enabledKeys;
  final Map<String, dynamic> metadata;
  final void Function(String key, dynamic value)? onChanged;
  const InventiveClassificationFields({
    super.key,
    this.enabledKeys = const [],
    required this.metadata,
    this.onChanged,
  });

  Future<void> _select(BuildContext context, String key) async {
    final selected = InventiveCatalog.codes(metadata[key]).toSet();
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocalState) => AlertDialog(
          backgroundColor: const Color(0xFF10212D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0x665EDCD1)),
          ),
          title: Text(InventiveCatalog.title(key)),
          content: SizedBox(
            width: 680,
            height: MediaQuery.sizeOf(context).height * .58,
            child: ListView(
              children: [
                const Text(
                  'Selecione quantas opções fizerem sentido para esta vivência.',
                ),
                for (final concept in InventiveCatalog.options(key))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(concept.label),
                          value: selected.contains(concept.code),
                          onChanged: (value) => setLocalState(() {
                            if (value == true) {
                              selected.add(concept.code);
                            } else {
                              selected.remove(concept.code);
                            }
                          }),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Conhecer ${concept.label}',
                        onPressed: () => showInventiveConcept(context, concept),
                        icon: const Icon(Icons.info_outline),
                      ),
                    ],
                  ),
                for (final code in InventiveCatalog.codes(
                  metadata[key],
                ).where((code) => InventiveCatalog.find(key, code) == null))
                  CheckboxListTile(
                    title: const Text(
                      'Classificação não reconhecida nesta versão',
                    ),
                    subtitle: Text(code),
                    value: selected.contains(code),
                    onChanged: (value) => setLocalState(() {
                      if (value == true) {
                        selected.add(code);
                      } else {
                        selected.remove(code);
                      }
                    }),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => setLocalState(selected.clear),
              child: const Text('Limpar seleção'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, selected.toList()),
              child: const Text('Confirmar'),
            ),
          ],
        ),
      ),
    );
    if (result != null) onChanged?.call(key, result);
  }

  @override
  Widget build(BuildContext context) {
    final editing = onChanged != null;
    final keys = InventiveCatalog.keys
        .where(
          (key) =>
              (editing && enabledKeys.contains(key)) ||
              InventiveCatalog.hasValue(metadata[key]),
        )
        .toList();
    if (keys.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102C35),
        border: Border.all(color: const Color(0x665EDCD1)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            editing
                ? 'Práticas e metodologias — opcional'
                : 'Práticas e metodologias',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (editing)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Identifique as abordagens relacionadas a esta vivência. Você pode selecionar mais de uma opção ou deixar os campos em branco.',
              ),
            ),
          TextButton.icon(
            onPressed: () => showInventiveGuide(context),
            icon: const Icon(Icons.menu_book_outlined),
            label: const Text('Conhecer os conceitos e referências'),
          ),
          for (final key in keys) ...[
            const SizedBox(height: 12),
            Text(
              editing
                  ? InventiveCatalog.title(key)
                  : InventiveCatalog.group(key),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            if (InventiveCatalog.isLegacy(metadata[key])) ...[
              const Text(
                'Registro legado — conteúdo preservado, sem conversão automática.',
              ),
              SelectableText(metadata[key].toString()),
              if (editing)
                TextButton.icon(
                  onPressed: () => onChanged!(key, <String>[]),
                  icon: const Icon(Icons.clear),
                  label: const Text('Remover registro legado'),
                ),
            ] else ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final code in InventiveCatalog.codes(metadata[key]))
                    InputChip(
                      label: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: (MediaQuery.sizeOf(context).width - 180)
                              .clamp(110.0, 650.0),
                        ),
                        child: Text(
                          InventiveCatalog.label(key, code),
                          softWrap: true,
                          maxLines: 6,
                        ),
                      ),
                      onPressed: () {
                        final concept = InventiveCatalog.find(key, code);
                        if (concept != null) {
                          showInventiveConcept(context, concept);
                        } else {
                          showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF10212D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                                side: const BorderSide(
                                  color: Color(0x665EDCD1),
                                ),
                              ),
                              title: const Text(
                                'Classificação não reconhecida nesta versão',
                              ),
                              content: Text('Código preservado: $code'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Voltar'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      onDeleted: editing
                          ? () => onChanged!(
                              key,
                              InventiveCatalog.codes(metadata[key])
                                ..remove(code),
                            )
                          : null,
                    ),
                ],
              ),
              if (editing)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton.icon(
                    onPressed: () => _select(context, key),
                    icon: const Icon(Icons.playlist_add_check),
                    label: Text(
                      'Selecionar ${InventiveCatalog.group(key).toLowerCase()}',
                    ),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }
}
