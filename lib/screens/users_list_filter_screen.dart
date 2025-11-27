import 'package:unisinos_usp_app/controllers/users_list_controller.dart';
import 'package:unisinos_usp_app/utils/user_options.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_search.dart';
import 'package:widgets_spo/widgets/input_select.dart';

class UsersListFilterScreen extends StatefulWidget {
  const UsersListFilterScreen({super.key});

  @override
  State<UsersListFilterScreen> createState() => _UsersListFilterScreenState();
}

class _UsersListFilterScreenState extends State<UsersListFilterScreen> {
  final UsersListController _controller = Get.find<UsersListController>();

  late final TextEditingController _profileSelectController;
  late final TextEditingController _statusSelectController;
  late final TextEditingController _sortSelectController;

  @override
  void initState() {
    super.initState();
    _initFilters();
  }

  void _initFilters() {
    _profileSelectController = TextEditingController(
      text: _controller.filterByProfile.value.isEmpty ? null : _controller.filterByProfile.value,
    );

    _statusSelectController = TextEditingController(
      text: _controller.filterByStatus.value == null ? null : (_controller.filterByStatus.value! ? '1' : '0'),
    );

    _sortSelectController = TextEditingController(
      text: _controller.sortBy.value,
    );
  }

  @override
  void dispose() {
    _profileSelectController.dispose();
    _statusSelectController.dispose();
    _sortSelectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Filtro de Usuários',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => InputSearch(
                    initialValue: _controller.searchQuery.value,
                    hintText: 'Pesquisar por nome',
                    iconColor: Colors.black87,
                    onSearch: (text) {
                      _controller.searchQuery.value = text ?? '';
                    },
                  )),
              Insets.medium.height,
              const Text(
                'Filtros',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              InputSelect(
                label: 'Perfil',
                controller: _profileSelectController,
                itens: UserOptions.profileOptions,
                onChange: (value) {
                  _controller.filterByProfile.value = value ?? '';
                },
              ),
              Insets.medium.height,
              InputSelect(
                label: 'Status',
                controller: _statusSelectController,
                itens: UserOptions.statusOptions,
                onChange: (value) {
                  if (value == null || value.isEmpty) {
                    _controller.filterByStatus.value = null;
                  } else {
                    _controller.filterByStatus.value = value == '1';
                  }
                },
              ),
              Insets.medium.height,
              const Text(
                'Ordenação',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              InputSelect(
                label: 'Ordenar por',
                controller: _sortSelectController,
                itens: UserOptions.sortOptions,
                onChange: (value) {
                  _controller.sortBy.value = value ?? 'asc';
                },
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Aplicar Filtros',
                  onPressed: () {
                    _controller.fetch();
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
