import 'package:unisinos_usp_app/controllers/assessment_concluded_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/paginated_separated_listview.dart';

class ConcludedAssessmentsScreen extends StatelessWidget {
  final AssessmentConcludedController _controller = Get.find<AssessmentConcludedController>();

  ConcludedAssessmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Provas Concluídas',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                  const Text(
                    'Lista de Provas concluídas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Insets.small.height,
                  Text(
                    'Aqui tem uma descrição sobre as provas que estão concluídas.',
                    style: secondaryTextStyle(size: 16),
                  ),
                  Insets.large.height,
                  Text(
                    'Provas',
                    style: primaryTextStyle(size: 20, weight: FontWeight.bold),
                  ),
                  Insets.small.height,
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final assessments = _controller.assessments;

                return Padding(
                  padding: EdgeInsets.only(bottom: 36),
                  child: PaginatedSeparatedListView(
                    isLoading: _controller.isLoading.value,
                    items: assessments.toList(),
                    separatorBuilder: (context, _) => Insets.small.height,
                    onFetchMore: (offset) => _controller.fetchConcludedOnly(),
                    itemBuilder: (context, assessCompl, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            assessCompl.assessment!.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Aluno: ${assessCompl.user!.name}', style: secondaryTextStyle(size: 14)),
                              Text('Trilha: ${assessCompl.assessment!.classModel!.trail!.name}', style: secondaryTextStyle(size: 14)),
                              Text('Data de envio: ${assessCompl.createdAt!.format('dd/MM/yyyy')}', style: secondaryTextStyle(size: 14)),
                              Text('Nota: ${(assessCompl.score! * 10).toStringAsFixed(1)}', style: secondaryTextStyle(size: 14)),
                              Text('Status: ${assessCompl.status!.description}', style: secondaryTextStyle(size: 14)),
                            ],
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                          onTap: () async {
                            await Get.toNamed(
                              '/review_assessment/${assessCompl.assessmentId}',
                              arguments: assessCompl,
                            );

                            await _controller.fetchConcludedOnly();
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
