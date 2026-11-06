import 'package:unisinos_usp_app/widgets/app_page_viewport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/models/ai_assistant_screen_context.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  static const Set<String> _regularUserMenuTitles = {
    'Mapa de Pistas',
    'Problemáticas',
    'Agentes',
    'Central de Gestão',
    'Pistas',
  };

  final UserController _controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    Get.find<AiAssistantContextService>().registerProvider(
      Get.currentRoute,
      _buildAiContext,
    );

    final user = _controller.user.value;
    final categoryPolicy = CategoryPolicy(user);
    final livingCluePolicy = LivingCluePolicy(user);
    final clueConnectionPolicy = ClueConnectionPolicy(user);
    final connectionTypePolicy = ConnectionTypePolicy(user);
    final nodePolicy = NodePolicy(user);
    final nodeTypePolicy = NodeTypePolicy(user);
    final chatTemplatePolicy = ChatTemplatePolicy(user);
    final userPolicy = UserPolicy(user);

    final menus =
        <_HomeMenu>[
          _HomeMenu(
            title: 'Categorias',
            subtitle: 'Organize categorias e temas',
            icon: Icons.category_rounded,
            color: const Color(0xFF29B6F6),
            onTap: () => Get.toNamed('/categories'),
            isVisible: categoryPolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Pistas',
            subtitle: 'Lista e gestão de pistas',
            icon: Icons.radar_rounded,
            color: const Color(0xFF3CE4C8),
            onTap: () => Get.toNamed('/living_clues'),
            isVisible: livingCluePolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Mapa de Pistas',
            subtitle: 'Visualização territorial',
            icon: Icons.map_rounded,
            color: const Color(0xFFFFB74D),
            onTap: () => Get.toNamed('/living_clues/map'),
            isVisible: livingCluePolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Central de Gestão',
            subtitle: 'Relações e parametrizações',
            icon: Icons.hub_rounded,
            color: const Color(0xFFEF6EB0),
            onTap: () => Get.toNamed('/management'),
            isVisible: clueConnectionPolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Tipos de conexão',
            subtitle: 'Cadastre e edite tipos',
            icon: Icons.link_rounded,
            color: const Color(0xFF7D8BFF),
            onTap: () => Get.toNamed('/connection_types'),
            isVisible: connectionTypePolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Problemáticas',
            subtitle: 'Visualização estilo grafo',
            icon: Icons.account_tree_rounded,
            color: const Color(0xFFFF8A65),
            onTap: () => Get.toNamed('/nodes/graph'),
            isVisible: nodePolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Tipos de problemática',
            subtitle: 'Taxonomias de análise',
            icon: Icons.label_rounded,
            color: const Color(0xFFF3C45F),
            onTap: () => Get.toNamed('/node_types'),
            isVisible: nodeTypePolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Agentes',
            subtitle: 'Agentes de IA e suas conversas',
            icon: Icons.psychology_alt_rounded,
            color: const Color(0xFF56D5FF),
            onTap: () => Get.toNamed('/chat_templates'),
            isVisible: chatTemplatePolicy.viewAny(),
          ),
          _HomeMenu(
            title: 'Usuários',
            subtitle: 'Cadastro e gestão de acesso',
            icon: Icons.groups_rounded,
            color: const Color(0xFF78E08F),
            onTap: () => Get.toNamed('/users'),
            isVisible: userPolicy.viewAny(),
          ),
        ].where((menu) {
          if (!menu.isVisible) return false;
          if (user?.isAdmin ?? false) return true;
          return _regularUserMenuTitles.contains(menu.title);
        }).toList();

    final userName = _controller.user.value?.name.trim();
    final displayName = (userName == null || userName.isEmpty)
        ? 'Usuário'
        : userName;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _HomeTopBar(
                  userName: displayName,
                  onProfileTap: () => Get.toNamed('/profile'),
                  onLogout: _controller.logout,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: AppPageViewport.maxWidth,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const _SpaceEntry(),
                            const SizedBox(height: 24),
                            const _SectionTitle(
                              title: 'Módulos',
                              subtitle: 'Acessos da plataforma',
                            ),
                            const SizedBox(height: 10),
                            _ResponsiveMenuFlow(menus: menus),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AiAssistantScreenContext _buildAiContext() {
    return AiAssistantScreenContext(
      screenName: 'Home',
      route: Get.currentRoute,
      stage: 'navegação principal',
      goal: 'acessar uma das áreas principais do sistema',
      visibleFields: const <String>[
        'biomas',
        'territórios',
        'categorias',
        'pistas',
        'mapa de pistas',
        'tipos de conexão',
        'conexões',
        'agentes',
        'tipos de problemática',
        'problemáticas',
        'usuários',
      ],
      filledFields: <String, String>{
        'usuário': _controller.user.value?.name ?? 'não identificado',
      },
      notes: const <String>[
        'A tela inicial funciona como atalho para os módulos principais.',
      ],
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
    this.isVisible = true,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isVisible;
}

class _HomeTopBar extends StatelessWidget {
  const _HomeTopBar({
    required this.userName,
    required this.onProfileTap,
    required this.onLogout,
  });

  final String userName;
  final VoidCallback onProfileTap;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final title = Text(
          'Educação OnLIFE',
          maxLines: compact ? 2 : 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFD6E7FF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );

        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProfilePill(userName: userName, onTap: onProfileTap),
            const SizedBox(width: 10),
            FilledButton.tonalIcon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Sair'),
              style: FilledButton.styleFrom(
                foregroundColor: const Color(0xFFFFB49B),
                backgroundColor: const Color(0x2CE6512D),
                side: const BorderSide(color: Color(0x40FF7F5B)),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
          child: compact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [Expanded(child: title)]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: actions,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: 12),
                    actions,
                  ],
                ),
        );
      },
    );
  }
}

class _ProfilePill extends StatelessWidget {
  const _ProfilePill({required this.userName, required this.onTap});

  final String userName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = userName.isEmpty
        ? '?'
        : userName.substring(0, 1).toUpperCase();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 220),
          decoration: BoxDecoration(
            color: const Color(0x500C2B56),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0x3A4CC1F2)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF1C7FCC),
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFC8DBFA),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE7F0FF),
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF91AED7), fontSize: 16),
        ),
      ],
    );
  }
}

class _ResponsiveMenuFlow extends StatelessWidget {
  const _ResponsiveMenuFlow({required this.menus});

  final List<_HomeMenu> menus;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final width = constraints.maxWidth;
        final cardWidth = _resolveCardWidth(width, spacing);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: menus
              .map(
                (menu) => SizedBox(
                  width: cardWidth,
                  child: _ModuleCard(menu: menu),
                ),
              )
              .toList(),
        );
      },
    );
  }

  double _resolveCardWidth(double availableWidth, double spacing) {
    return availableWidth < 700
        ? availableWidth
        : (availableWidth - spacing) / 2;
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.menu});

  final _HomeMenu menu;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: menu.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xB50A1C3D), Color(0xA9061430)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x8A46B6EC), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF020814).withValues(alpha: 0.45),
              blurRadius: 8,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: menu.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: menu.color.withValues(alpha: 0.45)),
                ),
                child: Icon(menu.icon, color: menu.color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menu.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menu.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFA4C0E6),
                        fontSize: 15,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xFF66CFFF),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpaceEntry extends StatelessWidget {
  const _SpaceEntry();
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Experiência espacial: entrar na nave Educação OnLIFE',
    button: true,
    child: Material(
      color: const Color(0xFF0C2333),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed('/space'),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF123E49), Color(0xFF10192E)],
            ),
            border: Border.all(color: const Color(0xFF34636D)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.rocket_launch_outlined,
                color: Color(0xFF8DF5DC),
                size: 42,
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UMA NOVA PERSPECTIVA',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        color: Color(0xFF8DF5DC),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Entre na nave Educação OnLIFE',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Explore os destinos da Educação OnLIFE com a IAraeté, sua parceira epistêmica.',
                      style: TextStyle(color: Color(0xFFB8CDD6)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, color: Color(0xFF8DF5DC)),
            ],
          ),
        ),
      ),
    ),
  );
}
