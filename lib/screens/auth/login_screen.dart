import 'package:unisinos_usp_app/services/clue_links.dart';
import 'package:unisinos_usp_app/widgets/auth_form_viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserController _controller = Get.find<UserController>();

  final TextEditingController _mailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ClueLinks.remember(Get.parameters['returnTo']);
  }

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
                'Seja bem-vindo à plataforma Educação OnLIFE',
                style: boldTextStyle(size: 22, color: Colors.white),
              ),
              Insets.small.height,
              Text(
                'Acesse a plataforma',
                style: secondaryTextStyle(
                  size: 14,
                ).copyWith(color: const Color(0xFFA6C5EF)),
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
              ),
              Insets.large.height,
              InputText(
                hintText: 'Senha',
                controller: _passwordTextController,
                obscureText: true,
                showToggleVisibilityIcon: true,
                validator: (string) {
                  return PValidator([
                    PRuleRequired(string, message: 'Obrigatório'.tlt),
                  ]).val();
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/recover_password');
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: secondaryTextStyle(
                      size: 14,
                    ).copyWith(color: const Color(0xFFA6C5EF)),
                  ),
                ),
              ),
              Insets.large.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Entrar',
                  onPressed: _doLogin,
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
              Insets.medium.height,
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'Não possui uma conta?',
                    style: TextStyle(color: Color(0xFFA6C5EF)),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/create_account');
                    },
                    child: const Text(
                      'Cadastrar',
                      style: TextStyle(
                        color: Color(0xFF7FC9FF),
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

  Future<void> _doLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      await _controller.login(
        _mailTextController.text.trim(),
        _passwordTextController.text,
      );
    } catch (_) {
      /* The controller presents a recoverable authentication error. */
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
