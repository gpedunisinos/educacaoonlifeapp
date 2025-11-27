import 'package:unisinos_usp_app/controllers/assessment_performance_controller.dart';
import 'package:unisinos_usp_app/models/report_teacher_score_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:widgets_spo/utils.dart';

class AssessmentPerformanceScreen extends StatelessWidget {
  final AssessmentPerformanceController _controller = Get.put(AssessmentPerformanceController());

  AssessmentPerformanceScreen({super.key});

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
          if (_controller.isLoading.value && _controller.teacherScores.isEmpty) {
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
              Insets.large.height,
              Center(child: _buildDynamicChart(context)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDynamicChart(BuildContext context) {
    final data = _controller.teacherScores;

    if (data.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Text('Nenhum dado de desempenho disponível.', style: secondaryTextStyle()),
        ),
      );
    }

    const title = 'Distribuição das Notas ao Longo do Tempo';
    const yTitle = 'Nota Média';
    const xTitle = 'Período (dias)';

    final chartWidth = (data.length * 80).clamp(300.0, double.infinity).toDouble();

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
                title: AxisTitle(text: xTitle),
                labelRotation: 60,
                majorGridLines: const MajorGridLines(width: 0),
                axisLine: const AxisLine(width: 2),
                labelStyle: const TextStyle(fontSize: 12),
                interval: 1,
              ),
              primaryYAxis: NumericAxis(
                title: const AxisTitle(text: yTitle),
                minimum: 0,
                maximum: 10,
                interval: 1,
                majorGridLines: const MajorGridLines(width: 0.3, dashArray: [3, 3]),
                axisLine: const AxisLine(width: 0.5),
                majorTickLines: const MajorTickLines(size: 0),
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                header: '',
                color: const Color(0xff030da7),
                textStyle: const TextStyle(color: Colors.white, fontSize: 12),
                borderWidth: 0,
              ),
              series: <CartesianSeries>[
                SplineSeries<ReportTeacherScore, String>(
                  dataSource: data,
                  xValueMapper: (stats, _) => stats.period.toString(),
                  yValueMapper: (stats, _) => stats.averageScore,
                  markerSettings: const MarkerSettings(isVisible: true),
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: const Color(0xff0040ff),
                  width: 3,
                  animationDuration: 1000,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
