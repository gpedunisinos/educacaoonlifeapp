import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/clue_connection/clue_connection_update_controller.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/webclients/connection_type_webclient.dart';
import 'package:unisinos_usp_app/webclients/living_clue_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';
import 'package:unisinos_usp_app/screens/management/management_input.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClueConnectionUpdateScreen extends StatefulWidget {
  const ClueConnectionUpdateScreen({super.key});

  @override
  State<ClueConnectionUpdateScreen> createState() =>
      _ClueConnectionUpdateScreenState();
}

class _ClueConnectionUpdateScreenState
    extends State<ClueConnectionUpdateScreen> {
  final ClueConnectionUpdateController _controller =
      Get.find<ClueConnectionUpdateController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ItemSelectController _sourceSelectController = ItemSelectController();
  final ItemSelectController _targetSelectController = ItemSelectController();
  final ItemSelectController _typeSelectController = ItemSelectController();
  final TextEditingController _strengthController = TextEditingController(
    text: '1',
  );
  final TextEditingController _evidenceController = TextEditingController();
  bool _filled = false;

  @override
  void dispose() {
    _strengthController.dispose();
    _evidenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SpaceConversationRoom(
      title: const Text('Editar vínculo entre pistas'),
      eyebrow: 'EC–01 / REDE DE PISTAS',
      subtitle: const Text(
        'Conecte vivências e registre o que aproxima estas pistas.',
      ),
      child: Stack(
        children: [
          Obx(() {
            if (_controller.connectionId == null) {
              return const Center(
                child: Text(
                  'Conexão não informada.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (_controller.isLoading.value &&
                _controller.connection.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            if (_controller.connection.value == null) {
              return const Center(
                child: Text(
                  'Conexão não encontrada.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (!_filled && _controller.connection.value != null) {
              final ClueConnectionModel model = _controller.connection.value!;
              _sourceSelectController.selectedItem = ItemSelect(
                id: model.sourceClueId,
                name: model.sourceClueId.toString(),
              );
              _targetSelectController.selectedItem = ItemSelect(
                id: model.targetClueId,
                name: model.targetClueId.toString(),
              );
              _typeSelectController.selectedItem = ItemSelect(
                id: model.connectionTypeId,
                name: model.connectionTypeId.toString(),
              );
              _strengthController.text = model.strength.toString();
              _evidenceController.text = model.evidence ?? '';
              _filled = true;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputSelectApi(
                      label: '',
                      hint: 'Pista origem',
                      controller: _sourceSelectController,
                      validator: (value) => PValidator([
                        PRuleRequired(value, message: 'Obrigatório'),
                      ]).val(),
                      onFind: (search, offset, params) =>
                          LivingClueWebclient().select(search, offset),
                    ),
                    Insets.large.height,
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
                          ConnectionTypeWebclient().select(search, offset),
                    ),
                    Insets.large.height,
                    ManagementInput(
                      hintText: 'Intensidade da conexão',
                      keyboardType: TextInputType.number,
                      controller: _strengthController,
                      validator: (value) => PValidator([
                        PRuleInteger(value, message: 'Use um número inteiro'),
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
                        final bool loading = _controller.isLoading.value;
                        final String buttonTitle = loading
                            ? 'Atualizando...'
                            : 'Atualizar';
                        return ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: buttonTitle,
                          onPressed: loading ? null : _save,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final int? sourceId = _sourceSelectController.selectedItem?.id;
    final int? targetId = _targetSelectController.selectedItem?.id;
    final int? typeId = _typeSelectController.selectedItem?.id;
    final int? strength = int.tryParse(
      _strengthController.text.trim().isEmpty
          ? '1'
          : _strengthController.text.trim(),
    );
    if (sourceId == null ||
        targetId == null ||
        typeId == null ||
        strength == null)
      return;

    final model = ClueConnectionModel(
      id: _controller.connection.value?.id ?? _controller.connectionId ?? 0,
      sourceClueId: sourceId,
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
