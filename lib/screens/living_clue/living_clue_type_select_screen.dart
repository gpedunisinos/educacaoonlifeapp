import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueTypeSelectScreen extends StatefulWidget {
  const LivingClueTypeSelectScreen({super.key});

  @override
  State<LivingClueTypeSelectScreen> createState() =>
      _LivingClueTypeSelectScreenState();
}

class _LivingClueTypeSelectScreenState
    extends State<LivingClueTypeSelectScreen> {
  static const String _screenName = 'Escolha do tipo da pista';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      Get.currentRoute,
      _buildAiContext,
    );

    return SpaceConversationRoom(
      title: const Text('Escolha o tipo da pista'),
      eyebrow: 'EC–01 / NOVA PISTA',
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.alt_route_outlined,
                            color: spaceChatAccent,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Defina o tipo da pista',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: spaceChatText,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Na próxima etapa, escolha uma categoria compatível com o tipo da pista.',
                        style: TextStyle(color: spaceChatMuted),
                      ),
                      Insets.large.height,
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Tipo',
                          border: OutlineInputBorder(),
                        ),
                        items: CategoryType.values
                            .map(
                              (type) => DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedType = value);
                        },
                        validator: (value) => PValidator([
                          PRuleRequired(value, message: 'Obrigatório'),
                        ]).val(),
                      ),
                      Insets.extraLarge.height,
                      SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: 'Continuar',
                          onPressed: _continue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: _screenName,
      route: Get.currentRoute,
      stage: 'pré-cadastro da pista',
      goal: 'selecionar o tipo da pista antes da categoria',
      visibleFields: const <String>['tipo', 'continuar'],
      filledFields: <String, String>{
        'tipo selecionado': _selectedType ?? 'nenhum',
      },
      notes: const <String>[
        'O tipo define quais categorias serão exibidas na próxima tela.',
      ],
    );
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false) ||
        _selectedType == null) {
      return;
    }

    final args = Get.arguments;
    final result = await Get.toNamed(
      '/living_clues/pre_create',
      arguments: <String, dynamic>{
        'type': _selectedType,
        if (args is Map && args['latitude'] != null)
          'latitude': args['latitude'],
        if (args is Map && args['longitude'] != null)
          'longitude': args['longitude'],
      },
    );
    if (_isCreatedResult(result)) {
      Get.back(result: result);
    }
  }

  bool _isCreatedResult(Object? result) {
    return result == true || (result is Map && result['created'] == true);
  }
}
