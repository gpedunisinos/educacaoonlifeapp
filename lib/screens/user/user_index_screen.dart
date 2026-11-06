import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/user/user_index_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/policies/user_policy.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';

class UserIndexScreen extends StatefulWidget {
  const UserIndexScreen({super.key});

  @override
  State<UserIndexScreen> createState() => _UserIndexScreenState();
}

class _UserIndexScreenState extends State<UserIndexScreen> {
  final UserIndexController _controller = Get.find<UserIndexController>();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canManage = UserPolicy(
      Get.find<UserController>().user.value,
    ).create();
    return ManagementRecordScaffold(
      section: 'users',
      title: 'Usuários',
      subtitle: 'Gerencie pessoas e seus perfis de acesso à plataforma.',
      actions: [
        if (canManage)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Novo usuário',
          ),
      ],
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome ou e-mail',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white70),
                      onPressed: () =>
                          _controller.applySearch(_searchController.text),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: _controller.applySearch,
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (_controller.isLoading.value &&
                      _controller.users.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                  if (_controller.users.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum usuário encontrado.',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount:
                        _controller.users.length +
                        (_controller.isLoadingMore.value ? 1 : 0),
                    itemBuilder: (_, index) {
                      if (index >= _controller.users.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final model = _controller.users[index];
                      return _UserCard(
                        model: model,
                        canManage: canManage,
                        onEdit: () => _goToUpdate(model),
                        onDelete: () => _confirmDelete(model),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }

  void _confirmDelete(UserModel model) {
    Get.defaultDialog(
      title: 'Excluir usuário',
      middleText: 'Deseja realmente excluir "${model.name}"?',
      textCancel: 'Cancelar',
      textConfirm: 'Excluir',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        _controller.deleteUser(model);
      },
    );
  }

  Future<void> _goToCreate() async {
    final created = await Get.toNamed('/users/create');
    if (created == true) {
      await _controller.loadInitial();
    }
  }

  Future<void> _goToUpdate(UserModel model) async {
    final updated = await Get.toNamed(
      '/users/update',
      parameters: {'id': model.id.toString()},
    );
    if (updated == true) {
      await _controller.loadInitial();
    }
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.model,
    required this.canManage,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel model;
  final bool canManage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.black.withValues(alpha: 0.58),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x8A46B6EC), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 420;
            final actions = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Editar usuário',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                ),
                IconButton(
                  tooltip: 'Excluir usuário',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                ),
              ],
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.withValues(alpha: 0.2),
                      child: Text(
                        model.name.isNotEmpty
                            ? model.name.characters.first.toUpperCase()
                            : '?',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            model.name.isEmpty
                                ? 'Nome não informado'
                                : model.name,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 4),
                          SelectableText(
                            model.email.isEmpty
                                ? 'E-mail não informado'
                                : model.email,
                            style: const TextStyle(
                              color: Colors.white70,
                              height: 1.35,
                            ),
                          ),
                          if ((model.phone ?? '').isNotEmpty)
                            Text(
                              model.phone!,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (canManage && !compact) actions,
                  ],
                ),
                if (canManage && compact)
                  Align(alignment: Alignment.centerRight, child: actions),
              ],
            );
          },
        ),
      ),
    );
  }
}
