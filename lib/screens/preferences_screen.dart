import 'package:unisinos_usp_app/controllers/controllers.dart';
import 'package:unisinos_usp_app/widgets/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class PreferencesScreen extends StatelessWidget {
  final UserController _controller = Get.find<UserController>();

  PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Preferências',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await _controller.updatePreferences();
              Get.secureBack();
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() {
            final user = _controller.user.value!;

            final allEnabled =
                (user.sendTrailNotification ?? false) && (user.sendPlatformNotification ?? false) && (user.sendClassNotification ?? false);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Insets.extraLarge.height,
                const Text(
                  'Notificações',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text('Gerenciar notificações via push e por e-mail.'),
                Insets.large.height,
                _buildNotificationOption(
                  'Receber Notificações',
                  allEnabled,
                  (val) {
                    _controller.user.update((u) {
                      u?.sendTrailNotification = val;
                      u?.sendPlatformNotification = val;
                      u?.sendClassNotification = val;
                    });
                    _controller.user.refresh();
                  },
                ),
                Insets.medium.height,
                Obx(
                  () => _buildNotificationOption(
                    'Novos cursos',
                    _controller.user.value!.sendTrailNotification ?? false,
                    (val) {
                      _controller.user.update((u) {
                        u?.sendTrailNotification = val;
                      });
                    },
                  ),
                ),
                Insets.medium.height,
                _buildNotificationOption(
                  'Lembretes de aulas',
                  user.sendClassNotification ?? false,
                  (val) {
                    _controller.user.update((u) {
                      u?.sendClassNotification = val;
                    });
                  },
                ),
                Insets.medium.height,
                _buildNotificationOption(
                  'Atualizações da Plataforma',
                  user.sendPlatformNotification ?? false,
                  (val) {
                    _controller.user.update((u) {
                      u?.sendPlatformNotification = val;
                    });
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildNotificationOption(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        CustomSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
