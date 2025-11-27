import 'dart:convert';

import 'package:unisinos_usp_app/controllers/class_editor_controller.dart';
import 'package:unisinos_usp_app/controllers/mfile_controller.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/input_duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/widgets/file_selector.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClassEditorScreen extends StatefulWidget {
  const ClassEditorScreen({super.key});

  @override
  State<ClassEditorScreen> createState() => _ClassEditorScreenState();
}

class _ClassEditorScreenState extends State<ClassEditorScreen> {
  final ClassEditorController _controller = Get.find<ClassEditorController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController descriptionTextController = TextEditingController();
  final QuillController textContentController = QuillController.basic();
  final ItemSelectController trailSelectController = ItemSelectController();
  final TextEditingController classOrderTextController = TextEditingController();
  int estimatedTimeController = 0;
  final classVideo = Rx<MFile?>(null);
  final TextEditingController videoUrlController = TextEditingController();
  final List<MFileBase> classFiles = [];

  @override
  void initState() {
    super.initState();

    _updateFields();

    _controller.trailItem.listen((_) {
      _updateTrailFields();
    });
  }

  void _updateFields() {
    final c = _controller.classItem.value;

    setState(() {
      nameTextController.text = c?.name ?? '';
      descriptionTextController.text = c?.description ?? '';

      if (c?.textContent != null && c!.textContent!.isNotEmpty) {
        final json = jsonDecode(c.textContent ?? '') as List<dynamic>;
        textContentController.document = Document.fromJson(json);
      } else {
        textContentController.document = Document()..insert(0, '');
      }

      estimatedTimeController = c?.estimatedTime ?? 0;

      classVideo.value = c?.file;

      classFiles.addAll(c?.files.map((file) => MFile.fromBase(file)).toList() ?? []);
    });
  }

  void _updateTrailFields() {
    final c = _controller.classItem.value;
    final t = _controller.trailItem.value;

    final isNew = c?.id == 0 || c?.id == null;

    setState(() {
      if (isNew) {
        final newOrder = (t?.classes?.length ?? 0) + 1;
        classOrderTextController.text = newOrder.toString();
      } else {
        classOrderTextController.text = c?.order.toString() ?? '0';
      }
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    descriptionTextController.dispose();
    textContentController.dispose();
    classOrderTextController.dispose();
    classVideo.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _controller.classItem.value?.id == 0 || _controller.classItem.value?.id == null;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: Text(
            isNew ? 'Cadastrar Aula' : 'Editar Aula',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  if (classVideo.value != null) {
                    return SizedBox(
                      height: 300,
                      child: FilePreviewComponent(
                        classVideo.value!,
                        key: ValueKey(classVideo.value!.hashCode),
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, size: 30.0, color: Colors.grey[600]),
                    );
                  }
                }),
                Insets.medium.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 160,
                    child: ButtonRectDefault(
                      label: Text(
                        '${classVideo.value != null ? 'Alterar' : 'Adicionar'} Vídeo',
                        style: primaryTextStyle(size: 12, color: Colors.black, weight: FontWeight.w500),
                      ),
                      height: 35,
                      color: Colors.white,
                      borderColor: const Color(0xFFf2f2f2),
                      onPressed: _showVideoSourceDialog,
                    ),
                  ),
                ),
                Insets.large.height,
                InputText(
                  hintText: 'Nome da Aula',
                  controller: nameTextController,
                  validator: (string) => PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val(),
                  keyboardType: TextInputType.name,
                ),
                Insets.medium.height,
                InputText(
                  hintText: 'Descrição da Aula',
                  controller: descriptionTextController,
                  validator: (string) => PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val(),
                  keyboardType: TextInputType.text,
                ),
                Insets.medium.height,
                InputQuill(
                  label: 'Conteúdo da Aula',
                  controller: textContentController,
                  validator: (string) {
                    return PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val();
                  },
                ),
                Insets.medium.height,
                Obx(() {
                  var trailModel = _controller.trailItem.value;
                  trailSelectController.selectedItem = ItemSelect(id: trailModel?.id ?? 0, name: trailModel?.name ?? '');

                  return InputSelectApi(
                    label: 'Trilha',
                    controller: trailSelectController,
                    onFind: TrailWebclient().select,
                    onChanged: (selectedId) {
                      if (selectedId != null) {
                        trailSelectController.selectedItem!.id = selectedId;
                        _controller.fetchTrail(selectedId);
                      }
                    },
                    validator: (string) => PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val(),
                  );
                }),
                Insets.medium.height,
                InputText(
                  label: 'Ordem da Aula',
                  controller: classOrderTextController,
                  readOnly: true,
                ),
                Insets.medium.height,
                InputDurationPicker(
                  label: 'Tempo estimado de Aula',
                  initialMinutes: estimatedTimeController,
                  onChanged: (minutes) {
                    estimatedTimeController = minutes;
                  },
                ),
                Insets.medium.height,
                Text('Adicionar Material', style: primaryTextStyle(size: 14)),
                Insets.small.height,
                FileSelector(
                  type: FileSelectorType.pdf,
                  allowMultiple: true,
                  files: classFiles,
                ),
                if (_controller.classItem.value != null && _controller.classItem.value!.id > 0) ...[
                  Insets.extraLarge.height,
                  SizedBox(
                    width: double.infinity,
                    child: ActionButton(
                      theme: ActionButtonTheme.lightGrey,
                      title: 'Gerenciar Prova',
                      onPressed: () async {
                        await Get.toNamed('/assessment_editor/${_controller.classItem.value!.id}', arguments: {'class': _controller.classItem.value});
                        await _controller.fetchById(_controller.classItem.value!.id);
                      },
                    ),
                  ),
                ],
                Insets.large.height,
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    theme: ActionButtonTheme.blue,
                    title: 'Salvar',
                    onPressed: () => doSave(isNew),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVideoSourceDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Selecionar Fonte do Vídeo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Adicionar Link'),
              onTap: () {
                Get.back();
                _showLinkInputDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.folder_open),
              title: Text('Selecionar Arquivo'),
              onTap: () async {
                Get.back();
                await _pickVideoFile();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLinkInputDialog() {
    final TextEditingController urlController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('Adicionar Link do Vídeo'),
        content: InputText(
          hintText: 'Cole o link do YouTube, Vimeo, etc.',
          controller: urlController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                classVideo.value = MFile(
                  name: urlController.text,
                  publicUrl: urlController.text,
                  extension: 'link',
                  id: 0,
                );

                classVideo.refresh();
                Get.back();
              }
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickVideoFile() async {
    final files = await FileSelector.pickFiles(
      context: context,
      type: FileSelectorType.video,
    );

    if (files.isNotEmpty) {
      classVideo.value = MFile.fromBase(files.first, classId: _controller.classItem.value?.id ?? 0);
      classVideo.refresh();
    }
  }

  Future<void> doSave(bool isNew) async {
    if (_formKey.currentState!.validate()) {
      await LoadingDialog.showFuture(
        context,
        () async {
          MfileController mfileController = Get.find<MfileController>();

          // Aula
          ClassModel classToSave;
          if (isNew) {
            int? fileId;
            if (classVideo.value != null) {
              fileId = await mfileController.changeClassFile(
                null,
                classVideo.value!,
              );
            }

            classToSave = ClassModel(
              id: 0,
              name: nameTextController.text,
              description: descriptionTextController.text,
              order: int.tryParse(classOrderTextController.text) ?? 0,
              estimatedTime: estimatedTimeController,
              trailId: trailSelectController.selectedItem?.id,
              textContent: jsonEncode(textContentController.document.toDelta().toJson()),
              fileId: fileId,
            );

            await _controller.saveClass(classToSave);

            // Arquivos
            final existingClass = _controller.classItem.value;

            for (var file in classFiles) {
              var mFile = MFile.fromBase(file);

              await mfileController.addMultipart(
                mFile,
                {'class_id': (existingClass?.id).toString()},
              );
            }
          } else {
            final currentClass = _controller.classItem.value; // class when screen was opened

            // Arquivos
            final filesToDelete = currentClass!.files.where((file) => file.id != 0 && classFiles.every((f) => f.id != file.id)).toList();

            for (var file in filesToDelete) {
              await mfileController.delete(file.id);
            }

            for (var file in classFiles.where((f) => f.id == 0)) {
              var mFile = MFile.fromBase(file);

              await mfileController.addMultipart(
                mFile,
                {'class_id': currentClass.id.toString()},
              );
            }

            int? fileId = currentClass.fileId;
            if (classVideo.value != null) {
              fileId = await mfileController.changeClassFile(
                currentClass.file,
                classVideo.value!,
              );
            }

            classToSave = currentClass.copyWith(
              name: nameTextController.text,
              description: descriptionTextController.text,
              order: int.tryParse(classOrderTextController.text),
              estimatedTime: estimatedTimeController,
              trailId: trailSelectController.selectedItem?.id,
              textContent: jsonEncode(textContentController.document.toDelta().toJson()),
              fileId: fileId,
            );
            await _controller.saveClass(classToSave);
          }
        }(),
        message: 'Concluindo alterações...',
      );

      Get.secureBack();
    }
  }
}
