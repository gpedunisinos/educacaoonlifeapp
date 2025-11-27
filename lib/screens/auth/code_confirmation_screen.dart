import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:widgets_spo/widgets_spo.dart';

class CodeConfirmationScreen extends StatefulWidget {
  const CodeConfirmationScreen({super.key});

  @override
  State<CodeConfirmationScreen> createState() => _CodeConfirmationScreenState();
}

class _CodeConfirmationScreenState extends State<CodeConfirmationScreen> {
  final UserController _controller = Get.find<UserController>();
  final TextEditingController _pinController = TextEditingController();
  final String email = Get.parameters['email'] ?? '';
  final _formKey = GlobalKey<FormState>();

  final RxInt _timeout = 59.obs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verifique o código', style: boldTextStyle(size: 22)),
                  Insets.small.height,
                  Text(
                    'Digite o código que foi enviado para seu e-mail e\nconclua a verificação da sua conta',
                    textAlign: TextAlign.center,
                    style: secondaryTextStyle(size: 14),
                  ),
                  Insets.extraLarge.height,
                  PinCodeTextField(
                    appContext: context,
                    length: 5,
                    controller: _pinController,
                    backgroundColor: Colors.white,
                    animationType: AnimationType.scale,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                      borderRadius: BorderRadius.circular(4),
                      fieldHeight: 60,
                      fieldWidth: 50,
                      activeFillColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      selectedFillColor: Colors.transparent,
                      activeColor: Color(0Xffefefef),
                      selectedColor: Color(0xFF084cec),
                      inactiveColor: Color(0Xffefefef),
                    ),
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                  Insets.medium.height,
                  Text('Um código foi enviado para seu e-mail', style: secondaryTextStyle(size: 14)),
                  Insets.small.height,
                  Obx(() {
                    if (_timeout.value > 0) {
                      return Text('Reenviar em 00:${_timeout.value}', style: boldTextStyle(size: 14));
                    } else {
                      return GestureDetector(
                        onTap: () async {
                          _startTimer();
                          _pinController.text = '';
                          await _controller.sendCode(email);
                        },
                        child: Text('Reenviar código', style: boldTextStyle(size: 14).copyWith(color: Color(0xFF084cec))),
                      );
                    }
                  }),
                  Insets.large.height,
                  SizedBox(
                    width: double.infinity,
                    child: ActionButton(
                      theme: ActionButtonTheme.blue,
                      title: 'Continue',
                      onPressed: _doConfirmCode,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _timeout.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeout.value > 0) {
        _timeout.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _doConfirmCode() async {
    if (_formKey.currentState!.validate() && await _controller.validateRecoverToken(_pinController.text)) {
      Get.toNamed('/create_password', arguments: _pinController.text);
    } else {
      Get.snackbar('Erro', 'Código inválido');
    }
  }
}
