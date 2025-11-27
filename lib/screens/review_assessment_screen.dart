import 'package:unisinos_usp_app/controllers/controllers.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_completion_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ReviewAssessmentScreen extends StatelessWidget {
  final AssessmentReviewController _controller = Get.find<AssessmentReviewController>();

  ReviewAssessmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Obx(() {
            var inReviewAssessment = _controller.inReviewAssessment.value;
            return Text(
              'Avaliação - ${inReviewAssessment?.name ?? ''}',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            );
          }),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Avaliação de provas',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Insets.small.height,
                          Text(
                            'Avalie com cuidado as respostas das seguintes questões listadas.',
                            style: secondaryTextStyle(size: 16),
                          ),
                          Insets.extraLarge.height,
                          Obx(() {
                            final questions = _controller.questions;

                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: questions.length,
                              separatorBuilder: (_, __) => Insets.medium.height,
                              itemBuilder: (_, index) {
                                final AssessmentQuestionCompletionModel question = questions[index];
                                final questionCompletionId = question.id;

                                String displayedAnswer = '';
                                if (question.assessmentQuestion?.type == QuestionType.subjective) {
                                  displayedAnswer = question.answerText!;
                                } else if (question.assessmentQuestion?.type == QuestionType.objective) {
                                  displayedAnswer = question.assessmentAvailableAnswer!.title;
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${index + 1}. ${question.assessmentQuestion!.question}',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    Insets.small.height,
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      child: Text(
                                        displayedAnswer,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    Insets.small.height,
                                    Row(
                                      children: [
                                        Text('Status:', style: primaryTextStyle(weight: FontWeight.bold)),
                                        Insets.small.width,
                                        Expanded(
                                          child: Obx(() {
                                            final bool? isCorrect = _controller.questionCorrections[questionCompletionId];

                                            return ElevatedButton(
                                              onPressed: _controller.isConcluded.value
                                                  ? () {}
                                                  : () => _controller.updateCorrectionStatus(questionCompletionId, true),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isCorrect == true ? Colors.green.shade600 : Colors.green.shade100,
                                                foregroundColor: isCorrect == true ? Colors.white : Colors.green.shade600,
                                                elevation: 0,
                                              ),
                                              child: Text('✅ Correto'),
                                            );
                                          }),
                                        ),
                                        Insets.small.width,
                                        Expanded(
                                          child: Obx(() {
                                            final bool? isCorrect = _controller.questionCorrections[questionCompletionId];

                                            return ElevatedButton.icon(
                                              onPressed: _controller.isConcluded.value
                                                  ? () {}
                                                  : () => _controller.updateCorrectionStatus(questionCompletionId, false),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isCorrect == false ? Colors.red.shade600 : Colors.red.shade100,
                                                foregroundColor: isCorrect == false ? Colors.white : Colors.red.shade600,
                                                elevation: 0,
                                              ),
                                              icon: Icon(
                                                Icons.close,
                                                color: isCorrect == false ? Colors.white : Colors.red.shade600,
                                              ),
                                              label: Text(
                                                'Falso',
                                                style: TextStyle(
                                                  color: isCorrect == false ? Colors.white : Colors.red.shade600,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }),
                          Obx(() {
                            var inReviewAssessment = _controller.inReviewAssessment.value;
                            var assessCompl = _controller.assessCompl.value;

                            if (inReviewAssessment?.type == AssessmentTypeEnum.practical && (assessCompl?.files?.isNotEmpty ?? false)) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Arquivos da Prova',
                                    style: primaryTextStyle(size: 16, weight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  GridFiles(
                                    assessCompl!.files ?? [],
                                    columns: kIsWeb
                                        ? AppThemeData.getColumnsCount(context, sm: 1, md: 2, xl: 3)
                                        : AppThemeData.getColumnsCount(context, md: 1, lg: 2, xl: 2),
                                  ),
                                ],
                              );
                            }

                            return const SizedBox.shrink();
                          }),
                          Insets.extraLarge.height,
                          Text(
                            'Observações do Professor',
                            style: primaryTextStyle(size: 16, weight: FontWeight.bold),
                          ),
                          Insets.small.height,
                          Obx(() {
                            return TextField(
                              controller: _controller.correctionNotes.value,
                              readOnly: _controller.isConcluded.value,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: 'Escreva suas observações sobre a prova...',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.blue.shade600),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                final shouldShowButton = !Get.find<UserController>().user.value!.isStudent ||
                    _controller.assessCompl.value?.status == AssessmentCompletionStatusEnum.waitingCorrection;

                if (shouldShowButton) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    width: double.infinity,
                    child: ActionButton(
                      theme: ActionButtonTheme.blue,
                      title: 'Concluir Revisão',
                      onPressed: _controller.isConcluded.value
                          ? null
                          : () async {
                              if (!_controller.isConcluded.value && await _controller.concludeReview()) {
                                Get.secureBack();
                              }
                            },
                    ),
                  );
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
