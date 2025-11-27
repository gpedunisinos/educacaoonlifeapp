import 'dart:async';

import 'package:unisinos_usp_app/controllers/mfile_controller.dart';
import 'package:unisinos_usp_app/controllers/trail_editor_controller.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/utils/trail_options.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/custom_switch.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';
import 'package:widgets_spo/widgets/file_selector.dart';

class TrailEditorScreen extends StatefulWidget {
  const TrailEditorScreen({super.key});

  @override
  State<TrailEditorScreen> createState() => _TrailEditorScreenState();
}

class _TrailEditorScreenState extends State<TrailEditorScreen> {
  final TrailEditorController _controller = Get.find<TrailEditorController>();
  final MfileController _mFilecontroller = Get.find<MfileController>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _descriptionTextController = TextEditingController();
  final TextEditingController _timeLimitTextController = TextEditingController();

  late final TextEditingController _timeOptionsController;

  MFile? _coverImage;
  bool _status = true;

  final ItemSelectController _categorySelectController = ItemSelectController();
  final ItemSelectController _teacherSelectController = ItemSelectController();

  @override
  void initState() {
    super.initState();
    final t = _controller.trail.value;
    _timeOptionsController = TextEditingController(text: t?.expirationTime ?? '');
    _updateFields();
  }

  void _updateFields() {
    final t = _controller.trail.value;

    setState(() {
      _coverImage = t?.coverImageFile;
      _nameTextController.text = t?.name ?? '';
      _descriptionTextController.text = t?.description ?? '';
      _status = t?.status ?? true;
      _categorySelectController.selectedItem = ItemSelect(id: t?.category?.id ?? 0, name: t?.category?.name ?? '');
      _teacherSelectController.selectedItem = ItemSelect(id: t?.teacher?.id ?? 0, name: t?.teacher?.name ?? '');
    });
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _descriptionTextController.dispose();
    _timeLimitTextController.dispose();
    _timeOptionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _controller.trail.value?.id == null;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: Text(
            isNew ? 'Cadastrar Trilha' : 'Editar Trilha',
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
                Insets.large.height,
                ImageWidget(
                  image: _coverImage,
                  width: double.infinity,
                  height: 180,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 120,
                    child: ButtonRectDefault(
                      label: Text(
                        'Trocar capa',
                        style: primaryTextStyle(size: 12, color: Colors.black, weight: FontWeight.w500),
                      ),
                      height: 35,
                      color: Colors.white,
                      borderColor: const Color(0xFFf2f2f2),
                      onPressed: () async {
                        final files = await FileSelector.pickFiles(
                          context: context,
                          type: FileSelectorType.image,
                        );
                        if (files.isNotEmpty) {
                          setState(() {
                            _coverImage = MFile.fromBase(files.first);
                          });
                        }
                      },
                    ),
                  ),
                ),
                Insets.large.height,
                InputText(
                  hintText: 'Nome da Trilha',
                  controller: _nameTextController,
                  validator: (string) => PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val(),
                  keyboardType: TextInputType.name,
                ),
                Insets.medium.height,
                InputText(
                  hintText: 'Descrição completa',
                  controller: _descriptionTextController,
                  maxLines: 6,
                  validator: (string) => PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val(),
                ),
                Insets.medium.height,
                InputSelectApi(
                  controller: this._categorySelectController,
                  label: 'Categoria'.tlt,
                  validator: (string) {
                    return PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val();
                  },
                  onFind: CategoryWebclient().select,
                  onChanged: (selectedId) {
                    if (selectedId != null) {
                      _categorySelectController.selectedItem!.id = selectedId;
                    }
                  },
                ),
                Insets.medium.height,
                InputSelect(
                  label: 'Tempo limite',
                  controller: _timeOptionsController,
                  itens: TrailOptions.trailTimeOptions,
                ),
                Insets.medium.height,
                InputSelectApi(
                  controller: _teacherSelectController,
                  label: 'Professor responsável',
                  validator: (string) => PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val(),
                  onFind: (text, offset, params) async {
                    return UserWebclient().select(text, offset, {'profile': ProfileTypeEnum.teacher.value.toString()});
                  },
                  onChanged: (selectedId) {
                    if (selectedId != null) {
                      _teacherSelectController.selectedItem!.id = selectedId;
                    }
                  },
                ),
                Insets.medium.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ativo'),
                    CustomSwitch(
                      value: _status,
                      onChanged: (val) => setState(() => _status = val),
                    ),
                  ],
                ),
                Insets.large.height,
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    theme: ActionButtonTheme.blue,
                    title: 'Salvar',
                    onPressed: doSave,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doSave() async {
    if (_formKey.currentState!.validate()) {
      final currentTrail = _controller.trail.value ??
          TrailModel(
            id: 0,
            name: _nameTextController.text,
            description: _descriptionTextController.text,
            teacherId: _teacherSelectController.selectedItem!.id,
          );

      int? fileId = currentTrail.coverImageFileId;
      if (_coverImage != null) {
        fileId = await _mFilecontroller.changePictureFile(
          currentTrail.coverImageFile,
          _coverImage!,
        );
      }

      final updatedTrail = currentTrail.copyWith(
        name: _nameTextController.text,
        description: _descriptionTextController.text,
        categoryId: _categorySelectController.selectedItem!.id,
        coverImageFileId: fileId,
        status: _status,
        expirationTime: _timeOptionsController.text,
        teacherId: _teacherSelectController.selectedItem!.id,
      );

      bool success = await _controller.saveTrail(updatedTrail);

      if (success) {
        Get.secureBack();
      }
    }
  }
}
