import 'package:unisinos_usp_app/controllers/report_controller.dart';
import 'package:unisinos_usp_app/models/report_trail_stats_model.dart';
import 'package:unisinos_usp_app/webclients/category_webclient.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_select_api.dart';

class ReportScreen extends StatelessWidget {
  final ReportController _controller = Get.put(ReportController());

  ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Relatórios de Desempenho',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Obx(() {
          if (_controller.isLoading.value && _controller.trailStats.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              const Text(
                'Visão Geral das Trilhas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Insets.small.height,
              Text(
                'Selecione o indicador que deseja visualizar no gráfico.',
                style: secondaryTextStyle(size: 16),
              ),
              Insets.small.height,
              Obx(() {
                var categorySelect = _controller.categorySelectController.value;

                return InputSelectApi(
                  label: 'Filtrar por Categoria',
                  controller: categorySelect,
                  onFind: CategoryWebclient().select,
                  onChanged: (selectedId) {
                    if (selectedId != null) {
                      categorySelect.selectedItem!.id = selectedId;
                    }
                    _controller.fetchReportStats(categoryId: selectedId);
                  },
                );
              }),
              Insets.large.height,
              _buildChartOptions(),
              Insets.large.height,
              _buildDynamicChart(context),
              Insets.large.height,
              _buildDetailedTable(),
              Insets.large.height,
              ActionButton(
                theme: ActionButtonTheme.blue,
                title: 'Exportar Dados (.xlsx)',
                onPressed: _controller.exportData,
              ),
              Insets.large.height,
            ],
          );
        }),
      ),
    );
  }

  Widget _buildChartOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ChartDataType.values.map((type) {
          final isSelected = _controller.currentChartData.value == type;

          String getTitle(ChartDataType t) {
            switch (t) {
              case ChartDataType.enrollment:
                return 'Matrículas';
              case ChartDataType.completionRate:
                return 'Conclusão';
              case ChartDataType.averageScore:
                return 'Média Prova';
              case ChartDataType.conclusionTime:
                return 'Tempo Médio';
            }
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionButton(
              theme: isSelected ? ActionButtonTheme.blue : ActionButtonTheme.lightGrey,
              title: getTitle(type),
              onPressed: () => _controller.setChartDataType(type),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDynamicChart(BuildContext context) {
    final data = _controller.trailStats;
    final type = _controller.currentChartData.value;

    if (data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text('Nenhum dado de trilha disponível.', style: secondaryTextStyle()),
        ),
      );
    }

    String title;
    String yTitle;
    num Function(ReportTrailStats) yValueMapper;

    switch (type) {
      case ChartDataType.enrollment:
        title = 'Número de Alunos Matriculados';
        yTitle = 'Alunos';
        yValueMapper = (stats) => stats.studentCount;
        break;
      case ChartDataType.completionRate:
        title = 'Taxa de Conclusão';
        yTitle = 'Taxa (%)';
        yValueMapper = (stats) => stats.conclusionRate * 100;
        break;
      case ChartDataType.averageScore:
        title = 'Desempenho Médio nas Provas';
        yTitle = 'Nota Média';
        yValueMapper = (stats) => stats.averageScore;
        break;
      case ChartDataType.conclusionTime:
        title = 'Tempo Médio de Conclusão';
        yTitle = 'Dias';
        yValueMapper = (stats) => stats.averageConclusionTimeInDays;
        break;
    }

    final chartWidth = (data.length * 10).clamp(300.0, double.infinity).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: primaryTextStyle(size: 16, weight: FontWeight.bold)),
        Insets.small.height,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: chartWidth,
            height: 450,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelRotation: 85,
                labelIntersectAction: AxisLabelIntersectAction.none,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 2),
                labelStyle: const TextStyle(fontSize: 12),
                interval: 1,
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: yTitle),
                minimum: 0,
                interval: _getYAxisInterval(data, yValueMapper),
                majorGridLines: const MajorGridLines(width: 0.3, dashArray: [3, 3]),
                axisLine: const AxisLine(width: 0.5),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: false,
                header: '',
                color: const Color(0xff030da7),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                borderWidth: 0,
              ),
              series: <CartesianSeries>[
                ColumnSeries<ReportTrailStats, String>(
                  dataSource: data,
                  width: 0.35,
                  xValueMapper: (stats, _) => stats.trailName,
                  yValueMapper: (stats, _) => yValueMapper(stats),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  gradient: const LinearGradient(
                    colors: [Color(0xff007aff), Color(0xff0040ff)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  animationDuration: 1000,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    showZeroValue: false,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    // builder: (dataPoint, _, __, ___, ____) {
                    //   return Text(
                    //     dataLabelMapper(dataPoint),
                    //     style: const TextStyle(
                    //       fontSize: 10,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.white,
                    //     ),
                    //   );
                    // },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('4. Detalhes (Feedbacks e Tempo)', style: primaryTextStyle(size: 16, weight: FontWeight.bold)),
        Insets.small.height,
        Container(
          constraints: BoxConstraints(maxHeight: 500),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._controller.trailStats.map((stats) {
                  if (stats.feedbacks.isEmpty) return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child:
                            Text('Feedbacks em ${stats.trailName} (${stats.feedbacks.length})', style: secondaryTextStyle(weight: FontWeight.bold)),
                      ),
                      ...stats.feedbacks.take(3).map((f) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('• "${f.content}"', maxLines: 2, overflow: TextOverflow.ellipsis),
                          )),
                      if (stats.feedbacks.length > 3) Text('... Mais ${stats.feedbacks.length - 3} feedbacks.', style: secondaryTextStyle(size: 12)),
                    ],
                  );
                }),
                Insets.medium.height,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Trilha', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Média da Prova', style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('Tempo Médio (dias)', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: _controller.trailStats.map((stats) {
                      return DataRow(cells: [
                        DataCell(Text(stats.trailName)),
                        DataCell(Text(stats.averageScore.toStringAsFixed(1))),
                        DataCell(Text(stats.averageConclusionTimeInDays.toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getYAxisInterval(
    List<ReportTrailStats> data,
    num Function(ReportTrailStats) yValueMapper,
  ) {
    if (data.isEmpty) return 1;
    final values = data.map(yValueMapper).toList();
    final max = values.reduce((a, b) => a > b ? a : b);

    if (max <= 10) return 1;
    if (max <= 50) return 5;
    if (max <= 100) return 10;
    if (max <= 500) return 50;
    if (max <= 1000) return 100;
    return (max / 10).roundToDouble();
  }
}
