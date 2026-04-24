import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';

class LivingClueShowScreen extends StatelessWidget {
  const LivingClueShowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final LivingClueModel model =
        args is LivingClueModel ? args : args['model'] as LivingClueModel;
    final theme = Theme.of(context);
    final categoryName =
        model.category?.name ?? 'Categoria ${model.categoryId}';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const SafeBackButton(),
        title: const Text('Pista viva'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit),
            onPressed: () => Get.toNamed('/living_clues/update',
                parameters: {'id': model.id.toString()}),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: StarfieldBackground()),
          const Positioned.fill(child: CidigScenicBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  model.name,
                                  style: theme.textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Chip(
                                label:
                                    Text(model.isActive ? 'Ativa' : 'Inativa'),
                                backgroundColor: model.isActive
                                    ? Colors.green.shade100
                                    : Colors.grey.shade200,
                                labelStyle: TextStyle(
                                  color: model.isActive
                                      ? Colors.green.shade800
                                      : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.category_outlined,
                                  color: Colors.blueGrey.shade600, size: 18),
                              const SizedBox(width: 6),
                              Text(categoryName,
                                  style: theme.textTheme.bodyMedium),
                            ],
                          ),
                          if ((model.description ?? '').isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              model.description ?? '',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[700]),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Localização',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined,
                                  size: 18, color: Colors.blueGrey),
                              const SizedBox(width: 6),
                              Text('Lat: ${model.latitude.toStringAsFixed(6)}'),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined,
                                  size: 18, color: Colors.transparent),
                              const SizedBox(width: 6),
                              Text(
                                  'Lng: ${model.longitude.toStringAsFixed(6)}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (model.imageUrl != null && model.imageUrl!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0x8A46B6EC),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            color: Colors.grey.shade100,
                            padding: const EdgeInsets.all(12),
                            child: const Text('Imagem'),
                          ),
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.network(
                              model.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Icon(Icons.broken_image)),
                              loadingBuilder: (context, child, progress) =>
                                  progress == null
                                      ? child
                                      : const Center(
                                          child: CircularProgressIndicator()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (model.metadata != null && model.metadata!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Color(0x8A46B6EC),
                          width: 1.2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Metadata',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            ...model.metadata!.entries.map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _formatTagLabel(entry.key),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(entry.value?.toString() ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTagLabel(String raw) {
    final cleaned = raw.replaceAll('_', ' ');
    return cleaned
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}
