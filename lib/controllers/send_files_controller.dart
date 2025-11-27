import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class SendFilesController extends GetxController {
  final List<MFileBase> pdfs = [];
  final List<MFileBase> videos = [];
  final List<MFileBase> audios = [];
  final List<MFileBase> images = [];

  final RxInt filesVersion = 0.obs;

  final int maxFiles = 3;

  void clearFiles() {
    pdfs.clear();
    videos.clear();
    audios.clear();
    images.clear();
  }

  void setFiles(List<MFileBase> newFiles) {
    clearFiles();

    if (allFiles.length == maxFiles) {
      Get.snackbar('Limite atingido', 'Você já adicionou o máximo de $maxFiles arquivos.');
      return;
    }

    for (final file in newFiles) {
      final ext = file.extension.toLowerCase();

      if (['pdf'].contains(ext)) {
        pdfs.add(file);
      } else if (['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext)) {
        videos.add(file);
      } else if (['mp3', 'wav', 'm4a', 'aac', 'ogg'].contains(ext)) {
        audios.add(file);
      } else if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'].contains(ext)) {
        images.add(file);
      } else {
        images.add(file);
      }
    }

    filesVersion.value++;
  }

  List<MFileBase> get allFiles => [...pdfs, ...videos, ...audios, ...images];
}
