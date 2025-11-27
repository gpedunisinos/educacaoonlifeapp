import 'dart:convert';

import 'package:unisinos_usp_app/models/assessment_available_answer_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/webclients/assessment_available_answer_webclient.dart';
import 'package:unisinos_usp_app/webclients/assessment_question_webclient.dart';
import 'package:unisinos_usp_app/webclients/assessment_webclient.dart';
import 'package:unisinos_usp_app/webclients/class_webclient.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';

class AssessmentEditorController extends GetxController {
  final AssessmentWebclient webclient = AssessmentWebclient();
  final AssessmentQuestionWebclient questionWebclient = AssessmentQuestionWebclient();
  final AssessmentAvailableAnswerWebclient answerWebclient = AssessmentAvailableAnswerWebclient();

  final Rxn<AssessmentModel> assessment = Rxn<AssessmentModel>();
  final Rxn<AssessmentModel> initialAssessment = Rxn<AssessmentModel>();

  final Rxn<TextEditingController> titleController = Rxn<TextEditingController>(TextEditingController());
  final Rxn<QuillController> descriptionController = Rxn<QuillController>(QuillController.basic());
  final Rxn<TextEditingController> typeController = Rxn<TextEditingController>(TextEditingController());
  final RxInt limitExecutionTimeController = RxInt(0);

  final Map<String, Map<String, TextEditingController>> answerControllers = {};

  final RxBool isLoading = false.obs;

  final Uuid _uuid = Uuid();

  @override
  void dispose() {
    titleController.value?.dispose();
    descriptionController.value?.dispose();
    typeController.value?.dispose();

    for (final questionEntry in answerControllers.values) {
      for (final answerController in questionEntry.values) {
        answerController.dispose();
      }
    }

    answerControllers.clear();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    final classId = Get.parameters['id'];

    final ClassModel? c = Get.arguments?['class'];
    if (c == null) {
      ClassWebclient().fetchById(classId!.toInt()).then((c) {
        if (c.hasAssessment != null && c.hasAssessment! != false) {
          loadFromAssessmentId(c);
        }
      });
    }

    if (c != null && c.hasAssessment != null && c.hasAssessment! != false) {
      loadFromAssessmentId(c);
    } else {
      assessment.value = AssessmentModel(id: 0, name: '', description: '', classId: c?.id ?? classId!.toInt());
    }
  }

  void loadFromAssessmentId(ClassModel c) {
    webclient.fetchById(c.assessment!.id).then((value) {
      initialAssessment.value = value;
      assessment.value = value;

      titleController.value!.text = assessment.value?.name ?? '';
      if (assessment.value?.description != null && assessment.value!.description.isNotEmpty) {
        final json = jsonDecode(assessment.value!.description) as List<dynamic>;
        descriptionController.value!.document = Document.fromJson(json);
      } else {
        descriptionController.value!.document = Document()..insert(0, '');
      }

      final type = AssessmentTypeEnum.fromValue(assessment.value!.type!.value);
      typeController.value!.text = type!.value.toString();
      limitExecutionTimeController.value = assessment.value!.limitExecutionTime ?? 0;

      final questions = assessment.value?.questions;
      if (questions != null) {
        final updatedQuestions = questions.map((question) {
          final updatedAnswers = question.availableAnswers?.map((answer) {
            return answer.copyWith(localId: _uuid.v4());
          }).toList();

          return question.copyWith(
            localId: _uuid.v4(),
            availableAnswers: updatedAnswers,
          );
        }).toList();

        assessment.value = assessment.value!.copyWith(questions: updatedQuestions);

        for (final question in updatedQuestions) {
          addControllerInAnswer(question);
        }
      }
    });
  }

  int calculateTotalPoints() {
    final points = assessment.value?.questions?.fold(0, (sum, question) {
          return sum + (question.points);
        }) ??
        0;

    return points;
  }

  Future<bool> doSave() async {
    if (calculateTotalPoints() > 10) {
      Get.customSnackbar('Erro', 'A pontuação total das questões não pode ser maior que 10.');
      return false;
    }

    if (limitExecutionTimeController.value == 0) {
      Get.customSnackbar('Erro', 'Deve ser definido um tempo de execução para a Prova.');
      return false;
    }

    final updatedQuestions = assessment.value?.questions?.map((q) {
      final questionControllers = answerControllers[q.localId];

      if (questionControllers == null) return q;

      final updatedAnswers = q.availableAnswers?.map((a) {
        final controller = questionControllers[a.localId];
        return a.copyWith(title: controller?.text ?? a.title);
      }).toList();

      return q.copyWith(availableAnswers: updatedAnswers);
    }).toList();

    if (updatedQuestions != null && updatedQuestions.any((q) => q.points == 0)) {
      Get.customSnackbar(
        'Erro',
        'Todas as questões devem ter pontuação maior que zero.',
      );

      return false;
    }

    this.assessment.value = assessment.value!.copyWith(
      name: titleController.value!.text,
      description: jsonEncode(descriptionController.value!.document.toDelta().toJson()),
      type: AssessmentTypeEnum.fromValue(typeController.value!.text.toInt()),
      limitExecutionTime: limitExecutionTimeController.value,
      questions: updatedQuestions,
    );

    if (assessment.value!.id == 0) {
      return _add(assessment.value!);
    } else {
      return _updateAssessment(assessment.value!);
    }
  }

  Future<bool> _add(AssessmentModel assessment) async {
    isLoading.value = true;
    try {
      // 1. Salva a prova e obtém o ID
      final createdAssessment = await webclient.add(assessment);

      // 2. Salva as questões em cascata
      final List<AssessmentQuestionModel> savedQuestions = [];
      for (var question in assessment.questions ?? []) {
        final newQuestion = question.copyWith(assessmentId: createdAssessment.id);
        final createdQuestion = await questionWebclient.add(newQuestion);

        // 3. Salva as respostas (se houver) com o ID da questão
        final List<AssessmentAvailableAnswersModel> savedAnswers = [];
        if (newQuestion.availableAnswers != null) {
          for (var answer in newQuestion.availableAnswers!) {
            final newAnswer = answer.copyWith(questionId: createdQuestion.id);
            final createdAnswer = await answerWebclient.add(newAnswer);
            savedAnswers.add(createdAnswer);
          }
        }
        var questionWithAnswersCopy = createdQuestion.copyWith(availableAnswers: savedAnswers);
        savedQuestions.add(questionWithAnswersCopy);
        _handleAnswers(null, questionWithAnswersCopy);
      }

      this.assessment.value = createdAssessment.copyWith(questions: savedQuestions);
      Get.successSnackbar('Prova adicionada com sucesso!');
      return true;
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao adicionar Prova. $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _updateAssessment(AssessmentModel current) async {
    isLoading.value = true;
    try {
      // Passo 1: Atualiza a prova principal
      final updatedAssessment = await webclient.update(current);

      // Passo 2: Gerencia as questões (exclui, adiciona, atualiza)
      final initialQuestions = initialAssessment.value!.questions ?? [];
      final currentQuestions = current.questions ?? [];

      // Encontre as questões excluídas
      final questionsToDelete = initialQuestions.where((initialQ) => !currentQuestions.any((currentQ) => currentQ.id == initialQ.id));
      for (var question in questionsToDelete) {
        await questionWebclient.delete(question.id);
      }

      // Encontre as questões para adicionar ou atualizar
      for (var question in currentQuestions) {
        if (question.id == 0) {
          // Nova questão: adiciona
          final newQuestion = question.copyWith(assessmentId: updatedAssessment.id);
          final createdQuestion = await questionWebclient.add(newQuestion);

          // Gerencia as respostas da nova questão
          await _handleAnswers(null, newQuestion.copyWith(id: createdQuestion.id));
        } else {
          // Questão existente: atualiza
          final existingInitialQuestion = initialQuestions.firstWhereOrNull((q) => q.id == question.id);
          final updatedQuestion = await questionWebclient.update(question);

          // Gerencia as respostas da questão atualizada
          await _handleAnswers(existingInitialQuestion, question.copyWith(id: updatedQuestion.id));
        }
      }

      Get.successSnackbar('Prova atualizada com sucesso!');
      return true;
    } catch (e, stackTrace) {
      Util.debug(exception: e, stackTrace: stackTrace);
      Get.customSnackbar('Erro', 'Erro ao atualizar Prova. $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleAnswers(AssessmentQuestionModel? initialQuestion, AssessmentQuestionModel currentQuestion) async {
    final initialAnswers = initialQuestion?.availableAnswers ?? [];
    final currentAnswers = currentQuestion.availableAnswers ?? [];

    // Exclui respostas que foram removidas
    final answersToDelete = initialAnswers.where((initialA) {
      return !currentAnswers.any((currentA) => currentA.id == initialA.id);
    });
    for (var answer in answersToDelete) {
      await answerWebclient.delete(answer.id);
    }

    // Adiciona ou atualiza respostas
    for (var answer in currentAnswers) {
      if (answer.id == 0) {
        // Nova resposta: adiciona
        final newAnswer = answer.copyWith(questionId: currentQuestion.id);
        final Map<String, String?> answerData = {
          'question_id': currentQuestion.id.toString(),
          'title': answer.title,
        };

        await answerWebclient.add(newAnswer, params: answerData);
      } else {
        // Resposta existente: atualiza
        final Map<String, String?> answerData = {
          'question_id': currentQuestion.id.toString(),
          'title': answer.title,
        };

        await answerWebclient.update(answer, params: answerData);
      }
    }
  }

  void updateQuestionTitle(AssessmentQuestionModel question, String newText) {
    final updatedQuestion = question.copyWith(question: newText);
    _updateQuestionInList(question, updatedQuestion);
  }

  void updateQuestionPoints(AssessmentQuestionModel question, int newPoints) {
    final updatedQuestion = question.copyWith(points: newPoints);
    _updateQuestionInList(question, updatedQuestion);
  }

  void updateAnswerTitle({
    required AssessmentQuestionModel question,
    required AssessmentAvailableAnswersModel answer,
    required String newTitle,
  }) {
    final updatedAnswers = question.availableAnswers?.map((a) {
      if (a.localId == answer.localId) {
        return a.copyWith(title: newTitle);
      }
      return a;
    }).toList();

    final updatedQuestion = question.copyWith(availableAnswers: updatedAnswers);
    _updateQuestionInList(question, updatedQuestion);
  }

  void addAnswer(AssessmentQuestionModel question) {
    final newAnswer = AssessmentAvailableAnswersModel(id: 0, title: '', questionId: question.id, localId: _uuid.v4());
    final updatedAnswers = List<AssessmentAvailableAnswersModel>.from(question.availableAnswers ?? [])..add(newAnswer);

    _updateQuestionInList(question, question.copyWith(availableAnswers: updatedAnswers));
    addControllerInAnswer(question.copyWith(availableAnswers: updatedAnswers));
  }

  void removeAnswer(AssessmentQuestionModel question, AssessmentAvailableAnswersModel answer) {
    final updatedAnswers = List<AssessmentAvailableAnswersModel>.from(question.availableAnswers ?? [])..remove(answer);

    _updateQuestionInList(question, question.copyWith(availableAnswers: updatedAnswers));
  }

  void addQuestion() {
    final newQuestion = AssessmentQuestionModel(
      id: 0,
      question: '',
      type: QuestionType.subjective,
      assessmentId: assessment.value?.id,
      points: 0,
      availableAnswers: [],
      localId: _uuid.v4(),
    );

    final currentQuestions = List<AssessmentQuestionModel>.from(assessment.value?.questions ?? []);
    currentQuestions.add(newQuestion);

    assessment.value = assessment.value?.copyWith(questions: currentQuestions);
    addControllerInAnswer(newQuestion);
  }

  void addControllerInAnswer(AssessmentQuestionModel question) {
    if (!answerControllers.containsKey(question.localId)) {
      answerControllers[question.localId!] = {};
    }

    final questionControllers = answerControllers[question.localId]!;

    // Crie novos controladores para novas respostas.
    for (final answer in question.availableAnswers!) {
      if (!questionControllers.containsKey(answer.localId)) {
        questionControllers[answer.localId!] = TextEditingController(text: answer.title);
      }
    }
  }

  void _updateQuestionInList(AssessmentQuestionModel oldQuestion, AssessmentQuestionModel newQuestion) {
    final currentQuestions = assessment.value?.questions ?? [];
    final updatedQuestions = currentQuestions.map((q) {
      if (q.localId == oldQuestion.localId) {
        return newQuestion;
      }
      return q;
    }).toList();
    assessment.value = assessment.value?.copyWith(questions: updatedQuestions);
  }

  void removeQuestion(AssessmentQuestionModel question) {
    final currentQuestions = List<AssessmentQuestionModel>.from(assessment.value?.questions ?? []);
    currentQuestions.remove(question);

    assessment.value = assessment.value?.copyWith(questions: currentQuestions);
  }

  void updateQuestionType(AssessmentQuestionModel question, QuestionType newType) {
    final currentQuestions = List<AssessmentQuestionModel>.from(assessment.value?.questions ?? []);

    final updatedQuestions = currentQuestions.map((q) {
      if (q == question) {
        return q.copyWith(type: newType);
      }
      return q;
    }).toList();

    assessment.value = assessment.value?.copyWith(questions: updatedQuestions);
  }
}
