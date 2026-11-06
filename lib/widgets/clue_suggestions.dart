import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/clue_links.dart';
import 'package:unisinos_usp_app/webclients/econectiva_webclient.dart';

class ClueDiscoverySource {
  Future<Map<String, dynamic>> load(int id) async => Map<String, dynamic>.from(
    await EconectivaApi().get('/living_clues/$id/connection_suggestions')
        as Map,
  );
  Future<void> refresh(int id) => EconectivaApi().postEmpty(
    '/living_clues/$id/connection_suggestions/refresh',
  );
  Future<void> dismiss(int id, int suggestion) => EconectivaApi().postEmpty(
    '/living_clues/$id/connection_suggestions/$suggestion/dismiss',
  );
  Future<void> reviewAlias(int id, int alias, String status) async {
    await EconectivaApi().write('PUT', '/living_clues/$id/aliases/$alias', {
      'status': status,
    });
  }
}

class ClueSuggestions extends StatefulWidget {
  const ClueSuggestions({
    super.key,
    required this.clue,
    required this.canAuthor,
    this.source,
    this.onConnectionChanged,
  });
  final LivingClueModel clue;
  final bool canAuthor;
  final ClueDiscoverySource? source;
  final Future<void> Function()? onConnectionChanged;
  @override
  State<ClueSuggestions> createState() => _ClueSuggestionsState();
}

class _ClueSuggestionsState extends State<ClueSuggestions> {
  late final ClueDiscoverySource source =
      widget.source ?? ClueDiscoverySource();
  Timer? timer;
  Map<String, dynamic>? data;
  bool loading = false;
  bool acting = false;
  String? error;
  int polls = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> load() async {
    if (loading || !mounted) return;
    timer?.cancel();
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final result = await source.load(widget.clue.id);
      if (!mounted) return;
      setState(() => data = result);
      if (['queued', 'processing'].contains(result['status']) && polls++ < 15) {
        timer = Timer(const Duration(seconds: 2), load);
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => error =
              'Não foi possível carregar as sugestões. Sua pista continua disponível.',
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> act(Future<void> Function() action) async {
    if (acting) return;
    setState(() => acting = true);
    try {
      await action();
      polls = 0;
      await load();
    } catch (_) {
      if (mounted) {
        setState(
          () => error = 'Não foi possível concluir a ação. Tente novamente.',
        );
      }
    } finally {
      if (mounted) setState(() => acting = false);
    }
  }

  Future<void> connect(Map<String, dynamic> suggestion) async {
    final target = Map<String, dynamic>.from(suggestion['target_clue'] as Map);
    final saved = await Get.toNamed(
      '/living_clues/connect',
      arguments: {
        'model': widget.clue,
        'targetId': target['id'],
        'targetName': target['name'],
        'evidence': suggestion['evidence'],
      },
    );
    if (!mounted) return;
    if (saved == true) await widget.onConnectionChanged?.call();
    await load();
  }

  List<Map<String, dynamic>> list(String key) => (data?[key] as List? ?? [])
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList();

  @override
  Widget build(BuildContext context) {
    if (data?['status'] == 'unavailable' && list('aliases').isEmpty) {
      return const SizedBox.shrink();
    }
    final suggestions = list('suggestions');
    final aliases = list('aliases');
    final pending = aliases.where((a) => a['status'] == 'pending').toList();
    final approved = aliases.where((a) => a['status'] == 'approved').toList();
    final busy = ['queued', 'processing'].contains(data?['status']);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF386C81)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.hub_outlined, color: Color(0xFF80D6EE)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Conexões que você pode explorar',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Possibilidades identificadas no texto e na rede. Revise o destino, o tipo e o sentido da conexão antes de confirmar.',
            ),
            if (loading || acting) ...[
              const SizedBox(height: 12),
              const LinearProgressIndicator(),
            ],
            if (error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(error!),
              ),
            if (data?['status'] == 'failed')
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  data?['message']?.toString() ??
                      'A análise está temporariamente indisponível.',
                ),
              ),
            if (busy)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Estamos procurando referências e possibilidades de conexão…',
                ),
              ),
            if (data?['status'] == 'ready' && suggestions.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Nenhuma nova conexão sugerida por enquanto. Você pode acrescentar nomes alternativos ou mais informações à descrição.',
                ),
              ),
            for (final item in suggestions) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2231),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['target_clue']?['name']?.toString() ?? 'Pista',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (item['target_clue']?['category']?['name'] != null)
                      Text(
                        item['target_clue']['category']['name'].toString(),
                        style: const TextStyle(color: Color(0xFF8FC2D8)),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      item['reason']?.toString() ?? '',
                      style: const TextStyle(color: Color(0xFFCCDDE5)),
                    ),
                    if ((item['evidence']?.toString() ?? '').isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '“${item['evidence']}”',
                        style: const TextStyle(
                          color: Color(0xFFB3C7D1),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: acting
                              ? null
                              : () => Get.toNamed(
                                  ClueLinks.route(
                                    item['target_clue_id'] as int,
                                  ),
                                ),
                          child: const Text('Ver pista'),
                        ),
                        if (widget.canAuthor) ...[
                          FilledButton(
                            onPressed: acting ? null : () => connect(item),
                            child: const Text('Revisar conexão'),
                          ),
                          TextButton(
                            onPressed: acting
                                ? null
                                : () => act(
                                    () => source.dismiss(
                                      widget.clue.id,
                                      item['id'] as int,
                                    ),
                                  ),
                            child: const Text('Dispensar'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (approved.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Também conhecido como',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Wrap(
                spacing: 8,
                children: [
                  for (final alias in approved)
                    Chip(label: Text(alias['name'].toString())),
                ],
              ),
            ],
            if (pending.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Nomes alternativos para conferir',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text(
                'Encontramos uma possível equivalência no texto. Ela só será utilizada após confirmação.',
              ),
              for (final alias in pending)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alias['name'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(alias['evidence']?.toString() ?? ''),
                      if (widget.canAuthor)
                        Wrap(
                          children: [
                            TextButton(
                              onPressed: acting
                                  ? null
                                  : () => act(
                                      () => source.reviewAlias(
                                        widget.clue.id,
                                        alias['id'] as int,
                                        'approved',
                                      ),
                                    ),
                              child: const Text('Confirmar nome'),
                            ),
                            TextButton(
                              onPressed: acting
                                  ? null
                                  : () => act(
                                      () => source.reviewAlias(
                                        widget.clue.id,
                                        alias['id'] as int,
                                        'rejected',
                                      ),
                                    ),
                              child: const Text('Dispensar nome'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
            ],
            if (list('unresolved').isNotEmpty)
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                title: const Text('Outras referências a conferir'),
                subtitle: const Text(
                  'Nomes encontrados sem uma pista correspondente identificada. Podem precisar de revisão.',
                ),
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final entity in list('unresolved'))
                        Chip(label: Text(entity['name'].toString())),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 8),
            Wrap(
              children: [
                TextButton.icon(
                  onPressed: loading || acting
                      ? null
                      : () {
                          polls = 0;
                          load();
                        },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Atualizar sugestões'),
                ),
                if (widget.canAuthor && data?['status'] == 'failed')
                  TextButton(
                    onPressed: acting
                        ? null
                        : () => act(() => source.refresh(widget.clue.id)),
                    child: const Text('Tentar análise novamente'),
                  ),
              ],
            ),
            if (!widget.canAuthor)
              const Text(
                'Para revisar nomes e criar conexões, utilize o modo Inventor.',
              ),
          ],
        ),
      ),
    );
  }
}
