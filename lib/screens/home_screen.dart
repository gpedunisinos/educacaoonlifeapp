import 'dart:math' as math;

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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 900;
    final userName = _controller.user.value?.name ?? 'Bem-vindo';
    final backgroundImageWidth = isMobile ? screenWidth : 900.0;

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
      _HomeMenu(
        title: 'Agentes',
        subtitle: 'Agentes de IA',
        icon: Icons.forum_outlined,
        color: Colors.cyan.shade700,
        onTap: () => Get.toNamed('/chat_templates'),
      ),
      _HomeMenu(
        title: 'Tipos de nó',
        subtitle: 'Cadastre taxonomias',
        icon: Icons.label_outline,
        color: Colors.amber.shade700,
        onTap: () => Get.toNamed('/node_types'),
      ),
      _HomeMenu(
        title: 'Problemáticas',
        subtitle: 'Visualização estilo Onodo',
        icon: Icons.account_tree_outlined,
        color: Colors.deepOrange.shade600,
        onTap: () => Get.toNamed('/nodes/graph'),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
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
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(
            child: CustomPaint(
              painter: _StarfieldPainter(),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/rieonlife/hub_conectakat.jpeg',
                width: backgroundImageWidth,
                fit: BoxFit.contain,
                alignment: Alignment.topRight,
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
                    color: Colors.black.withValues(alpha: 0.62),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                            child: Text(
                              userName.isNotEmpty ? userName.characters.first.toUpperCase() : '?',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Insets.medium.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Selecione uma área para começar',
                                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isMobile)
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: menuItems
                          .map(
                            (item) => _HomeCard(menu: item),
                          )
                          .toList(),
                    )
                  else
                    _TwoColumnMenuFlow(menus: menuItems),
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
        color: Colors.black.withValues(alpha: 0.58),
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
                    color: menu.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(menu.icon, color: menu.color, size: 24),
                ),
                const SizedBox(height: 12),
                Text(
                  menu.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  menu.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TwoColumnMenuFlow extends StatelessWidget {
  const _TwoColumnMenuFlow({required this.menus});

  final List<_HomeMenu> menus;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const cardsPerRow = 2;
        const spacing = 16.0;
        const rowSpacing = 16.0;
        final totalRows = (menus.length / cardsPerRow).ceil();

        final rows = List<Widget>.generate(totalRows, (rowIndex) {
          final start = rowIndex * cardsPerRow;
          final rowMenus = menus.skip(start).take(cardsPerRow).toList();

          return SizedBox(
            width: constraints.maxWidth,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: rowIndex < totalRows - 1 ? rowSpacing : 0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: rowMenus
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: EdgeInsets.only(right: entry.key < rowMenus.length - 1 ? spacing : 0),
                          child: _HomeCard(menu: entry.value),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  const _StarfieldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, bgPaint);

    final starPaint = Paint()..style = PaintingStyle.fill;
    const starCount = 220;

    for (var i = 0; i < starCount; i++) {
      final xFactor = (math.sin(i * 12.9898) * 43758.5453).abs() % 1;
      final yFactor = (math.sin(i * 78.233) * 12345.6789).abs() % 1;
      final radiusFactor = (math.sin(i * 3.117) * 9631.417).abs() % 1;
      final alphaFactor = (math.sin(i * 5.173) * 7411.39).abs() % 1;

      final dx = xFactor * size.width;
      final dy = yFactor * size.height;
      final radius = 0.6 + (radiusFactor * 1.8);
      final alpha = 0.4 + (alphaFactor * 0.6);

      starPaint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
