import 'package:unisinos_usp_app/controllers/assessment_pending_controller.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/webclients/trail_webclient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';

class PendingAssessmentsScreen extends StatelessWidget {
  final AssessmentPendingController _controller = Get.find<AssessmentPendingController>();

  final Rxn<ItemSelectController> _trailSelectController = Rxn<ItemSelectController>(ItemSelectController());

  PendingAssessmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Provas Pendentes',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lista de Provas pendentes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Insets.small.height,
                  Text('Aqui tem uma descrição sobre as provas que estão pendentes de correção.', style: secondaryTextStyle(size: 16)),
                  Insets.medium.height,
                  Obx(() => InputSelectApi(
                        label: 'Filtrar por Trilha',
                        controller: _trailSelectController.value!,
                        onFind: TrailWebclient().select,
                        onChanged: (selectedId) async {
                          if (selectedId != null) {
                            _trailSelectController.value!.selectedItem!.id = selectedId;
                          }
                          await _controller.fetch(trailId: selectedId);
                        },
                      )),
                  Insets.large.height,
                  Text('Provas', style: primaryTextStyle(size: 20, weight: FontWeight.bold)),
                  Insets.small.height,
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                RxList<AssessmentCompletionModel> assessments = _controller.assessments;

                return Padding(
                  padding: EdgeInsets.only(bottom: 36),
                  child: PaginatedSeparatedListView(
                    isLoading: _controller.isLoading.value,
                    items: assessments.toList(),
                    separatorBuilder: (context, _) => Insets.small.height,
                    onFetchMore: (offset) => _controller.fetch(trailId: _trailSelectController.value?.selectedItem?.id),
                    itemBuilder: (context, assessCompl, index) {
                      var assessment = assessCompl.assessment;
                      DateTime limitDate = assessCompl.createdAt!.add(const Duration(hours: 24));

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text(
                            assessment!.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Aluno: ${assessCompl.user!.name}', style: secondaryTextStyle(size: 14)),
                              Text('Trilha: ${assessment.classModel!.trail?.name}', style: secondaryTextStyle(size: 14)),
                              Text('Data de envio: ${assessment.createdAt!.format('dd/MM/yyyy')}', style: secondaryTextStyle(size: 14)),
                              Text('Data limite: ${limitDate.format('dd/MM/yyyy HH:mm')}',
                                  style: secondaryTextStyle(size: 14, color: Colors.redAccent)),
                            ],
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                          onTap: () async {
                            await Get.toNamed('/review_assessment/${assessCompl.assessmentId}', arguments: assessCompl);
                            _controller.fetch(trailId: _trailSelectController.value!.selectedItem?.id);
                          },
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
