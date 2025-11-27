import 'dart:async';

import 'package:unisinos_usp_app/controllers/mfile_controller.dart';
import 'package:unisinos_usp_app/controllers/user_editor_controller.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/custom_switch.dart';
import 'package:unisinos_usp_app/widgets/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/button_rect_default.dart';
import 'package:widgets_spo/widgets/file_selector.dart';
import 'package:widgets_spo/widgets/input_text.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final UserEditorController _controller = Get.find<UserEditorController>();
  final MfileController _mFilecontroller = Get.find<MfileController>();

  late MFile? profilePicture;
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController phoneTextController = TextEditingController();

  final RxBool receiveNotifications = true.obs;
  final RxBool newCourses = false.obs;
  final RxBool classReminders = false.obs;
  final RxBool platformUpdates = false.obs;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _updateFields();
  }

  void _updateFields() {
    setState(() {
      profilePicture = _controller.user.value?.profilePicture;
      nameTextController.text = _controller.user.value?.name ?? '';
      emailTextController.text = _controller.user.value?.email ?? '';
      phoneTextController.text = _controller.user.value?.phone ?? '';

      newCourses.value = _controller.user.value?.sendTrailNotification ?? true;
      classReminders.value = _controller.user.value?.sendClassNotification ?? true;
      platformUpdates.value = _controller.user.value?.sendPlatformNotification ?? true;
    });
  }

  @override
  void dispose() {
    nameTextController.dispose();
    emailTextController.dispose();
    phoneTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    ProfileImage(profilePicture: profilePicture),
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
                                  profilePicture = MFile.fromBase(files.first);
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
                Insets.medium.height,
                _buildNotificationOption(
                  'Novos cursos',
                  newCourses.value,
                  (val) => newCourses.value = val,
                ),
                Insets.medium.height,
                _buildNotificationOption(
                  'Lembretes de aulas',
                  classReminders.value,
                  (val) => classReminders.value = val,
                ),
                Insets.medium.height,
                _buildNotificationOption(
                  'Atualizações da Plataforma',
                  platformUpdates.value,
                  (val) => platformUpdates.value = val,
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
            ),
          ),
        ),
      ),
    );
  }

  Future<void> doSave() async {
    if (_formKey.currentState!.validate()) {
      var userModel = _controller.user.value!;

      int? fileId = userModel.profilePictureId;
      if (profilePicture != null) {
        fileId = await _mFilecontroller.changePictureFile(userModel.profilePicture, profilePicture!);
      }

      final updatedUser = _controller.user.value!.copyWith(
        name: nameTextController.text,
        profilePictureId: fileId,
        email: emailTextController.text,
        phone: phoneTextController.text,
        sendTrailNotification: newCourses.value,
        sendClassNotification: classReminders.value,
        sendPlatformNotification: platformUpdates.value,
      );

      await _controller.updateUser(updatedUser);
    }
  }
}

Widget _buildNotificationOption(String title, bool value, ValueChanged<bool> onChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title),
      CustomSwitch(
        value: value,
        onChanged: onChanged,
      ),
    ],
  );
}
