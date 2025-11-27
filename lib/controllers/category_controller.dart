import 'package:unisinos_usp_app/controllers/trail_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/widgets/banner_carroussel.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class CategoryController extends GetxController {
  final CategoryWebclient webclient = CategoryWebclient();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<CategoryModel> searchedCategories = <CategoryModel>[].obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchCategories();
  }

  Future<void> fetchCategories({String? search, int? offset}) async {
    try {
      isLoading.value = true;

      final List<CategoryModel> fetchedList = await webclient.fetch(search: search, offset: offset);

      if (offset == 0) {
        categories.assignAll(fetchedList);
        searchedCategories.assignAll(fetchedList);
      } else {
        categories.addAll(fetchedList);
        searchedCategories.addAll(fetchedList);
      }
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar pela lista de Categorias. $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchCategories([String? text, int? limit, int? offset]) async {
    try {
      isLoading.value = true;

      if (text == null || text.isEmpty) {
        searchedCategories.assignAll(categories);
      } else {
        final fetched = await webclient.fetch(search: text, limit: limit, offset: offset);
        searchedCategories.assignAll(fetched);
      }
    } on Exception catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao filtrar lista de Categorias. $e');
    } finally {
      isLoading.value = false;
    }
  }

  void resetSearched() {
    searchedCategories.assignAll(categories);
  }

  List<BannerModel> getRandomBanners({int limit = 5}) {
    final bannersData = categories
        .expand((category) => (category.trails ?? [])
            .where((trail) => trail.coverImageFileId != null && trail.coverImageFileId! > 0)
            .map((trail) => {'category': category, 'trail': trail}))
        .toList()
      ..shuffle();

    final dynamicIds = bannersData.map((e) => (e['trail']! as TrailModel).id).toSet();
    final fullTrails = Get.find<TrailController>().trails.where((trail) => dynamicIds.contains(trail.id)).toList();

    // Mapeia para BannerModel
    return fullTrails.isEmpty
        ? []
        : bannersData
            .take(limit)
            .map((data) {
              final category = data['category']! as CategoryModel;
              final trail = fullTrails.firstWhere((t) => t.id == (data['trail']! as TrailModel).id);
              return BannerModel(
                title: category.name!,
                subtitle: category.description ?? '',
                file: trail.coverImageFile,
              );
            })
            .whereType<BannerModel>()
            .toList();
  }
}
