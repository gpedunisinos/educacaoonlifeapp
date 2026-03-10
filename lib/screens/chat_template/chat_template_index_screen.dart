import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/chat_template/chat_template_index_controller.dart';
import 'package:unisinos_usp_app/models/chat_template_model.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';

class ChatTemplateIndexScreen extends StatefulWidget {
  ChatTemplateIndexScreen({super.key});

  @override
  State<ChatTemplateIndexScreen> createState() => _ChatTemplateIndexScreenState();
}

class _ChatTemplateIndexScreenState extends State<ChatTemplateIndexScreen> {
  final ChatTemplateIndexController _controller = Get.find<ChatTemplateIndexController>();
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
    return Scaffold(
      appBar: AppBar(
        leading: const SafeBackButton(),
        title: const Text('Chat Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _goToCreate,
            tooltip: 'Novo template',
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value && _controller.templates.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.templates.isEmpty) {
          return RefreshIndicator(
            onRefresh: _controller.loadInitial,
            child: ListView(
              children: const [
                SizedBox(height: 220),
                Center(child: Text('Nenhum template cadastrado.')),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _controller.loadInitial,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _controller.templates.length + (_controller.isLoadingMore.value ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, index) {
              if (index >= _controller.templates.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final ChatTemplateModel template = _controller.templates[index];
              return ListTile(
                title: Text(template.name),
                subtitle: Text(
                  template.description?.isNotEmpty == true
                      ? template.description!
                      : (template.systemInstruction?.isNotEmpty == true
                          ? template.systemInstruction!
                          : 'Sem descrição'),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => _goToChat(template),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _goToUpdate(template),
                  tooltip: 'Editar template',
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Future<void> _goToCreate() async {
    final dynamic result = await Get.toNamed('/chat_templates/create');
    if (result == true) {
      await _controller.loadInitial();
    }
  }

  Future<void> _goToUpdate(ChatTemplateModel template) async {
    final dynamic result = await Get.toNamed(
      '/chat_templates/update',
      parameters: {'id': template.id.toString()},
    );
    if (result == true) {
      await _controller.loadInitial();
    }
  }

  void _goToChat(ChatTemplateModel template) {
    Get.toNamed(
      '/chat_templates/chat',
      parameters: {'id': template.id.toString()},
    );
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _controller.loadMore();
    }
  }
}
