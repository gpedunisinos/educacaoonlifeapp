import 'dart:async';

import 'package:unisinos_usp_app/controllers/mfile_controller.dart';
import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/controllers/user_editor_controller.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/utils/user_options.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/widgets/file_selector.dart';
import 'package:widgets_spo/widgets_spo.dart';

class UserEditorScreen extends StatefulWidget {
  const UserEditorScreen({super.key});

  @override
  _UserEditorScreenState createState() => _UserEditorScreenState();
}

class _UserEditorScreenState extends State<UserEditorScreen> {
  final UserEditorController _controller = Get.find<UserEditorController>();
  final MfileController _mFilecontroller = Get.find<MfileController>();

  late MFile? newProfilePicture;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController confirmPasswordTextController = TextEditingController();
  final TextEditingController statusSelectController = TextEditingController();
  final TextEditingController profileSelectController = TextEditingController();

  final ItemSelectMultipleController _trailSelectController = ItemSelectMultipleController();

  final _formKey = GlobalKey<FormState>();

  late final StreamSubscription<UserModel?> _userListener;

  @override
  void initState() {
    super.initState();

    _userListener = _controller.user.listen((_) {
      _updateFields();
    });

    _updateFields();
  }

  void _updateFields() {
    final u = _controller.user.value;

    if (!mounted) return;

    setState(() {
      newProfilePicture = u?.profilePicture;
      nameTextController.text = u?.name ?? '';
      emailTextController.text = u?.email ?? '';
      phoneTextController.text = u?.phone ?? '';
      _trailSelectController.selectedItems = [];

      if (u != null) {
        statusSelectController.text = u.status ? '1' : '0';
        profileSelectController.text = u.profileType!.value.toString();
        _trailSelectController.selectedItems =
            u.userTrails?.map((userTrail) => ItemSelect(id: userTrail.trailId, name: userTrail.trail!.name)).toList();
      }
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    emailTextController.dispose();
    phoneTextController.dispose();
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    statusSelectController.dispose();
    profileSelectController.dispose();
    _userListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _controller.user.value?.id == null;

    return SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Perfil',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Insets.extraLarge.height,
                Row(
                  children: [
                    ProfileImage(profilePicture: newProfilePicture),
                    Insets.medium.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 120,
                          child: ButtonRectDefault(
                            label: Text(
                              'Trocar foto',
                              style: primaryTextStyle(
                                size: 12,
                                color: Colors.black,
                                weight: FontWeight.w500,
                              ),
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
                                  newProfilePicture = MFile.fromBase(files.first);
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Insets.extraLarge.height,
                InputText(
                  hintText: 'Nome',
                  controller: nameTextController,
                  validator: (string) {
                    return PValidator([PRuleRequired(string, message: 'Obrigatório'.tlt)]).val();
                  },
                  keyboardType: TextInputType.text,
                ),
                Insets.medium.height,
                InputText(
                  hintText: 'E-mail',
                  controller: emailTextController,
                  validator: (string) {
                    return PValidator([PRuleRequired(string, message: 'Obrigatório'.tlt)]).val();
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                Insets.medium.height,
                InputText(
                  hintText: 'Telefone',
                  controller: phoneTextController,
                  validator: (string) {
                    return PValidator([PRuleRequired(string, message: 'Obrigatório'.tlt)]).val();
                  },
                  keyboardType: TextInputType.phone,
                ),
                if (isNew) ...[
                  Insets.medium.height,
                  InputText(
                    hintText: 'Senha',
                    controller: passwordTextController,
                    obscureText: true,
                    validator: (string) => PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val(),
                  ),
                  Insets.medium.height,
                  InputText(
                    hintText: 'Confirmar senha',
                    controller: confirmPasswordTextController,
                    obscureText: true,
                    validator: (string) {
                      if (string != passwordTextController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                ],
                Insets.medium.height,
                InputSelect(
                  controller: statusSelectController,
                  label: 'Status',
                  enable: Get.find<UserController>().user.value!.isAdmin,
                  itens: UserOptions.statusOptions,
                ),
                Insets.medium.height,
                InputSelect(
                  controller: profileSelectController,
                  label: 'Perfil',
                  enable: Get.find<UserController>().user.value!.isAdmin,
                  itens: {
                    for (var type in ProfileTypeEnum.values) type.value.toString(): type.description,
                  },
                ),
                Insets.medium.height,
                InputSelectApiMultiple(
                  label: 'Trilhas do Usuário',
                  controller: _trailSelectController,
                  enable: Get.find<UserController>().user.value!.isAdmin && (_controller.user.value != null && !_controller.user.value!.isAdmin),
                  onFind: TrailWebclient().select,
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
                if (!isNew) ...[
                  Insets.medium.height,
                  SizedBox(
                    width: double.infinity,
                    child: ActionButton(
                      theme: ActionButtonTheme.grey,
                      title: 'Alterar senha',
                      onPressed: () => Get.toNamed('/profile_password_change'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doSave() async {
    if (_formKey.currentState!.validate()) {
      final isNew = _controller.user.value?.id == null;
      final UserModel currentUser;

      if (isNew) {
        currentUser = UserModel(
          id: 0,
          name: nameTextController.text,
          email: emailTextController.text,
          password: passwordTextController.text,
          profileType: ProfileTypeEnum.fromValue(int.parse(profileSelectController.text)),
        );
      } else {
        currentUser = _controller.user.value!;
      }

      int? fileId = currentUser.profilePictureId;
      if (newProfilePicture != null) {
        fileId = await _mFilecontroller.changePictureFile(
          currentUser.profilePicture,
          newProfilePicture!,
        );
      }

      final updatedUser = currentUser.copyWith(
        name: nameTextController.text,
        email: emailTextController.text,
        phone: phoneTextController.text,
        profilePictureId: fileId,
        profileType: ProfileTypeEnum.fromValue(int.parse(profileSelectController.text)),
        status: statusSelectController.text == '1',
        password: isNew ? passwordTextController.text : null,
      );

      final trailIds = _trailSelectController.selectedItems?.map((t) => t.id).toList();

      if (await _controller.saveUser(updatedUser, trailIds)) {
        Get.secureBack();
      }
    }
  }
}
