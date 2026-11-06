import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/user/user_update_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/screens/user/user_form.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';

class UserUpdateScreen extends StatelessWidget {
  const UserUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserUpdateController controller = Get.find<UserUpdateController>();
    return ManagementRecordScaffold(
      section: 'users',
      title: 'Editar usuário',
      subtitle: 'Gerencie pessoas e seus perfis de acesso à plataforma.',
      form: true,

      body: Stack(
        children: [
          Obx(() {
            if (controller.userId == null) {
              return const Center(
                child: Text(
                  'Usuário não informado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (controller.isLoading.value && controller.user.value == null) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (controller.user.value == null) {
              return const Center(
                child: Text(
                  'Usuário não encontrado.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: UserForm(
                key: ValueKey<int>(controller.user.value!.id),
                submitLabel: 'Atualizar',
                isLoading: controller.isLoading.value,
                initialValue: controller.user.value,
                onSubmit: (value) async {
                  final UserModel current = controller.user.value!;
                  final bool saved = await controller.save(
                    UserModel(
                      id: current.id,
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
            );
          }),
        ],
      ),
    );
  }
}
