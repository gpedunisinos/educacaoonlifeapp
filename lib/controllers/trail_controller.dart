import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/models/user_trail_model.dart';
import 'package:unisinos_usp_app/webclients/class_webclient.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailController extends GetxController {
  final TrailWebclient webclient = TrailWebclient();
  final ClassWebclient classWebclient = ClassWebclient();

  final RxList<TrailModel> trails = <TrailModel>[].obs;
  final RxList<TrailModel> searchedTrails = <TrailModel>[].obs;
  final RxList<UserTrailModel> userTrails = <UserTrailModel>[].obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetch();
    fetchUserTrails();
  }

  Future<void> fetch({String? search, int? limit, int? offset}) async {
    try {
      isLoading.value = true;

      final List<TrailModel> fetched = await webclient.fetch(search: search, offset: offset, limit: limit);

      trails.assignAll(fetched);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Trilhas. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchTrails([String? text, int? limit, int? offset]) async {
    try {
      isLoading.value = true;

      if (text == null || text.isEmpty) {
        searchedTrails.assignAll(trails);
      } else {
        final fetched = await webclient.fetch(search: text, limit: limit, offset: offset);
        searchedTrails.assignAll(fetched);
      }
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao filtrar lista de Trilhas. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserTrails({int? limit, int? offset}) async {
    try {
      isLoading.value = true;

      final List<UserTrailModel> fetched = await webclient.fetchUserTrails(offset: offset, limit: limit);
      final List<ClassModel> classes = await classWebclient.fetch();

      final Map<int, List<ClassModel>> classesByTrail = {};
      for (var clas in classes) {
        final trailId = clas.trailId;
        if (trailId != null) {
          classesByTrail.putIfAbsent(trailId, () => []).add(clas);
        }
      }

      for (int i = 0; i < fetched.length; i++) {
        final userTrail = fetched[i];

        if (userTrail.trail == null) continue;

        final trailId = userTrail.trail!.id;

        final classesForTrail = classesByTrail[trailId] ?? [];

        final updatedTrail = userTrail.trail!.copyWith(
          classes: classesForTrail,
        );

        final updatedUserTrail = userTrail.copyWith(
          trail: updatedTrail,
        );

        fetched[i] = updatedUserTrail;
      }

      userTrails.assignAll(fetched);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pelas Trilhas do usuário. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
