import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/clue_connection/clue_connection_create_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/webclients/connection_type_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LivingClueConnectScreen extends StatefulWidget {
  const LivingClueConnectScreen({super.key});

  @override
  State<LivingClueConnectScreen> createState() =>
      _LivingClueConnectScreenState();
}

class _LivingClueConnectScreenState extends State<LivingClueConnectScreen> {
  static const String _screenName = 'Vincular pista viva';
  final ClueConnectionCreateController _controller =
      Get.find<ClueConnectionCreateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ItemSelectController _targetSelectController = ItemSelectController();
  final ItemSelectController _typeSelectController = ItemSelectController();
  final TextEditingController _strengthController = TextEditingController(
    text: '1',
  );
  final TextEditingController _evidenceController = TextEditingController();

  LivingClueModel? _sourceClue;
  bool _swapping = false;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is LivingClueModel) {
      _sourceClue = args;
    } else if (args is Map && args['model'] is LivingClueModel) {
      _sourceClue = args['model'] as LivingClueModel;
      if (args['targetId'] is int && args['targetName'] is String) {
        _targetSelectController.selectedItem = ItemSelect(
          id: args['targetId'] as int,
          name: args['targetName'] as String,
        );
      }
      if (args['evidence'] is String) {
        _evidenceController.text = args['evidence'] as String;
      }
    }
  }

  @override
  void dispose() {
    _strengthController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      Get.currentRoute,
      _buildAiContext,
    );
    return SpaceConversationRoom(
      title: const Text('Vincular pistas'),
      eyebrow: 'EC–01 / REDE DE PISTAS',
      subtitle: const Text(
        'Conecte vivências e registre o que aproxima estas pistas.',
      ),
      child: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSourceCard(context),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: _swapping ? null : _swapDirection,
                      icon: const Icon(Icons.swap_vert),
                      label: Text(
                        _swapping
                            ? 'Carregando pista…'
                            : 'Inverter sentido da conexão',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Defina a conexão',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: spaceChatText,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            InputSelectApi(
                              label: '',
                              hint: 'Pista destino',
                              controller: _targetSelectController,
                              validator: (value) => PValidator([
                                PRuleRequired(value, message: 'Obrigatório'),
                              ]).val(),
                              onFind: (search, offset, params) =>
                                  LivingClueWebclient().select(search, offset),
                            ),
                            Insets.large.height,
                            InputSelectApi(
                              label: '',
                              hint: 'Tipo de conexão',
                              controller: _typeSelectController,
                              validator: (value) => PValidator([
                                PRuleRequired(value, message: 'Obrigatório'),
                              ]).val(),
                              onFind: (search, offset, params) =>
                                  ConnectionTypeWebclient().select(
                                    search,
                                    offset,
                                  ),
                            ),
                            Insets.large.height,
                            ManagementInput(
                              hintText: 'Intensidade da conexão',
                              keyboardType: TextInputType.number,
                              controller: _strengthController,
                              validator: (value) => PValidator([
                                PRuleInteger(
                                  value,
                                  message: 'Use um número inteiro',
                                ),
                              ]).val(),
                            ),
                            Insets.large.height,
                            ManagementInput(
                              hintText: 'Evidência (opcional)',
                              controller: _evidenceController,
                              maxLines: 3,
                            ),
                            Insets.extraLarge.height,
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                final bool loading =
                                    _controller.isLoading.value;
                                final String buttonTitle = loading
                                    ? 'Vinculando...'
                                    : 'Salvar conexão';
                                return FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: spaceChatAccent,
                                    foregroundColor: const Color(0xFF06202A),
                                    minimumSize: const Size.fromHeight(44),
                                  ),
                                  onPressed: loading ? null : _save,
                                  child: Text(buttonTitle),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
      stage: 'criação de conexão entre pistas',
      goal:
          'conectar a pista de origem a outra pista com tipo, força e evidência',
      visibleFields: const <String>[
        'pista origem',
        'pista destino',
        'tipo de conexão',
        'força',
        'evidência',
      ],
      filledFields: <String, String>{
        'pista origem': _sourceClue?.name ?? 'não informada',
        if (_targetSelectController.selectedItem?.name != null)
          'pista destino': _targetSelectController.selectedItem!.name,
        if (_typeSelectController.selectedItem?.name != null)
          'tipo de conexão': _typeSelectController.selectedItem!.name,
        if (_strengthController.text.trim().isNotEmpty)
          'força': _strengthController.text.trim(),
        if (_evidenceController.text.trim().isNotEmpty)
          'evidência': _evidenceController.text.trim(),
      },
      notes: const <String>['A pista destino deve ser diferente da origem.'],
    );
  }

  Widget _buildSourceCard(BuildContext context) {
    if (_sourceClue == null) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
        ),
        color: const Color(0xFF321D2A),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Não foi possível identificar a pista de origem.',
            style: TextStyle(color: const Color(0xFFFFB5BA)),
          ),
        ),
      );
    }

    final clue = _sourceClue!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pista origem',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: spaceChatMuted),
            ),
            const SizedBox(height: 6),
            Text(
              clue.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: spaceChatAccent,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.category_outlined, size: 18, color: spaceChatMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    clue.category?.name ?? 'Categoria ${clue.categoryId}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.place_outlined,
                  size: 18,
                  color: spaceChatMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Lat ${clue.latitude?.toStringAsFixed(5) ?? '—'} • Lng ${clue.longitude?.toStringAsFixed(5) ?? '—'}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _swapDirection() async {
    final current = _sourceClue;
    final target = _targetSelectController.selectedItem;
    if (current == null || target == null) {
      Get.customSnackbar(
        'Atenção',
        'Selecione a pista destino antes de inverter.',
      );
      return;
    }
    setState(() => _swapping = true);
    try {
      final next = await LivingClueWebclient().fetchById(target.id);
      if (!mounted || _targetSelectController.selectedItem?.id != target.id) {
        return;
      }
      setState(() {
        _sourceClue = next;
        _targetSelectController.selectedItem = ItemSelect(
          id: current.id,
          name: current.name,
        );
      });
    } catch (_) {
      Get.customSnackbar('Erro', 'Não foi possível inverter o sentido.');
    } finally {
      if (mounted) setState(() => _swapping = false);
    }
  }

  Future<void> _save() async {
    if (_swapping || !(_formKey.currentState?.validate() ?? false)) return;
    if (_sourceClue == null) return;

    final int? targetId = _targetSelectController.selectedItem?.id;
    final int? typeId = _typeSelectController.selectedItem?.id;
    final int? strength = int.tryParse(
      _strengthController.text.trim().isEmpty
          ? '1'
          : _strengthController.text.trim(),
    );

    if (targetId == null || typeId == null || strength == null) return;
    if (targetId == _sourceClue!.id) {
      Get.customSnackbar(
        'Atenção',
        'A pista destino deve ser diferente da origem.',
      );
      return;
    }

    final model = ClueConnectionModel(
      id: 0,
      sourceClueId: _sourceClue!.id,
      targetClueId: targetId,
      connectionTypeId: typeId,
      strength: strength,
      evidence: _evidenceController.text.trim().isEmpty
          ? null
          : _evidenceController.text.trim(),
    );

    final bool saved = await _controller.save(model);
    if (saved) {
      Get.secureBack(result: true);
    }
  }
}
