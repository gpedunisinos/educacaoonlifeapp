import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_index_controller.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/policies/policies.dart';
import 'package:unisinos_usp_app/screens/management/management_record_scaffold.dart';

class ChatTemplateIndexScreen extends StatefulWidget {
  const ChatTemplateIndexScreen({super.key});

  @override
  State<ChatTemplateIndexScreen> createState() =>
      _ChatTemplateIndexScreenState();
}

class _ChatTemplateIndexScreenState extends State<ChatTemplateIndexScreen> {
  final ChatTemplateIndexController _controller =
      Get.find<ChatTemplateIndexController>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canManage = ChatTemplatePolicy(
      Get.find<UserController>().user.value,
    ).create();

    return ManagementRecordScaffold(
      section: 'chat_templates',
      title: 'Agentes',
      subtitle: 'Configure identidades, instruções e referências dos agentes.',
      actions: [
        if (canManage)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Novo agente',
          ),
      ],
      body: Stack(
        children: [
          Obx(() {
            if (_controller.isLoading.value && _controller.templates.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            if (_controller.templates.isEmpty) {
              return RefreshIndicator(
                onRefresh: _controller.loadInitial,
                child: ListView(
                  children: const [
                    SizedBox(height: 220),
                    Center(
                      child: Text(
                        'Nenhum template cadastrado.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _controller.loadInitial,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount:
                    _controller.templates.length +
                    (_controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (_, index) {
                  if (index >= _controller.templates.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  final ChatTemplateModel template =
                      _controller.templates[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0x8A46B6EC),
                        width: 1.2,
                      ),
                    ),
                    color: Colors.black.withValues(alpha: 0.58),
                    child: ListTile(
                      title: Text(
                        template.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        template.description?.isNotEmpty ?? false
                            ? template.description!
                            : (template.systemInstruction?.isNotEmpty ?? false
                                  ? template.systemInstruction!
                                  : 'Sem descrição'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () => _goToChat(template),
                      trailing: canManage
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  color: Colors.white,
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _goToUpdate(template),
                                  tooltip: 'Editar template',
                                ),
                                IconButton(
                                  color: Colors.red.shade300,
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _confirmDelete(template),
                                  tooltip: 'Excluir template',
                                ),
                              ],
                            )
                          : null,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _goToCreate() async {
    final dynamic result = await Get.toNamed('/chat_templates/create');
    if (result ?? false) {
      await _controller.loadInitial();
    }
  }

  Future<void> _goToUpdate(ChatTemplateModel template) async {
    final dynamic result = await Get.toNamed(
      '/chat_templates/update',
      parameters: {'id': template.id.toString()},
      arguments: template,
    );
    if (result == true) {
      await _controller.loadInitial();
    }
  }

  void _goToChat(ChatTemplateModel template) {
    Get.toNamed(
      '/chat_templates/chat',
      parameters: {'id': template.id.toString()},
      arguments: template,
    );
  }

  Future<void> _confirmDelete(ChatTemplateModel template) async {
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Excluir template'),
        content: Text('Deseja excluir o template "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await _controller.deleteTemplate(template);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }
}
