import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';

class LivingClueShowScreen extends StatelessWidget {
  const LivingClueShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final LivingClueModel model = args is LivingClueModel ? args : args['model'] as LivingClueModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pista viva'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/living_clues/update', parameters: {'id': model.id.toString()}),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(model.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(model.description ?? 'Sem descrição'),
            const SizedBox(height: 16),
            Text('Categoria ID: ${model.categoryId}'),
            const SizedBox(height: 8),
            Text('Latitude: ${model.latitude}'),
            Text('Longitude: ${model.longitude}'),
            const SizedBox(height: 8),
            Text('Ativa: ${model.isActive ? 'Sim' : 'Não'}'),
            if (model.imageUrl != null && model.imageUrl!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text('Imagem: ${model.imageUrl}'),
            ],
            if (model.metadata != null && model.metadata!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Metadata'),
              const SizedBox(height: 8),
              ...model.metadata!.entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTagLabel(entry.key),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(entry.value?.toString() ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTagLabel(String raw) {
    final cleaned = raw.replaceAll('_', ' ');
    return cleaned.split(' ').where((part) => part.isNotEmpty).map((part) => part[0].toUpperCase() + part.substring(1)).join(' ');
  }
}
