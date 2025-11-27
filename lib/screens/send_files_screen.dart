import 'package:unisinos_usp_app/controllers/send_files_controller.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets/file_selector.dart';
import 'package:widgets_spo/widgets_spo.dart';

class SendFilesScreen extends StatefulWidget {
  const SendFilesScreen({super.key});

  @override
  State<SendFilesScreen> createState() => _SendFilesScreenState();
}

class _SendFilesScreenState extends State<SendFilesScreen> {
  final controller = Get.isRegistered<SendFilesController>() ? Get.find<SendFilesController>() : Get.put(SendFilesController());

  Worker? _worker;

  @override
  void initState() {
    super.initState();

    _worker = ever(controller.filesVersion, (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _worker?.dispose();
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
            'Enviar arquivos',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              returnWithFiles();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Envio de arquivos',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Insets.small.height,
                    Text(
                      'Upload de arquivos que são evidências das provas como, áudio, PDF...',
                      style: secondaryTextStyle(size: 16),
                    ),
                    Text(
                      'Limite de arquivos: ${controller.maxFiles}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: controller.allFiles.length >= 3 ? Colors.red : Colors.black87,
                      ),
                    ),
                    Insets.medium.height,
                    Insets.extraLarge.height,
                    FileSelector(
                      width: 180,
                      allowMultiple: true,
                      type: FileSelectorType.pdf,
                      files: controller.pdfs,
                    ),
                    Insets.medium.height,
                    FileSelector(
                      width: 190,
                      allowMultiple: true,
                      type: FileSelectorType.video,
                      files: controller.videos,
                    ),
                    Insets.medium.height,
                    FileSelector(
                      width: 190,
                      allowMultiple: true,
                      type: FileSelectorType.audio,
                      files: controller.audios,
                    ),
                    Insets.medium.height,
                    FileSelector(
                      width: 200,
                      allowMultiple: true,
                      type: FileSelectorType.image,
                      files: controller.images,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ActionButton(
                theme: ActionButtonTheme.blue,
                title: 'Salvar',
                onPressed: () {
                  returnWithFiles();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void returnWithFiles() {
    if (controller.allFiles.length > controller.maxFiles) {
      Get.snackbar('Limite atingido', 'Você já adicionou o máximo de ${controller.maxFiles} arquivos.');
      return;
    }
    Get.secureBack(result: controller.allFiles);
  }
}
