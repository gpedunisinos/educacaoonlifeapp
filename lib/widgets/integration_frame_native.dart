import 'package:flutter/material.dart';

class IntegrationFrame extends StatelessWidget {
  const IntegrationFrame({
    super.key,
    required this.uri,
    required this.title,
    this.media = false,
  });
  final Uri uri;
  final String title;
  final bool media;
  @override
  Widget build(BuildContext context) => const Center(
    child: Text('Conteúdo preservado. Disponível no navegador.'),
  );
}
