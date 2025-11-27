import 'dart:math' as math;

import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/widgets/profile_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/button_rect_default.dart';

class ProfileScreen extends StatelessWidget {
  final UserController _controller = Get.find<UserController>();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Perfil',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    UserModel? userModel = _controller.user.value;
                    return ProfileImage(profilePicture: userModel?.profilePicture);
                  }),
                  Insets.medium.width,
                  Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_controller.user.value?.name ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Insets.small.height,
                        Text(_controller.user.value?.email ?? '', style: secondaryTextStyle(size: 14)),
                        Insets.medium.height,
                        SizedBox(
                          width: 120,
                          child: ButtonRectDefault(
                            label: Text(
                              'Editar Perfil',
                              style: primaryTextStyle(
                                size: 12,
                                color: Colors.black,
                                weight: FontWeight.w500,
                              ),
                            ),
                            height: 35,
                            color: Colors.white,
                            borderColor: const Color(0xFFf2f2f2),
                            onPressed: () => Get.toNamed('/user_editor/${_controller.user.value!.id}', arguments: _controller.user.value),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Insets.extraLarge.height,
              tile(CupertinoIcons.bell, 'Notificações', () => Get.toNamed('/notifications')),
              Divider(height: 1, color: Colors.black.withOpacity(0.1)),
              tile(CupertinoIcons.chat_bubble_text, 'Ajuda', () => Get.toNamed('/help')),
              Divider(height: 1, color: Colors.black.withOpacity(0.1)),
              tile(CupertinoIcons.info, 'Sobre', () => Get.toNamed('/about')),
              Divider(height: 1, color: Colors.black.withOpacity(0.1)),
              tile(Icons.settings_outlined, 'Preferências', () => Get.toNamed('/preferences')),
              Insets.extraLarge.height,
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse('https://api.efv.spotec.app/api/policy/delete_user_data'));
                  },
                  child: Text('Política de Exclusão de Dados', style: TextStyle(color: Colors.black)),
                ),
              ),
              Divider(height: 1, color: Colors.black.withOpacity(0.1)),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () async {
                    await launchUrl(Uri.parse('https://api.efv.spotec.app/api/policy/privacy'));
                  },
                  child: Text('Política de Privacidade', style: TextStyle(color: Colors.black)),
                ),
              ),
              Insets.extraLarge.height,
              ListTile(
                leading: Transform.rotate(
                  angle: math.pi,
                  child: Icon(CupertinoIcons.square_arrow_left, size: 22, color: Colors.red),
                ),
                title: Text('Sair', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                onTap: () => _controller.logout(),
              ),
              ListTile(
                leading: Icon(Icons.delete_forever, size: 22, color: Colors.red),
                title: Text('Excluir Conta', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                onTap: deleteAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile tile(IconData icon, String title, Function() onClick) {
    return ListTile(
      onTap: onClick,
      leading: Icon(
        icon,
        size: 24,
        color: Color(0xff838485),
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Future<void> deleteAccount() async {
    Get.defaultDialog(
        title: 'Confirmar Exclusão',
        titleStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        middleText: 'Tem certeza que deseja excluir sua conta? Esta ação é irreversível e removerá todos os seus dados.',
        middleTextStyle: TextStyle(fontSize: 14),
        textCancel: 'Cancelar',
        cancelTextColor: Colors.black,
        textConfirm: 'Excluir',
        confirmTextColor: Colors.white,
        buttonColor: Colors.red,
        onConfirm: () {
          Get.back();
          _controller.delete();
        },
        onCancel: () {
          Get.back();
        });
  }
}
