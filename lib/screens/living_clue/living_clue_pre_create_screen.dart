import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/webclients/category_select_webclient.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingCluePreCreateScreen extends StatefulWidget {
  const LivingCluePreCreateScreen({super.key});

  @override
  State<LivingCluePreCreateScreen> createState() => _LivingCluePreCreateScreenState();
}

class _LivingCluePreCreateScreenState extends State<LivingCluePreCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ItemSelectController _categorySelectController = ItemSelectController();
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escolha a categoria'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputSelectApi(
                label: 'Categoria',
                controller: _categorySelectController,
                validator: (value) => PValidator([
                  PRuleRequired(value, message: 'Obrigatório'),
                ]).val(),
                onFind: (search, offset, params) => CategorySelectWebclient().select(search, offset),
              ),
              Insets.extraLarge.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: _loading ? 'Carregando...' : 'Continuar',
                  onPressed: _loading ? null : _continue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final int? categoryId = _categorySelectController.selectedItem?.id;
    final String? categoryName = _categorySelectController.selectedItem?.name;
    if (categoryId == null || categoryName == null) return;

    setState(() => _loading = true);
    try {
      final CategoryModel category = await CategoryWebclient().fetchById(categoryId);
      final args = Get.arguments;
      final result = await Get.toNamed(
        '/living_clues/create',
        arguments: {
          'categoryId': category.id,
          'categoryName': category.name,
          'metadataTags': category.metadataTags,
          if (args is Map && args['latitude'] != null) 'latitude': args['latitude'],
          if (args is Map && args['longitude'] != null) 'longitude': args['longitude'],
        },
      );
      if (result == true) {
        Get.back(result: true);
      }
    } catch (_) {
      Get.snackbar('Categoria', 'Não foi possível carregar a categoria selecionada.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
