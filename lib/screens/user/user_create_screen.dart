import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/user/user_create_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/screens/user/user_form.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';

class UserCreateScreen extends StatelessWidget {
  const UserCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserCreateController controller = Get.find<UserCreateController>();
    return ManagementRecordScaffold(
      section: 'users',
      title: 'Novo usuário',
      subtitle: 'Gerencie pessoas e seus perfis de acesso à plataforma.',
      form: true,

      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => UserForm(
                submitLabel: 'Salvar',
                isLoading: controller.isLoading.value,
                requirePassword: true,
                onSubmit: (value) async {
                  final bool saved = await controller.save(
                    UserModel(
                      id: 0,
                      name: value.name,
                      email: value.email,
                      profile: value.profile,
                      phone: value.phone,
                      password: value.password,
                    ),
                  );

                  if (saved && context.mounted) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
