import 'dart:convert';

import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class ClassOfflineController extends GetxController {
  final RxList<ClassModel> offlineClasses = <ClassModel>[].obs;

  final Rxn<ClassModel> currentClass = Rxn<ClassModel>();

  @override
  void onInit() {
    super.onInit();
    loadOfflineClasses();
  }

  void loadOfflineClasses() {
    final prefs = Util.prefs;
    final keys = prefs.getKeys();

    final classKeys = keys.where((k) => k.startsWith('offline_class_'));

    final classes = <ClassModel>[];
    for (final key in classKeys) {
      final jsonString = prefs.getString(key);
      if (jsonString != null) {
        try {
          final map = jsonDecode(jsonString);
          classes.add(ClassModel.fromJson(map));
        } catch (e) {
          print('Erro ao decodificar aula offline: $e');
        }
      }
    }

    offlineClasses.assignAll(classes);
  }

  void openClass(ClassModel classModel) {
    currentClass.value = classModel;
  }

  Future<void> deleteClass(ClassModel classModel) async {
    final prefs = Util.prefs;
    await prefs.remove('offline_class_${classModel.id}');
    loadOfflineClasses();
  }
}
