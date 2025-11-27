import 'dart:async';

import 'package:unisinos_usp_app/controllers/controllers.dart';
import 'package:unisinos_usp_app/models/assessment_answer_model.dart';
import 'package:unisinos_usp_app/models/assessment_model.dart';
import 'package:unisinos_usp_app/models/assessment_question_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/assessment_question_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/widgets_spo.dart';

class ClassAssessmentScreen extends StatefulWidget {
  const ClassAssessmentScreen({super.key});

  @override
  _ClassAssessmentScreenState createState() => _ClassAssessmentScreenState();
}

class _ClassAssessmentScreenState extends State<ClassAssessmentScreen> {
  ClassModel? classModel = Get.arguments;

  final AssessmentController _controller = Get.find<AssessmentController>();
  final AssessmentConcludedController _completionController = Get.find<AssessmentConcludedController>();
  final sendFilesController = Get.isRegistered<SendFilesController>() ? Get.find<SendFilesController>() : Get.put(SendFilesController());
  final Map<int, AssessmentAnswer> _answersMap = {};
  final Map<int, TextEditingController> _subjectiveControllers = {};

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _timeIsUp = false;

  @override
  void initState() {
    super.initState();

    _controller.assessment.listen((assessment) {
      if (assessment != null && (assessment.questions?.isNotEmpty ?? false)) {
        classModel = _controller.assessment.value?.classModel;
        _answersMap.clear();
        for (final q in assessment.questions!) {
          _answersMap[q.id] = AssessmentAnswer(questionId: q.id);
        }

        _startTimer(assessment.limitExecutionTime);

        setState(() {});
      }
    });
  }

  void _startTimer(int? minutesLimit) {
    if (minutesLimit != null && minutesLimit > 0) {
      _remainingSeconds = minutesLimit * 60;

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_remainingSeconds <= 0) {
          timer.cancel();
          setState(() {
            _timeIsUp = true;
          });

          _submitAssessment(isAutoSubmit: true);
        } else {
          setState(() {
            _remainingSeconds--;
          });
        }
      });
    }
  }

  String _formatTime(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _subjectiveControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _submitAssessment({bool isAutoSubmit = false}) async {
    if (_timeIsUp && !isAutoSubmit) return;

    final userId = Get.find<UserController>().user.value!.id;
    final questions = _controller.assessment.value?.questions ?? [];

    if (!isAutoSubmit) {
      for (final q in questions) {
        final answer = _answersMap[q.id];

        if ((answer?.answerText?.trim().isEmpty ?? true) && answer?.answerId == null) {
          Get.customSnackbar('Validação', 'Por favor, responda todas as questões antes de enviar.');
          return;
        }
      }
    }

    final List<Map<String, dynamic>> answersPayload = _answersMap.values.map((a) => a.toJson()).toList();

    bool success = await LoadingDialog.showFuture(
        context,
        _completionController.send(
          _controller.assessment.value!,
          userId,
          answers: answersPayload,
          files: _controller.selectedFiles,
        ),
        message: 'Enviando avaliação...');

    if (success) {
      if (!Get.isRegistered<TrailDetailsController>()) {
        Get.toNamed(NavigationObserver.instance.homePath);
        return;
      }

      var trailController = Get.find<TrailDetailsController>();

      final trailId = trailController.trailDetails.value!.id.toString();
      await trailController.fetchById(trailId.toInt());
      await trailController.fetchAssessments();
      final targetRoute = '/trail_details/$trailId';

      bool alreadyInStack = false;
      Get.key.currentState?.popUntil((route) {
        if (route.settings.name == targetRoute) {
          alreadyInStack = true;
        }
        return true;
      });

      if (alreadyInStack) {
        Get.until((route) => route.settings.name == targetRoute);
        Get.secureBack();
      } else {
        Get.offNamedUntil(targetRoute, (route) => route.settings.name == targetRoute || route.isFirst);
        Get.secureBack();
      }
    } else {
      if (!_timeIsUp) {
        _startTimer(_remainingSeconds ~/ 60);
      }
    }
  }

  Future<bool> _showExitConfirmationDialog() async {
    _timer?.cancel();

    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Atenção! Cancelamento da Prova'),
        content: const Text(
          'Se você sair desta tela, sua avaliação será CANCELADA e não poderá ser retomada. Deseja sair?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _startTimer(_remainingSeconds ~/ 60);
              Get.back(result: false);
            },
            child: const Text('Continuar na Prova'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('Sair e Cancelar'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    Color timerColor = _remainingSeconds <= 60 ? Colors.red : Colors.white;

    return SafeArea(
      top: false,
      child: PopScope(
        canPop: _timeIsUp,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          // if the time is over, the navigation is blocked
          if (_timeIsUp) return;

          final shouldExit = await _showExitConfirmationDialog();

          if (shouldExit) {
            _timer?.cancel();
            _submitAssessment(isAutoSubmit: true);
            Get.secureBack();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff030da7),
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Avaliação - ${classModel?.name}',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                if (_timer?.isActive ?? false)
                  Text(
                    'Tempo restante: ${_formatTime(_remainingSeconds)}',
                    style: TextStyle(
                      color: timerColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (_timeIsUp)
                  const Text(
                    'TEMPO ESGOTADO',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Instruções para avaliação', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Insets.small.height,
                      ShowQuill(
                        jsonDelta: _controller.assessment.value?.description ?? '[{"insert": "\\n"}]',
                      ),
                      Insets.extraLarge.height,
                      Obx(() {
                        List<AssessmentQuestionModel>? questions = _controller.assessment.value?.questions ?? [];

                        return ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: questions.length,
                          separatorBuilder: (_, __) => Insets.medium.height,
                          itemBuilder: (_, index) {
                            AssessmentQuestionModel question = questions[index];

                            return assessmentQuestionItem(
                              questionModel: question,
                              onChanged: (value) {
                                if (question.type == QuestionType.subjective) {
                                  _answersMap[question.id]?.answerText = value as String;
                                  _answersMap[question.id]?.answerId = null;
                                } else if (question.type == QuestionType.objective) {
                                  _answersMap[question.id]?.answerId = int.tryParse(value as String);
                                  _answersMap[question.id]?.answerText = null;
                                }
                              },
                            );
                          },
                        );
                      }),
                      Insets.small.height,
                      if (_controller.assessment.value?.type == AssessmentTypeEnum.practical)
                        Align(
                          alignment: Alignment.topRight,
                          child: ActionButton(
                            theme: ActionButtonTheme.lightGrey,
                            title: 'Enviar arquivos',
                            onPressed: () async {
                              sendFilesController.setFiles(_controller.selectedFiles.map((f) => f.copy()).toList());

                              final result = await Get.toNamed<dynamic>(
                                '/send_files/${_controller.assessment.value!.id}',
                              );

                              final List<MFileBase>? files = result as List<MFileBase>?;

                              if (files != null && files.isNotEmpty) {
                                final converted = files.map((f) => MFile.fromBase(f)).toList();
                                _controller.selectedFiles.assignAll(converted);
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: ActionButton(
                  theme: ActionButtonTheme.blue,
                  title: _timeIsUp ? 'Tempo Esgotado' : 'Enviar para avaliação',
                  onPressed: _timeIsUp ? null : _submitAssessment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
