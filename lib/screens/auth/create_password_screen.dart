import 'package:unisinos_usp_app/widgets/auth_form_viewport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CreatePasswordScreen extends StatelessWidget {
  final UserController _controller = Get.find<UserController>();

  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final String token = Get.arguments is String ? Get.arguments as String : '';
  final _formKey = GlobalKey<FormState>();

  CreatePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthFormViewport(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Crie uma nova senha',
                style: boldTextStyle(size: 22, color: Colors.white),
              ),
              Insets.small.height,
              Text('Acesse a plataforma', style: secondaryTextStyle(size: 14)),
              Insets.extraLarge.height,
              InputText(
                hintText: 'Crie uma nova senha',
                controller: _passwordTextController,
                obscureText: true,
                validator: (string) {
                  if (string == null || string.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
              ),
              Insets.large.height,
              InputText(
                hintText: 'Confirme a senha',
                controller: _confirmPasswordTextController,
                obscureText: true,
                validator: (string) {
                  if (string == null || string.isEmpty) {
                    return 'Obrigatório';
                  }
                  if (string != _passwordTextController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              Insets.extraLarge.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Registrar',
                  onPressed: _doChangePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doChangePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = await _controller.recoverPassword(
          token,
          _passwordTextController.text,
        );

        await _controller.savePrefs(user);
        Get.offAllNamed(_controller.modeHome);
      } catch (_) {
        /* Error presented by the controller. */
      }
    }
  }
}
