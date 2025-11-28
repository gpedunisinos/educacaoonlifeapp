import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:widgets_spo/widgets_spo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final UserController _controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = _controller.user.value?.name ?? 'Bem-vindo';

    final menuItems = [
      _HomeMenu(
        title: 'Categorias',
        subtitle: 'Organize categorias',
        icon: Icons.category_outlined,
        color: Colors.blue.shade600,
        onTap: () => Get.toNamed('/categories'),
      ),
      _HomeMenu(
        title: 'Pistas vivas',
        subtitle: 'Lista e gestão',
        icon: Icons.radar_outlined,
        color: Colors.teal.shade700,
        onTap: () => Get.toNamed('/living_clues'),
      ),
      _HomeMenu(
        title: 'Mapa de pistas',
        subtitle: 'Visualize no mapa',
        icon: Icons.map_outlined,
        color: Colors.orange.shade700,
        onTap: () => Get.toNamed('/living_clues/map'),
      ),
      _HomeMenu(
        title: 'Tipos de conexão',
        subtitle: 'Cadastre e edite',
        icon: Icons.link_outlined,
        color: Colors.indigo,
        onTap: () => Get.toNamed('/connection_types'),
      ),
      _HomeMenu(
        title: 'Conexões',
        subtitle: 'Relacionar pistas',
        icon: Icons.timeline_outlined,
        color: Colors.pink.shade600,
        onTap: () => Get.toNamed('/clue_connections'),
      ),
      _HomeMenu(
        title: 'Chat',
        subtitle: 'Fale com o assistente',
        icon: Icons.chat_bubble_outline,
        color: Colors.deepPurple.shade500,
        onTap: () => Get.toNamed('/chat'),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _controller.logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Text(
                              userName.isNotEmpty ? userName.characters.first.toUpperCase() : '?',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Insets.medium.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Selecione uma área para começar',
                                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: menuItems
                        .map(
                          (item) => _HomeCard(menu: item),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeMenu {
  _HomeMenu({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _HomeCard extends StatelessWidget {
  const _HomeCard({required this.menu});

  final _HomeMenu menu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 170,
      child: Material(
        color: Colors.white,
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: menu.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: menu.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(menu.icon, color: menu.color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  menu.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  menu.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
