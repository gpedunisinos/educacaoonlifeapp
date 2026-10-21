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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 600),
                  height:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Seja bem-vindo à plataforma Educação Onlife',
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
                            title: 'Continue com Google',
                            onPressed: _doGoogleLogin,
                          ),
                        ),
                        Insets.medium.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doLogin() {
    if (_formKey.currentState!.validate()) {
      _controller.login(_mailTextController.text, _passwordTextController.text);
    }
  }

  Future<void> _doGoogleLogin() async {
    await _controller.loginGoogle();
  }
}
