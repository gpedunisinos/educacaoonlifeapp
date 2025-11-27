import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:flutter/material.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets/input_select.dart';

Widget assessmentQuestionItem({
  required AssessmentQuestionModel questionModel,
  required ValueChanged<dynamic> onChanged,
  String? initialValue,
  bool readOnly = false,
  int? maxLines,
}) {
  final Map<String, String> availableAnswersMap = {
    for (var answer in questionModel.availableAnswers ?? []) answer.id.toString(): answer.title,
  };

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        questionModel.question,
        style: primaryTextStyle(size: 16, weight: FontWeight.bold),
      ),
      Insets.small.height,
      if (questionModel.type == QuestionType.subjective)
        TextField(
          onChanged: onChanged,
          controller: initialValue != null ? TextEditingController(text: initialValue) : null,
          readOnly: readOnly,
          minLines: 1,
          maxLines: maxLines,
        )
      else if (questionModel.type == QuestionType.objective)
        InputSelect(
          label: 'Selecione uma resposta',
          itens: availableAnswersMap,
          onChange: onChanged,
          controller: TextEditingController(), // just cause is required
        ),
    ],
  );
}
