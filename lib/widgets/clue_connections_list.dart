import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';

/// A compact overview with a local search across all loaded relationships.
class ClueConnectionsList extends StatefulWidget {
  const ClueConnectionsList({
    super.key,
    required this.clueId,
    required this.connections,
    required this.itemBuilder,
  });

  final int clueId;
  final List<ClueConnectionModel> connections;
  final Widget Function(BuildContext, ClueConnectionModel) itemBuilder;

  @override
  State<ClueConnectionsList> createState() => _ClueConnectionsListState();
}

class _ClueConnectionsListState extends State<ClueConnectionsList> {
  static const _searchThreshold = 5;
  final _search = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String _normalize(String text) {
    var value = text.toLowerCase();
    const accents = ['áàâãä', 'éèêë', 'íìîï', 'óòôõö', 'úùûü', 'ç', 'ñ'];
    const replacements = ['a', 'e', 'i', 'o', 'u', 'c', 'n'];
    for (var i = 0; i < accents.length; i++) {
      value = value.replaceAll(RegExp('[${accents[i]}]'), replacements[i]);
    }
    return value;
  }

  int _group(ClueConnectionModel connection) {
    if (!(connection.connectionType?.isDirectional ?? true)) return 2;
    return connection.isOutgoingFrom(widget.clueId) ? 0 : 1;
  }

  @override
  Widget build(BuildContext context) {
    final searchable = widget.connections.length > _searchThreshold;
    final terms = _normalize(_search.text).trim().split(RegExp(r'\s+'));
    final matches = widget.connections.where((connection) {
      if (!searchable) return true;
      final clue = connection.relatedClueFor(widget.clueId);
      final text = _normalize(
        [
          clue?.name ?? '',
          clue?.category?.name ?? '',
          connection.connectionType?.name ?? '',
        ].join(' '),
      );
      return terms.every(text.contains);
    }).toList();
    // Preserve the previous grouping and server order within each group.
    final ordered = [
      for (var group = 0; group < 3; group++)
        ...matches.where((item) => _group(item) == group),
    ];
    final visible = ordered;

    Widget row(int index) {
      final connection = visible[index];
      final group = _group(connection);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index == 0 || _group(visible[index - 1]) != group)
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Text(
                const [
                  'Relações que partem desta pista',
                  'Relações que chegam nesta pista',
                  'Pistas relacionadas',
                ][group],
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          widget.itemBuilder(context, connection),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (searchable) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _search,
            onChanged: (_) {
              if (_scroll.hasClients) _scroll.jumpTo(0);
              setState(() {});
            },
            decoration: InputDecoration(
              labelText: 'Pesquisar pistas relacionadas',
              hintText: 'Nome, categoria ou tipo de relação',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpar pesquisa',
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _search.clear();
                        if (_scroll.hasClients) _scroll.jumpTo(0);
                        setState(() {});
                      },
                    ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _search.text.trim().isEmpty
                ? '${widget.connections.length} relações'
                : '${ordered.length} de ${widget.connections.length} relações encontradas',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        if (visible.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Text('Nenhuma pista encontrada para esta pesquisa.'),
          )
        else if (visible.length > _searchThreshold)
          SizedBox(
            height: (MediaQuery.sizeOf(context).height * .6).clamp(
              240.0,
              560.0,
            ),
            child: Scrollbar(
              controller: _scroll,
              thumbVisibility: true,
              child: ListView.builder(
                controller: _scroll,
                primary: false,
                itemCount: visible.length,
                itemBuilder: (_, index) => row(index),
              ),
            ),
          )
        else
          for (var i = 0; i < visible.length; i++) row(i),
      ],
    );
  }
}
