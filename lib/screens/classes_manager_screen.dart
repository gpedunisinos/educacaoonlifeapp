import 'package:unisinos_usp_app/controllers/classes_manager_controller.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/class_listview_paginated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_search.dart';
import 'package:widgets_spo/widgets/input_select_api.dart';
import 'package:widgets_spo/widgets/item_select.dart';

class ClassesManagerScreen extends StatefulWidget {
  const ClassesManagerScreen({super.key});

  @override
  State<ClassesManagerScreen> createState() => _ClassesManagerScreenState();
}

class _ClassesManagerScreenState extends State<ClassesManagerScreen> {
  final ClassesManagerController _controller = Get.find<ClassesManagerController>();
  final ItemSelectController _trailSelectController = ItemSelectController();

  @override
  void initState() {
    super.initState();

    TrailModel? trailModel = _controller.trail.value;
    if (trailModel != null) {
      _trailSelectController.selectedItem = ItemSelect(id: trailModel.category?.id ?? 0, name: trailModel.category?.name ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: Obx(() => Text(
                _controller.trail.value != null ? 'Aulas: ${_controller.trail.value!.name}' : 'Gerenciar Aulas',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              )),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Aulas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              Text(
                'Aqui você pode visualizar, editar e cadastrar aulas para esta trilha.',
                style: secondaryTextStyle(size: 16),
              ),
              Insets.small.height,
              Text(
                'Selecione uma Trilha para visualizar as aulas',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              InputSelectApi(
                label: '',
                controller: _trailSelectController,
                onFind: TrailWebclient().select,
                onChanged: (selectedId) async {
                  if (selectedId != null) {
                    setState(() {
                      _controller.searchQuery = '';
                    });
                    _trailSelectController.selectedItem!.id = selectedId;
                    await _controller.fetchByTrail(selectedId);
                    return;
                  }

                  setState(() {
                    _trailSelectController.selectedItem = null;
                  });
                  await _controller.fetch();
                },
              ),
              Insets.medium.height,
              InputSearch(
                initialValue: _controller.searchQuery,
                hintText: 'Pesquisar por nome',
                iconColor: Colors.black87,
                onSearch: (text) {
                  setState(() {
                    _trailSelectController.selectedItem = null;
                  });

                  _controller.searchQuery = text ?? '';
                  _controller.fetch(text: text);
                },
              ),
              Insets.medium.height,
              Expanded(
                child: ClassListviewPaginated(
                  controller: _controller,
                  trailSelectController: _trailSelectController,
                  isReorderable: _trailSelectController.selectedItem != null && _trailSelectController.selectedItem!.id > 0,
                ),
              ),
              Insets.medium.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Nova Aula',
                  onPressed: () async {
                    await Get.toNamed(
                      '/class_editor',
                      arguments: {
                        'trailId': _trailSelectController.selectedItem?.id,
                      },
                    );

                    if (_trailSelectController.selectedItem?.id != null) {
                      await _controller.fetchByTrail(_trailSelectController.selectedItem!.id);
                    } else {
                      await _controller.fetch();
                    }
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
