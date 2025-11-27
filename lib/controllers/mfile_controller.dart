import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/webclients/mfile_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class MfileController extends GetxController {
  MFileWebclient webclient = MFileWebclient();

  Future<List<MFile>> fetch() async {
    try {
      List<MFile> files = await webclient.fetch();

      return files;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha ao buscar arquivos. $error');
      rethrow;
    }
  }

  Future<void> add(List<MFile> files) async {
    try {
      for (MFile file in files) {
        await webclient.add(file);
      }

      // Get.successSnackbar('Salvo com sucesso'.tlt);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha adicionar arquivos. $error');
      rethrow;
    }
  }

  Future<MFile> addMultipart(MFile file, Map<String, String?> properties) async {
    try {
      var result = await webclient.addMultipart(file, fileFields: properties);

      return result;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Falha adicionar arquivos. $error');
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    try {
      await webclient.delete(id);
      // Get.successSnackbar('Deletado com sucesso'.tlt);
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao deletar arquivo: $error');
      rethrow;
    }
  }

  Future<int?> changePictureFile(MFile? modelPicture, MFile newPicture) async {
    try {
      if (modelPicture == null || modelPicture.id != newPicture.id) {
        MFile file = await webclient.addMultipart(newPicture, timeout: 60 * 3); // 3mins de timeout

        return file.id;
      }
      return modelPicture.id;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao alterar arquivo. $error');
      rethrow;
    }
  }

  Future<int?> changeClassFile(MFile? modelPicture, MFile newPicture) async {
    try {
      if (modelPicture == null) {
        MFile file = await webclient.addMultipart(newPicture, timeout: 60 * 3); // 3mins de timeout

        return file.id;
      } else if (modelPicture.id != newPicture.id) {
        await webclient.delete(modelPicture.id);
        MFile file = await webclient.addMultipart(newPicture, timeout: 60 * 3); // 3mins de timeout

        return file.id;
      }

      return modelPicture.id;
    } catch (error, stackTrace) {
      Util.debug(exception: error, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao alterar arquivo. $error');
      rethrow;
    }
  }
}
