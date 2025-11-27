import 'package:unisinos_usp_app/models/report_trail_stats_model.dart';
import 'package:unisinos_usp_app/webclients/report_webclient.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_select_api.dart';

enum ChartDataType { enrollment, completionRate, averageScore, conclusionTime }

class ReportController extends GetxController {
  final ReportWebclient webclient = ReportWebclient();

  final RxList<ReportTrailStats> trailStats = <ReportTrailStats>[].obs;

  final RxString selectedTrailId = ''.obs;

  final Rx<ChartDataType> currentChartData = ChartDataType.enrollment.obs;
  final Rx<ItemSelectController> categorySelectController = Rx<ItemSelectController>(ItemSelectController());

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchReportStats();
  }

  Future<void> fetchReportStats({int? categoryId}) async {
    try {
      isLoading.value = true;

      final fetchedStats = await webclient.getReportsByTrail(
        trailId: selectedTrailId.value.isNotEmpty ? selectedTrailId.value : null,
        categoryId: categoryId?.toString(),
      );

      trailStats.assignAll(fetchedStats);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao buscar estatísticas de trilhas. $e');
      trailStats.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void setChartDataType(ChartDataType type) {
    currentChartData.value = type;
  }

  Future<void> exportData() async {
    if (trailStats.isEmpty) {
      Get.customSnackbar('Aviso', 'Nenhum dado para exportar.');
      return;
    }

    try {
      isLoading.value = true;
      final url = await webclient.exportReports(categoryId: categorySelectController.value.selectedItem?.id);

      Get.successSnackbar('Exportação realizada com sucesso');
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro na Exportação', 'Falha ao exportar os dados. $e');
    } finally {
      isLoading.value = false;
    }
  }
}
