import 'package:unisinos_usp_app/widgets/auth_form_viewport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class RecoverPasswordScreen extends StatelessWidget {
  final UserController _controller = Get.find<UserController>();
  final TextEditingController _mailTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  RecoverPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent();
  }

  Widget _buildContent() {
    return Scaffold(
      body: AuthFormViewport(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Confirme seu e-mail',
                style: boldTextStyle(size: 22, color: Colors.white),
              ),
              Insets.small.height,
              Text(
                'Insira o e-mail associado à sua conta e\nenviaremos um e-mail com um código para\nredefinir sua senha',
                textAlign: TextAlign.center,
                style: secondaryTextStyle(size: 14),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Digite seu e-mail',
                controller: _mailTextController,
                validator: (string) {
                  return PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val();
                },
                keyboardType: TextInputType.emailAddress,
              ),
              Insets.extraLarge.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Enviar código',
                  onPressed: _doSendCode,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doSendCode() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (await _controller.sendCode(_mailTextController.text)) {
          Get.toNamed(
            '/code_confirmation',
            parameters: {'email': _mailTextController.text},
          );
        }
      } catch (_) {
        /* Error presented by the controller. */
      }
    }
  }
}
