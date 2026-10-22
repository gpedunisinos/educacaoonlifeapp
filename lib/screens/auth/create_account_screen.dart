import 'package:unisinos_usp_app/widgets/auth_form_viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CreateAccountScreen extends StatelessWidget {
  final UserController _controller = Get.find<UserController>();
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _mailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  final RxBool isAcceptedTerms = false.obs;

  final _formKey = GlobalKey<FormState>();

  CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      body: AuthFormViewport(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cadastre-se para se\njuntar a nós',
                textAlign: TextAlign.center,
                style: boldTextStyle(size: 22),
              ),
              Insets.large.height,
              InputText(
                hintText: 'Digite seu nome',
                controller: _nameTextController,
                validator: (string) {
                  if (string == null || string.isEmpty) {
                    return 'Obrigatório';
                  }
                  return null;
                },
                keyboardType: TextInputType.name,
              ),
              Insets.large.height,
              InputText(
                hintText: 'Digite seu e-mail',
                controller: _mailTextController,
                validator: (string) {
                  if (string == null || string.isEmpty) {
                    return 'Obrigatório';
                  }
                  if (!GetUtils.isEmail(string.trim())) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              Insets.large.height,
              InputText(
                hintText: 'Senha',
                controller: _passwordTextController,
                obscureText: true,
                validator: (string) {
                  if (string == null || string.isEmpty) {
                    return 'Obrigatório';
                  }
                  if (string.trim().length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              Insets.large.height,
              InputText(
                hintText: 'Confirme sua senha',
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
              Insets.large.height,
              Obx(() {
                bool isAccepted = isAcceptedTerms.value;

                return Row(
                  children: [
                    Checkbox(
                      value: isAccepted,
                      fillColor: MaterialStateProperty.all(Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      onChanged: (bool? value) {
                        isAcceptedTerms.value = value!;
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Aceito os termos e condições',
                        style: TextStyle(color: Color(0xFF828282)),
                      ),
                    ),
                  ],
                );
              }),
              Insets.large.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Cadastrar',
                  onPressed: () => _doCreateAccount(context),
                ),
              ),
              Insets.extraLarge.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.white,
                  icon: SvgPicture.asset(
                    'assets/google_icon.svg',
                    width: 20,
                    height: 20,
                  ),
                  title: 'Continuar com Google',
                  onPressed: _doGoogleLogin,
                ),
              ),
              Insets.small.height,
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Já tem uma conta?',
                    style: TextStyle(color: Color(0xFF828282)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.secureBack();
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _doCreateAccount(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (isAcceptedTerms.value) {
        try {
          await LoadingDialog.showFuture(
            context,
            _controller.createAccount(
              name: _nameTextController.text.trim(),
              email: _mailTextController.text.trim(),
              password: _passwordTextController.text,
            ),
          );
        } catch (_) {
          // The controller keeps the form and explains the registration error.
        }
      } else {
        Get.customSnackbar(
          'Aviso',
          'Você deve aceitar os termos e condições para prosseguir.',
        );
      }
    }
  }

  Future<void> _doGoogleLogin() async {
    try {
      await _controller.loginGoogle();
    } catch (_) {
      // The controller already presents the recoverable authentication error.
    }
  }
}
