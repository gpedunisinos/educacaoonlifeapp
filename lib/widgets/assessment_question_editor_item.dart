import 'package:unisinos_usp_app/controllers/assessment_editor_controller.dart';
import 'package:unisinos_usp_app/models/assessment_available_answer_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/widgets_spo.dart';

typedef OnAnswerTitleChanged = void Function(
  AssessmentQuestionModel question,
  AssessmentAvailableAnswersModel answer,
  String newTitle,
);

class AssessmentQuestionEditorItem extends StatefulWidget {
  final AssessmentQuestionModel question;
  final VoidCallback onDelete;
  final ValueChanged<QuestionType> onTypeChanged;
  final ValueChanged<int> onPointsChanged;
  final ValueChanged<String> onUpdateQuestionTitle;
  final OnAnswerTitleChanged onUpdateAnswerTitle;

  const AssessmentQuestionEditorItem({
    super.key,
    required this.question,
    required this.onDelete,
    required this.onTypeChanged,
    required this.onPointsChanged,
    required this.onUpdateQuestionTitle,
    required this.onUpdateAnswerTitle,
  });

  @override
  State<AssessmentQuestionEditorItem> createState() => _AssessmentQuestionEditorItemState();
}

class _AssessmentQuestionEditorItemState extends State<AssessmentQuestionEditorItem> {
  final AssessmentEditorController _controller = Get.find<AssessmentEditorController>();

  late TextEditingController _pointsController;
  late TextEditingController _questionController;
  late TextEditingController _typeController;

  @override
  void initState() {
    super.initState();

    _pointsController = TextEditingController(text: widget.question.points.toString());
    _questionController = TextEditingController(text: widget.question.question);
    _typeController = TextEditingController(text: widget.question.type.value.toString());

    _pointsController.addListener(() {
      if (_pointsController.text.isNotEmpty) {
        final points = int.tryParse(_pointsController.text) ?? 0;
        widget.onPointsChanged(points);
      }
    });

    _questionController.addListener(() {
      if (_questionController.text.isNotEmpty) {
        widget.onUpdateQuestionTitle(_questionController.text);
      }
    });
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _questionController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final QuestionType currentType = widget.question.type;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: InputText(
              label: 'Pontos',
              controller: _pointsController,
              keyboardType: TextInputType.number,
              validator: (string) => PValidator([
                PRuleNumeric(string, message: 'Número inválido'.tlt),
              ]).val(),
            ),
          ),
          Insets.medium.height,
          Row(
            children: [
              Expanded(
                child: InputText(label: 'Título da Questão', controller: _questionController),
              ),
              IconButton(icon: const Icon(Icons.remove, color: Colors.red), onPressed: widget.onDelete),
            ],
          ),
          Insets.medium.height,
          InputSelect(
            label: 'Tipo de Questão',
            controller: _typeController,
            showClearButton: false,
            itens: Map.fromEntries(
              QuestionType.values.map((q) => MapEntry(q.value.toString(), q.description)),
            ),
            onChange: (value) {
              final type = QuestionType.values.firstWhere((e) => e.value.toString() == value);
              widget.onTypeChanged(type);
            },
          ),
          if (currentType == QuestionType.objective) ...[
            Insets.medium.height,
            Text('Opções de Resposta', style: primaryTextStyle(size: 14)),
            Insets.small.height,
            ...List.generate(widget.question.availableAnswers?.length ?? 0, (idx) {
              final answer = widget.question.availableAnswers![idx];
              final controller = _controller.answerControllers[widget.question.localId]?[answer.localId];

              controller?.addListener(() {
                if (controller.text.isNotEmpty) {
                  widget.onUpdateAnswerTitle(widget.question, widget.question.availableAnswers![idx], controller.text);
                }
              });
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: InputText(
                        label: 'Opção ${idx + 1}',
                        controller: controller!,
                        validator: (string) => PValidator([
                          PRuleRequired(string, message: 'Obrigatório'.tlt),
                        ]).val(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        _controller.removeAnswer(widget.question, widget.question.availableAnswers![idx]);
                      },
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              width: double.infinity,
              child: ActionButton(
                theme: ActionButtonTheme.lightGrey,
                title: 'Adicionar Opção',
                onPressed: () {
                  _controller.addAnswer(widget.question);
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}
