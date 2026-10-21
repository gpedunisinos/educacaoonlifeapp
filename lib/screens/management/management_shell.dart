import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/policies/clue_connection_policy.dart';

const managementIce = Color(0xFF9CE7DF);
const managementMuted = Color(0xFF9BB4C5);

const managementSections =
    <({String route, String label, String description, IconData icon})>[
      (
        route: 'categories',
        label: 'Categorias',
        description: 'Cores, classificações e marcadores das pistas.',
        icon: Icons.category_outlined,
      ),
      (
        route: 'connection_types',
        label: 'Tipos de conexão',
        description: 'Significados e direção das relações entre pistas.',
        icon: Icons.account_tree_outlined,
      ),
      (
        route: 'node_types',
        label: 'Tipos de problemática',
        description: 'Identificadores e cores das problemáticas.',
        icon: Icons.scatter_plot_outlined,
      ),
      (
        route: 'chat_templates',
        label: 'Agentes de IA',
        description: 'Identidades, instruções e arquivos de referência.',
        icon: Icons.psychology_outlined,
      ),
      (
        route: 'users',
        label: 'Usuários',
        description: 'Pessoas e perfis de acesso à plataforma.',
        icon: Icons.people_outline,
      ),
    ];

bool isManagementRecordRoute(String route) => managementSections.any(
  (entry) =>
      route == '/${entry.route}' ||
      route.startsWith('/${entry.route}/') && route != '/chat_templates/chat',
);

class ManagementShell extends StatelessWidget {
  const ManagementShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.connections = false,
    this.section,
    this.actions = const [],
    this.onBack,
    this.backLabel = 'Central de Gestão',
    this.onRefresh,
    this.status,
  });
  final String title;
  final String subtitle;
  final String backLabel;
  final Widget child;
  final bool connections;
  final String? section;
  final List<Widget> actions;
  final VoidCallback? onBack;
  final VoidCallback? onRefresh;
  final String? status;
  bool get admin =>
      Get.isRegistered<UserController>() &&
      (Get.find<UserController>().user.value?.isAdmin ?? false);
  bool get canConnections =>
      Get.isRegistered<UserController>() &&
      ClueConnectionPolicy(Get.find<UserController>().user.value).viewAny();

  void returnToCockpit() {
    var found = false;
    Get.until((route) {
      if (route.settings.name == '/space') {
        found = true;
        return true;
      }
      return route.isFirst;
    });
    if (!found) Get.offNamed('/space');
  }

  Widget menu(BuildContext context, {bool drawer = false}) => Container(
    width: 238,
    color: const Color(0xF2081524),
    child: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.tune_rounded, color: managementIce, size: 27),
            const SizedBox(height: 14),
            const Text(
              'CENTRAL DE GESTÃO',
              style: TextStyle(
                color: managementIce,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Organizar para conectar.',
              style: TextStyle(color: managementMuted, fontSize: 12),
            ),
            const SizedBox(height: 28),
            ListTile(
              selected: !connections && section == null,
              leading: const Icon(Icons.space_dashboard_outlined),
              title: const Text('Visão geral'),
              onTap: () {
                if (drawer) Navigator.pop(context);
                if (connections || section != null) Get.toNamed('/management');
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'RELAÇÕES',
              style: TextStyle(
                color: managementMuted,
                fontSize: 10,
                letterSpacing: 1.5,
              ),
            ),
            if (canConnections)
              ListTile(
                selected: connections,
                leading: const Icon(Icons.hub_outlined),
                title: const Text('Conexões'),
                onTap: () {
                  if (drawer) Navigator.pop(context);
                  if (!connections) {
                    Get.toNamed('/management/connections');
                  } else if (Get.currentRoute != '/management/connections') {
                    if (Get.previousRoute == '/management/connections') {
                      Get.back();
                    } else {
                      Get.offNamed('/management/connections');
                    }
                  }
                },
              ),
            if (admin) ...[
              const SizedBox(height: 24),
              const Text(
                'PARAMETRIZAÇÕES',
                style: TextStyle(
                  color: managementMuted,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              for (final entry in managementSections)
                ListTile(
                  selected: section == entry.route,
                  leading: Icon(entry.icon, size: 20),
                  title: Text(
                    entry.label,
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    if (drawer) Navigator.pop(context);
                    if (Get.currentRoute != '/${entry.route}') {
                      Get.toNamed('/${entry.route}');
                    }
                  },
                ),
            ],
            const SizedBox(height: 34),
            const Divider(color: Color(0xFF28434F)),
            TextButton.icon(
              onPressed: returnToCockpit,
              icon: const Icon(Icons.rocket_launch_outlined, size: 17),
              label: const Text('Voltar ao cockpit'),
            ),
          ],
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData.dark(useMaterial3: true).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: managementIce,
        brightness: Brightness.dark,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF0C2030),
        labelStyle: TextStyle(color: managementMuted),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF365562)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: managementIce),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      scaffoldBackgroundColor: const Color(0xFF050C18),
      listTileTheme: const ListTileThemeData(
        selectedColor: managementIce,
        selectedTileColor: Color(0xFF17353C),
        iconColor: managementMuted,
        textColor: Color(0xFFD7E7EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    ),
    child: LayoutBuilder(
      builder: (context, box) {
        final compact = box.maxWidth < 900;
        return Scaffold(
          drawer: compact
              ? Drawer(
                  backgroundColor: const Color(0xFF081524),
                  child: menu(context, drawer: true),
                )
              : null,
          body: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF102736), Color(0xFF050C18)],
              ),
            ),
            child: Row(
              children: [
                if (!compact) menu(context),
                Expanded(
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(compact ? 14 : 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              if (compact)
                                Builder(
                                  builder: (context) => IconButton(
                                    tooltip: 'Menu de gestão',
                                    onPressed: () =>
                                        Scaffold.of(context).openDrawer(),
                                    icon: const Icon(Icons.menu),
                                  ),
                                ),
                              if (onBack != null)
                                Flexible(
                                  child: TextButton.icon(
                                    onPressed: onBack,
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      size: 16,
                                    ),
                                    label: Text(
                                      backLabel,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              const Spacer(),
                              const Text(
                                'EC–01 / SISTEMAS',
                                style: TextStyle(
                                  color: managementMuted,
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: compact ? 27 : 34,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              ...actions,
                              if (onRefresh != null)
                                IconButton(
                                  tooltip: 'Atualizar',
                                  onPressed: onRefresh,
                                  icon: const Icon(
                                    Icons.refresh,
                                    color: managementIce,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            style: const TextStyle(
                              color: managementMuted,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          if (status != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                status!,
                                style: const TextStyle(
                                  color: managementIce,
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xD9071624),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF294955),
                                ),
                              ),
                              child: child,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
