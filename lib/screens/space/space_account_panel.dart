import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

class SpaceAccountPanel extends StatelessWidget {
  const SpaceAccountPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user.value;
    return Theme(
      data: spaceRecordTheme(),
      child: Material(
        color: const Color(0xFF0A1C2A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('Conta', style: TextStyle(fontSize: 26)),
                    ),
                    IconButton(
                      tooltip: 'Fechar conta',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  user?.name ?? '',
                  style: const TextStyle(color: Color(0xFF9CE7DF)),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.explore_outlined),
                  title: Text(
                    'Modo ${user?.usageMode == 'inventor' ? 'Inventor' : 'Explorador'}',
                  ),
                  subtitle: const Text('Usar seletor no console de bordo'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pop(context, 'mode'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout),
                  title: const Text('Sair da conta'),
                  onTap: () => Navigator.pop(context, 'logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
