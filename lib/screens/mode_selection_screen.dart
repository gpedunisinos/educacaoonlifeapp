import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';

class ModeSelectionScreen extends StatefulWidget {
  const ModeSelectionScreen({super.key});
  @override
  State<ModeSelectionScreen> createState() => _ModeSelectionScreenState();
}

class _ModeSelectionScreenState extends State<ModeSelectionScreen> {
  bool busy = false;
  String? error;
  Future<void> choose(String mode) async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await Get.find<UserController>().chooseMode(mode);
    } catch (_) {
      if (mounted) {
        setState(() {
          error = 'Não foi possível salvar sua escolha. Tente novamente.';
          busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user.value;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Entre na sua conta para continuar.')),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFF80DFEE),
                        size: 32,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Educação OnLIFE',
                        style: TextStyle(
                          color: Color(0xFF80DFEE),
                          letterSpacing: 0.2,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Como você quer viver\nesta descoberta?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          height: 1.2,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Um universo de pistas, encontros e possibilidades.\nEscolha seu modo. Você pode trocar quando quiser.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFB4BED5),
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 36),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final cards = [
                            card(
                              'explorer',
                              'Explorador',
                              'Siga sua curiosidade',
                              'Explore pistas e conexões, guarde referências no Locker e compartilhe suas descobertas.',
                              Icons.rocket_launch_outlined,
                              const Color(0xFF65DFD2),
                              user.usageMode,
                            ),
                            card(
                              'inventor',
                              'Inventor',
                              'Dê forma às possibilidades',
                              'Crie e organize vivências, conecte materiais e construa novas pistas em colaboração.',
                              Icons.handyman_outlined,
                              const Color(0xFFB5A0FF),
                              user.usageMode,
                            ),
                          ];
                          return constraints.maxWidth < 650
                              ? Column(
                                  children: [
                                    cards[0],
                                    const SizedBox(height: 16),
                                    cards[1],
                                  ],
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: cards[0]),
                                    const SizedBox(width: 22),
                                    Expanded(child: cards[1]),
                                  ],
                                );
                        },
                      ),
                      if (error != null)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            error!,
                            style: const TextStyle(color: Colors.orangeAccent),
                          ),
                        ),
                      const SizedBox(height: 24),
                      const Text(
                        'Sua conta e suas referências acompanham você nos dois modos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF9CAAC4)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget card(
    String mode,
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color accent,
    String? current,
  ) => Material(
    color: const Color(0xFF111A32),
    borderRadius: BorderRadius.circular(26),
    child: InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: busy ? null : () => choose(mode),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: current == mode ? accent : accent.withValues(alpha: .25),
            width: current == mode ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: accent, size: 34),
                ),
                const Spacer(),
                if (current == mode)
                  Chip(
                    label: const Text('Modo atual'),
                    avatar: Icon(Icons.check_circle, size: 18, color: accent),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(subtitle, style: TextStyle(color: accent, fontSize: 16)),
            const SizedBox(height: 16),
            Text(
              description,
              style: const TextStyle(color: Color(0xFFB4BED5), height: 1.6),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Text(
                  busy ? 'Salvando…' : 'Entrar como $title',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_rounded, color: accent),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
