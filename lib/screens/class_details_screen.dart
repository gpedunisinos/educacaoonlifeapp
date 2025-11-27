import 'package:unisinos_usp_app/controllers/class_controller.dart';
import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClassDetailsScreen extends StatelessWidget {
  final ClassController _controller = Get.find<ClassController>();
  final UserController _userController = Get.find<UserController>();

  ClassDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Obx(() {
            return Text(
              _controller.classDetails.value?.name ?? '',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            );
          }),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Obx(() {
          final classModel = _controller.classDetails.value;

          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (classModel == null) {
            return Center(child: Text('Houve um erro ao carregar a Aula.'));
          }

          final bool showPendingAssessmentMessage = _userController.user.value!.isStudent &&
              (classModel.hasAssessment ?? false) &&
              _controller.assessmentCompl.value?.status == AssessmentCompletionStatusEnum.waitingCorrection;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Insets.medium.height,
                      classModel.file != null
                          ? SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: FilePreviewComponent(classModel.file!.toBase()),
                            )
                          : Container(
                              width: double.infinity,
                              height: 300,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported, size: 30.0, color: Colors.grey[600]),
                            ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classModel.name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Insets.small.height,
                            Text(classModel.description, style: secondaryTextStyle(size: 16)),
                            Insets.medium.height,
                            ShowQuill(jsonDelta: classModel.textContent ?? ''),
                            Insets.medium.height,
                            if (classModel.files.isNotEmpty) ...[
                              Text('Arquivos da Aula', style: primaryTextStyle(size: 16, weight: FontWeight.bold)),
                              Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: classModel.files.map((file) {
                                  return FilePreviewComponent(file);
                                }).toList(),
                              ),
                              Insets.medium.height,
                            ],
                            Column(
                              children: [
                                SizedBox(
                                  width: 220,
                                  child: ButtonRectDefault(
                                    label: Row(
                                      children: [
                                        const Icon(Icons.description_outlined, color: Colors.white, size: 22),
                                        Insets.small.width,
                                        Text(
                                          'Download do material',
                                          style: primaryTextStyle(size: 14, color: Colors.white, weight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    borderRadius: 12,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    color: const Color(0xFF084cec),
                                    onPressed: () => _doDownloadFiles(classModel),
                                  ),
                                ),
                                Insets.small.height,
                                if (_userController.user.value!.isStudent)
                                  Obx(() {
                                    final progress = _controller.videoDownloadProgress.value;

                                    if (progress > 0.0 && progress < 1.0) {
                                      return SizedBox(
                                        width: 220,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                'Baixando... (${(progress * 100).toStringAsFixed(0)}%)\n\nSair da tela fará o download ficar incompleto.',
                                                style: secondaryTextStyle(size: 14, color: Color(0xFF084cec)),
                                              ),
                                              Insets.small.height,
                                              LinearProgressIndicator(
                                                value: progress,
                                                minHeight: 8,
                                                borderRadius: BorderRadius.circular(4),
                                                backgroundColor: Colors.grey.shade300,
                                                color: Color(0xFF084cec),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    return SizedBox(
                                      width: 200,
                                      child: ActionButton(
                                        theme: ActionButtonTheme.lightGrey,
                                        title: progress == 1.0 ? 'Aula Baixada' : 'Download da aula',
                                        onPressed: progress == 1.0 ? null : () => _doDownloadClass(classModel),
                                      ),
                                    );
                                  }),
                                if (showPendingAssessmentMessage) ...[
                                  Insets.medium.height,
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.amber.shade200),
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.hourglass_bottom, color: Colors.amber.shade700, size: 20),
                                        Insets.small.width,
                                        Expanded(
                                          child: Text(
                                            'Sua avaliação foi enviada e está aguardando correção. Assim que houver um retorno, você será notificado.',
                                            style: secondaryTextStyle(size: 14, color: Colors.amber.shade900),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_userController.user.value!.isStudent && (_controller.isAssessmentDone.value == false || _controller.isAssessmentReproved))
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Obx(() {
                    final classModel = _controller.classDetails.value;
                    if (classModel == null) return SizedBox.shrink();

                    final hasAssessment = classModel.hasAssessment ?? false;

                    return ActionButton(
                      theme: ActionButtonTheme.blue,
                      title: hasAssessment ? 'Fazer avaliação' : 'Concluir aula',
                      onPressed: () async {
                        if (hasAssessment) {
                          bool? confirmed = await Get.dialog<bool>(
                            AlertDialog(
                              title: const Text('Confirmar'),
                              content: const Text(
                                'Após iniciar uma prova, você não pode retornar para a tela anterior.\n'
                                'Qualquer ação de sair acarretará no cancelamento da mesma.',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Get.back(result: false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Get.back(result: true),
                                  child: const Text('Iniciar Prova'),
                                ),
                              ],
                            ),
                            barrierDismissible: false,
                          );

                          if (confirmed != null && confirmed) {
                            await Get.toNamed('/class_assessment/${classModel.assessment?.id}', arguments: classModel);
                          }
                        } else {
                          var id = Get.find<UserController>().user.value!.id;
                          _controller.completeClass(classModel, id);
                          Get.secureBack();
                        }
                      },
                    );
                  }),
                ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _doDownloadFiles(ClassModel model) async {
    if (model.files.isEmpty) {
      Get.snackbar('Aviso', 'Não há arquivos para download.');
      return;
    }

    await _controller.doDownloadFiles(model);
  }

  Future<void> _doDownloadClass(ClassModel model) async {
    await _controller.doDownloadClass(model);
  }
}
