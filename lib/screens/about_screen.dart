import 'dart:math' as math;

import 'package:unisinos_usp_app/controllers/configuration_controller.dart';
import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_spo/utils.dart';

class AboutScreen extends StatelessWidget {
  final ConfigurationController _controller = Get.find<ConfigurationController>();

  AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Sobre',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Insets.extraLarge.height,
              Text(
                'Sobre',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Insets.medium.height,
              Obx(() {
                return Text(
                  'Versão do Aplicativo: ${_controller.appVersion.value} build: ${_controller.versionCode.value}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              }),
              Insets.medium.height,
              Text('Informações de Contato:'),
              Obx(() {
                final email = _controller.getValueByTag('email_contact');
                final phone = _controller.getValueByTag('phone_contact');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('     Email: $email'),
                    Text('     Telefone: $phone'),
                  ],
                );
              }),
              Spacer(),
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
                title: Text('Sair', style: TextStyle(color: Colors.red)),
                onTap: () => Get.find<UserController>().logout(),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
