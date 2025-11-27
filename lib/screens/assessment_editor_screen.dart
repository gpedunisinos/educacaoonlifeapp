import 'package:unisinos_usp_app/controllers/assessment_editor_controller.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/assessment_question_editor_item.dart';
import 'package:unisinos_usp_app/widgets/input_duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pvalidator/pvalidator.dart';
import 'package:widgets_spo/widgets_spo.dart';

class AssessmentEditorScreen extends StatefulWidget {
  const AssessmentEditorScreen({super.key});

  @override
  State<AssessmentEditorScreen> createState() => _AssessmentEditorScreenState();
}

class _AssessmentEditorScreenState extends State<AssessmentEditorScreen> {
  final AssessmentEditorController _controller = Get.find<AssessmentEditorController>();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Gerenciar Prova',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.secureBack(),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Insets.medium.height,
                Obx(() {
                  return InputText(
                    label: 'Título',
                    controller: _controller.titleController.value!,
                    validator: (string) => PValidator([
                      PRuleRequired(string, message: 'Obrigatório'.tlt),
                    ]).val(),
                  );
                }),
                Insets.medium.height,
                Obx(() {
                  return InputSelect(
                    label: 'Tipo de Prova',
                    itens: Map.fromEntries(
                      AssessmentTypeEnum.values.map((e) => MapEntry(e.value.toString(), e.description)),
                    ),
                    controller: _controller.typeController.value!,
                    onChange: (value) {
                      if (value != null) {
                        final type = AssessmentTypeEnum.fromValue(value.toInt());
                        _controller.typeController.value!.text = type!.value.toString();
                      }
                    },
                  );
                }),
                Insets.medium.height,
                Obx(() {
                  var value = _controller.limitExecutionTimeController.value;
                  return InputDurationPicker(
                    key: ValueKey(_controller.assessment.value?.hashCode ?? UniqueKey()),
                    label: 'Tempo de execução',
                    initialMinutes: value,
                    onChanged: (totalMinutes) {
                      _controller.limitExecutionTimeController.value = totalMinutes;
                    },
                  );
                }),
                Insets.medium.height,
                Obx(() {
                  return InputQuill(
                    label: 'Instruções',
                    controller: _controller.descriptionController.value!,
                    validator: (string) {
                      return PValidator([
                        PRuleRequired(string, message: 'Obrigatório'.tlt),
                      ]).val();
                    },
                  );
                }),
                Insets.large.height,
                Text(
                  'Questões',
                  style: primaryTextStyle(size: 20, weight: FontWeight.bold),
                ),
                Obx(() {
                  final questions = _controller.assessment.value?.questions ?? [];

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => Insets.large.height,
                    itemBuilder: (_, index) {
                      final question = questions[index];

                      return AssessmentQuestionEditorItem(
                          key: ValueKey(question.id),
                          question: question,
                          onDelete: () {
                            _controller.removeQuestion(question);
                            _controller.assessment.refresh();
                          },
                          onTypeChanged: (value) {
                            final type = QuestionType.values.firstWhere((e) => e == value);
                            _controller.updateQuestionType(question, type);
                            _controller.assessment.refresh();
                          },
                          onPointsChanged: (points) {
                            _controller.updateQuestionPoints(question, points);
                            _controller.assessment.refresh();
                          },
                          onUpdateQuestionTitle: (title) {
                            _controller.updateQuestionTitle(question, title);
                            _controller.assessment.refresh();
                          },
                          onUpdateAnswerTitle: (question, answer, title) {
                            _controller.updateAnswerTitle(question: question, answer: answer, newTitle: title);
                            _controller.assessment.refresh();
                          });
                    },
                  );
                }),
                Insets.small.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    foregroundColor: const Color(0xFFf2f2f2),
                    backgroundColor: const Color(0xffcadcfc),
                    mini: true,
                    onPressed: () {
                      _controller.addQuestion();
                      _controller.assessment.refresh();
                    },
                    child: const Icon(Icons.add),
                  ),
                ),
                Insets.extraLarge.height,
                SizedBox(
                  width: double.infinity,
                  child: ActionButton(
                    theme: ActionButtonTheme.blue,
                    title: 'Concluir',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _doSave();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _doSave() async {
    if (await _controller.doSave()) {
      Get.secureBack();
    }
  }
}
