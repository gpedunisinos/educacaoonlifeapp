import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:widgets_spo/widgets_spo.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final UserController _controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _controller.logout,
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Tela principal'),
            Insets.medium.height,
            ElevatedButton(
              onPressed: () => Get.toNamed('/categories'),
              child: const Text('Gerenciar categorias'),
            ),
            Insets.small.height,
            ElevatedButton(
              onPressed: () => Get.toNamed('/samples'),
              child: const Text('Gerenciar samples'),
            ),
          ],
        ),
      ),
    );
  }
}
