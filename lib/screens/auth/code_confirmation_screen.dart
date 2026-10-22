import 'package:unisinos_usp_app/widgets/auth_form_viewport.dart';
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
    return Scaffold(
      body: AuthFormViewport(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Verifique o código',
                style: boldTextStyle(size: 22, color: Colors.white),
              ),
              Insets.small.height,
              Text(
                'Digite o código que foi enviado para seu e-mail e\nconclua a verificação da sua conta',
                textAlign: TextAlign.center,
                style: secondaryTextStyle(size: 14),
              ),
              Insets.extraLarge.height,
              PinCodeTextField(
                autoDisposeControllers: false,
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
              Text(
                'Um código foi enviado para seu e-mail',
                style: secondaryTextStyle(size: 14),
              ),
              Insets.small.height,
              Obx(() {
                if (_timeout.value > 0) {
                  return Text(
                    'Reenviar em 00:${_timeout.value}',
                    style: boldTextStyle(
                      size: 14,
                      color: const Color(0xFFA6C5EF),
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      _startTimer();
                      _pinController.text = '';
                      try {
                        await _controller.sendCode(email);
                      } catch (_) {}
                    },
                    child: Text(
                      'Reenviar código',
                      style: boldTextStyle(
                        size: 14,
                      ).copyWith(color: Color(0xFF084cec)),
                    ),
                  );
                }
              }),
              Insets.large.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Continuar',
                  onPressed: _doConfirmCode,
                ),
              ),
            ],
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
    try {
      if (_formKey.currentState!.validate() &&
          await _controller.validateRecoverToken(_pinController.text)) {
        Get.toNamed('/create_password', arguments: _pinController.text);
      } else {
        Get.snackbar('Erro', 'Código inválido');
      }
    } catch (_) {
      /* Error presented by the controller. */
    }
  }
}
