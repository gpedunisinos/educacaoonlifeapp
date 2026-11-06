import 'package:flutter/material.dart';

List<String> parseClueAliases(String value) => value
    .split(RegExp(r'[;\n]'))
    .map((name) => name.trim())
    .where((name) => name.isNotEmpty)
    .toSet()
    .toList();

class ClueAliasField extends StatelessWidget {
  const ClueAliasField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    maxLines: 2,
    decoration: const InputDecoration(
      labelText: 'Também conhecido como (opcional)',
      hintText: 'Ex.: Unisinos; Universidade do Vale do Rio dos Sinos',
      helperText:
          'Separe os nomes por ponto e vírgula. Use nomes desta pista, não de entidades mencionadas na descrição.',
      helperMaxLines: 4,
    ),
    validator: (value) {
      final names = parseClueAliases(value ?? '');
      if (names.length > 20) return 'Informe até 20 nomes alternativos.';
      if (names.any(
        (name) => name.runes.length < 2 || name.runes.length > 120,
      )) {
        return 'Cada nome deve ter entre 2 e 120 caracteres.';
      }
      return null;
    },
  );
}
