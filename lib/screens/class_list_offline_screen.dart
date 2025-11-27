import 'package:unisinos_usp_app/controllers/class_offline_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class ClassListOfflineScreen extends StatelessWidget {
  final ClassOfflineController controller = Get.find<ClassOfflineController>();

  ClassListOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Aulas Offline',
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: Obx(() {
          if (controller.offlineClasses.isEmpty) {
            return const Center(child: Text('Nenhuma aula baixada ainda.'));
          }

          return ListView.separated(
            itemCount: controller.offlineClasses.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final classModel = controller.offlineClasses[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: ListTile(
                  title: Text(
                    classModel.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    classModel.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.deleteClass(classModel);

                          Get.successSnackbar('Aula excluída com sucesso');
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    controller.openClass(classModel);
                    Get.toNamed('/class_details_offline/${classModel.id}');
                  },
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
