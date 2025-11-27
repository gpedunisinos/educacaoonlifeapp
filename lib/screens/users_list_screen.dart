import 'package:unisinos_usp_app/controllers/users_list_controller.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/paginated_listview.dart';

class UsersListScreen extends StatelessWidget {
  final UsersListController _controller = Get.find<UsersListController>();

  UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Usuários',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                Get.toNamed('/users_list_filter');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Editar usuários',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              Text(
                'Aqui pode ser feita a edição dos usuários do aplicativo.',
                style: secondaryTextStyle(size: 16),
              ),
              Insets.medium.height,
              const Text(
                'Usuários',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              Expanded(
                child: Obx(() {
                  return PaginatedListView<UserModel>(
                    items: _controller.users,
                    isLoading: _controller.isLoading.value,
                    onFetchMore: (offset) => _controller.fetch(offset: offset),
                    itemBuilder: (context, user, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: ImageWidget(
                            image: user.profilePicture,
                            width: 36,
                            height: 36,
                          ),
                          title: Text(
                            user.name,
                            style: primaryTextStyle(size: 12, weight: FontWeight.bold),
                          ),
                          subtitle: Text(user.email, style: primaryTextStyle(size: 12, weight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  user.status ? Icons.toggle_on : Icons.toggle_off,
                                  size: 36,
                                  color: user.status ? Colors.green : Colors.red,
                                ),
                                onPressed: () => _controller.toggleUserStatus(user),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (String result) {
                                  if (result == 'delete') {
                                    _showDeleteConfirmationDialog(context, user);
                                  }
                                },
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete, color: Colors.red),
                                      title: Text('Excluir'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () async {
                            await Get.toNamed('/user_editor/${user.id}', arguments: user);

                            await _controller.fetch();
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
              Insets.medium.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Novo Cadastro',
                  onPressed: () async {
                    await Get.toNamed('/user_editor/0');

                    await _controller.fetch();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, UserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o usuário "${user.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.secureBack(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _controller.deleteUser(user);
              Get.back();
              _controller.fetch();
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
