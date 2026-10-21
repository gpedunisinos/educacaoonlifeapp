import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/policies/clue_connection_policy.dart';
import 'package:unisinos_usp_app/screens/management/management_shell.dart';

class ManagementHomeScreen extends StatelessWidget {
  const ManagementHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserController>().user.value;
    final entries = <(IconData, String, String, bool)>[
      if (ClueConnectionPolicy(user).viewAny())
        (
          Icons.hub_outlined,
          'Conexões entre pistas',
          'Consulte relações, tipos e evidências que aproximam os territórios.',
          true,
        ),
      if (user?.isAdmin ?? false) ...[
        (
          Icons.category_outlined,
          'Organização da pesquisa',
          'Categorias e tipos que dão estrutura ao arquivo.',
          false,
        ),
        (
          Icons.psychology_outlined,
          'Inteligências',
          'Parametrização dos agentes, instruções e referências.',
          false,
        ),
        (
          Icons.people_outline,
          'Pessoas',
          'Usuários e perfis de acesso à plataforma.',
          false,
        ),
      ],
    ];
    return ManagementShell(
      title: 'Central de Gestão',
      subtitle:
          'Um espaço para organizar as relações e os parâmetros da plataforma.',
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ÁREAS DE TRABALHO',
                style: TextStyle(
                  color: managementIce,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: entries
                    .map(
                      (entry) => SizedBox(
                        width: box.maxWidth < 650
                            ? box.maxWidth - 44
                            : (box.maxWidth - 60) / 2,
                        child: Material(
                          color: entry.$4
                              ? const Color(0xFF15333B)
                              : const Color(0xFF0D1D2C),
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: entry.$4
                                ? () => Get.toNamed('/management/connections')
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(22),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: entry.$4
                                      ? const Color(0xFF639C9D)
                                      : const Color(0xFF263E4D),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        entry.$1,
                                        color: entry.$4
                                            ? managementIce
                                            : managementMuted,
                                        size: 28,
                                      ),
                                      const Spacer(),
                                      Text(
                                        entry.$4 ? 'DISPONÍVEL' : 'EM BREVE',
                                        style: TextStyle(
                                          color: entry.$4
                                              ? managementIce
                                              : managementMuted,
                                          fontSize: 9,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 22),
                                  Text(
                                    entry.$2,
                                    style: TextStyle(
                                      color: entry.$4
                                          ? Colors.white
                                          : managementMuted,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    entry.$3,
                                    style: const TextStyle(
                                      color: managementMuted,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  if (entry.$4)
                                    const Row(
                                      children: [
                                        Text(
                                          'Abrir conexões',
                                          style: TextStyle(
                                            color: managementIce,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 16,
                                          color: managementIce,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
