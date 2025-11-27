import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/class_completion_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/webclients/assessment_completion_webclient.dart';
import 'package:unisinos_usp_app/webclients/class_completion_webclient.dart';
import 'package:unisinos_usp_app/webclients/class_webclient.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:widgets_spo/utils.dart';

class ClassController extends GetxController {
  final ClassWebclient webclient = ClassWebclient();
  final ClassCompletionWebclient completionWebclient = ClassCompletionWebclient();
  final AssessmentCompletionWebclient assessmentCompletionWebclient = AssessmentCompletionWebclient();

  final Rxn<ClassModel> classDetails = Rxn<ClassModel>();
  final Rxn<AssessmentCompletionModel> assessmentCompl = Rxn<AssessmentCompletionModel>();
  final RxBool isAssessmentDone = false.obs;

  final RxBool isLoading = false.obs;

  final RxDouble videoDownloadProgress = 0.0.obs;

  final Dio _dio = Dio();

  bool get isAssessmentReproved => assessmentCompl.value?.status == AssessmentCompletionStatusEnum.repproved;

  @override
  void onInit() {
    super.onInit();

    final classId = Get.parameters['id'];
    final ClassModel? c = Get.arguments as ClassModel?;

    if (classId != null) {
      fetchById(classId.toInt());

      checkIfClassConcluded(classId.toInt());
    }

    if (c != null && c.hasAssessment! != false) {
      fetchLastAssessmentCompletion(c.assessment!.id);
    }
  }

  Future<void> fetchById(int id) async {
    try {
      isLoading.value = true;

      final ClassModel fetchedClass = await webclient.fetchById(id);

      classDetails.value = fetchedClass;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela Aula. $error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> doDownloadFiles(ClassModel classModel) async {
    final dir = await getApplicationDocumentsDirectory();

    try {
      isLoading.value = true;

      for (var file in classModel.files) {
        if (file.publicUrl != null) {
          final classFolder = '${dir.path}/${classModel.name}';
          await Directory(classFolder).create(recursive: true);

          final fileName = (file.name != null && file.name!.isNotEmpty) ? file.name! : 'file_${file.id}.${file.extension}';

          final savePath = '$classFolder/$fileName';

          final response = await http.get(Uri.parse(file.publicUrl!));
          if (response.statusCode == 200) {
            final f = File(savePath);
            await f.writeAsBytes(response.bodyBytes);
            print('Arquivo salvo em $savePath');
          } else {
            throw Exception('Erro ao baixar ${file.name}: status ${response.statusCode}');
          }
        }
      }
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      return;
    } finally {
      isLoading.value = false;
    }

    Get.successSnackbar('Todos os arquivos foram baixados.');
  }

  Future<String?> _downloadFile(
    String downloadUrl,
    String localPath, {
    Function(int received, int total)? onProgressUpdate,
  }) async {
    try {
      await _dio.download(
        downloadUrl,
        localPath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgressUpdate != null) {
            onProgressUpdate(received, total);
          }
        },
      );
      return localPath;
    } on DioException catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      // try to delete the partial file in case of failure
      if (File(localPath).existsSync()) {
        await File(localPath).delete();
      }
      return null;
    }
  }

  Future<void> doDownloadClass(ClassModel classModel) async {
    try {
      videoDownloadProgress.value = 0.0;

      final dir = await getApplicationDocumentsDirectory();
      final classFolder = '${dir.path}/offline_classes/${classModel.id}';
      await Directory(classFolder).create(recursive: true);

      //  download video
      String? localVideoPath;
      String? finalDownloadUrl;
      String videoFileName = 'video_${classModel.id}.mp4';

      final publicUrl = classModel.file?.publicUrl;

      if (publicUrl != null) {
        if (publicUrl.contains('youtu')) {
          throw Exception('Não é permitido baixar vídeos do Youtube.');
        } else {
          finalDownloadUrl = publicUrl;
        }

        final localPath = '$classFolder/$videoFileName';

        localVideoPath = await _downloadFile(
          finalDownloadUrl,
          localPath,
          onProgressUpdate: (received, total) {
            videoDownloadProgress.value = received / total;
          },
        );

        if (localVideoPath == null) {
          throw Exception('O download falhou ou foi cancelado.');
        }
      }

      //  download attached files (using dio)
      List<MFile> offlineFiles = [];
      for (var file in classModel.files) {
        if (file.publicUrl != null && file.publicUrl!.isNotEmpty) {
          final localPath = '$classFolder/${file.name ?? 'file_${file.id}.${file.extension}'}';

          final downloadedPath = await _downloadFile(
            file.publicUrl!,
            localPath,
            // we don't display progress for small files
          );

          if (downloadedPath != null) {
            offlineFiles.add(file.copyWith(path: downloadedPath));
          }
        }
      }

      //  save offline metadata
      final offlineClass = classModel.copyWith(
        offlineVideoPath: localVideoPath,
        files: offlineFiles,
      );

      await Util.prefs.setString('offline_class_${classModel.id}', jsonEncode(offlineClass.toJson()));

      videoDownloadProgress.value = 1.0;
      Get.successSnackbar('A Aula e seus arquivos foram disponibilizados offline.');
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao salvar a aula. $e');
    } finally {
      videoDownloadProgress.value = 0.0;
    }
  }

  Future<void> completeClass(ClassModel classModel, int userId) async {
    try {
      isLoading.value = true;

      ClassCompletionModel completionModel = ClassCompletionModel(id: 0, classId: classModel.id, userId: userId);

      await completionWebclient.add(completionModel);

      Get.successSnackbar('Aula concluída com sucesso!');
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao concluir aula. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkIfClassConcluded(int classId) async {
    try {
      isLoading.value = true;

      var classCompletionModel = await completionWebclient.fetchClassCompletion(classId);

      isAssessmentDone.value = classCompletionModel != null;
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao checar estado da Aula. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLastAssessmentCompletion(int id) async {
    try {
      isLoading.value = true;

      List<AssessmentCompletionModel> classCompletionList = await assessmentCompletionWebclient.fetch(params: {'assessment_id': id.toString()});

      assessmentCompl.value = classCompletionList.lastOrNull;
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao verificar estado da prova. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
