import 'package:unisinos_usp_app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';

class SpaceAccountPanel extends StatefulWidget {
  const SpaceAccountPanel({super.key});

  @override
  State<SpaceAccountPanel> createState() => _SpaceAccountPanelState();
}

class _SpaceAccountPanelState extends State<SpaceAccountPanel> {
  bool deleting = false;
  String? deletionError;

  Future<void> deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir sua conta?'),
        content: const Text(
          'Esta ação é permanente. Sua conta e os dados associados serão excluídos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir conta'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted || deleting) return;
    setState(() {
      deleting = true;
      deletionError = null;
    });
    try {
      await Get.find<UserController>().deleteOwnAccount();
    } catch (_) {
      if (mounted) {
        setState(
          () => deletionError =
              'Não foi possível excluir sua conta. Tente novamente.',
        );
      }
    } finally {
      if (mounted) setState(() => deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user.value;
    final inventor = user?.usageMode == 'inventor';
    final modeAccent = inventor
        ? AppTheme.inventorAccent
        : const Color(0xFF65DFD2);
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
                      onPressed: deleting ? null : () => Navigator.pop(context),
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
                  leading: Icon(
                    inventor ? Icons.handyman_outlined : Icons.explore_outlined,
                    color: modeAccent,
                  ),
                  title: Text(
                    'Modo ${inventor ? 'Inventor' : 'Explorador'}',
                    style: TextStyle(color: modeAccent),
                  ),
                  subtitle: const Text('Usar seletor no console de bordo'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: deleting ? null : () => Navigator.pop(context, 'mode'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.logout),
                  title: const Text('Sair da conta'),
                  onTap: deleting
                      ? null
                      : () => Navigator.pop(context, 'logout'),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: deleting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.delete_outline,
                          color: Color(0xFFFFB4A7),
                        ),
                  title: const Text(
                    'Excluir minha conta',
                    style: TextStyle(color: Color(0xFFFFB4A7)),
                  ),
                  onTap: deleting ? null : deleteAccount,
                ),
                if (deletionError != null)
                  Text(
                    deletionError!,
                    style: const TextStyle(color: Color(0xFFFFB4A7)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
