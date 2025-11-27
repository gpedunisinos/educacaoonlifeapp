import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_text.dart';

class ProfilePasswordChangeScreen extends StatelessWidget {
  final UserController _controller = Get.find<UserController>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ProfilePasswordChangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Perfil',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Insets.extraLarge.height,
                const Text(
                  'Alterar senha',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60),
                InputText(
                  hintText: 'Senha atual',
                  controller: _currentPasswordController,
                  obscureText: true,
                  validator: (string) {
                    return PValidator([PRuleRequired(string, message: 'Obrigatório'.tlt)]).val();
                  },
                ),
                Insets.medium.height,
                InputText(
                  hintText: 'Nova senha',
                  controller: _newPasswordController,
                  obscureText: true,
                  validator: (string) {
                    return PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val();
                  },
                ),
                Insets.medium.height,
                InputText(
                  hintText: 'Confirmar nova senha',
                  controller: _confirmPasswordController,
                  obscureText: true,
                  validator: (string) {
                    return PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val();
                  },
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          theme: ActionButtonTheme.blue,
                          title: 'Confirmar senha',
                          onPressed: _doChange,
                        ),
                      ),
                      Insets.medium.height,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _doChange() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        Get.snackbar('Erro', 'As senhas não coincidem');
        return;
      }

      UserModel userModel = _controller.user.value!.copyWith(password: _newPasswordController.text);

      _controller.changePassword(_currentPasswordController.text, userModel).then((value) {
        if (value) {
          Get.secureBack();
        }
      });
    }
  }
}
