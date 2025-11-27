import 'package:unisinos_usp_app/controllers/trail_manager_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/trail_listview_paginated.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_search.dart';

class TrailsManagerScreen extends StatelessWidget {
  final TrailManagerController _controller = Get.find<TrailManagerController>();

  TrailsManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Gerenciar Trilhas',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
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
                'Trilhas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              Text(
                'Aqui você pode visualizar, editar e cadastrar trilhas.',
                style: secondaryTextStyle(size: 16),
              ),
              Insets.small.height,
              InputSearch(
                initialValue: _controller.searchQuery,
                hintText: 'Pesquisar por nome ou Categoria',
                iconColor: Colors.black87,
                onSearch: (text) {
                  _controller.fetch(text: text);
                },
              ),
              Insets.medium.height,
              Expanded(
                child: TrailListviewPaginated(controller: _controller),
              ),
              Insets.medium.height,
              SizedBox(
                width: double.infinity,
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: 'Nova Trilha',
                  onPressed: () async {
                    await Get.toNamed('/trail_editor');
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
}
