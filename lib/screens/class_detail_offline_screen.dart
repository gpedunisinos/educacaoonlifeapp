import 'dart:io';

import 'package:unisinos_usp_app/controllers/class_offline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClassDetailsOfflineScreen extends StatelessWidget {
  final ClassOfflineController controller = Get.find<ClassOfflineController>();

  ClassDetailsOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final classModel = controller.currentClass.value;
      if (classModel == null) {
        return const Scaffold(
          body: Center(child: Text('Nenhuma aula selecionada.')),
        );
      }

      return SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff030da7),
            centerTitle: true,
            title: Text(
              classModel.name,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.secureBack(),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Insets.medium.height,
                      classModel.offlineVideoPath != null
                          ? SizedBox(
                              height: 300,
                              child: VideoPlayerWidget(localFile: File(classModel.offlineVideoPath!)),
                            )
                          : Container(
                              width: double.infinity,
                              height: 180,
                              color: Colors.grey[300],
                              child: Icon(Icons.image_not_supported, size: 30.0, color: Colors.grey[600]),
                            ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classModel.name,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Insets.small.height,
                            Text(classModel.description, style: secondaryTextStyle(size: 16)),
                            Insets.large.height,
                            Text('Conteúdo da Aula', style: primaryTextStyle(size: 16, weight: FontWeight.bold)),
                            ShowQuill(
                              jsonDelta: classModel.textContent ?? '',
                            ),
                            Insets.large.height,
                            Text('Arquivos da Aula', style: primaryTextStyle(size: 16, weight: FontWeight.bold)),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: classModel.files.map((file) {
                                return SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: FilePreviewComponent(file),
                                );
                              }).toList(),
                            ),
                            Insets.medium.height,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
