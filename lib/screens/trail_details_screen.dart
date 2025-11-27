import 'package:unisinos_usp_app/controllers/trail_details_controller.dart';
import 'package:unisinos_usp_app/controllers/user_controller.dart';
import 'package:unisinos_usp_app/models/assessment_completion_model.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/utils/trail_options.dart';
import 'package:unisinos_usp_app/widgets/action_button.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailDetailsScreen extends StatelessWidget {
  final TrailDetailsController _controller = Get.find<TrailDetailsController>();
  final UserController _userController = Get.find<UserController>();

  TrailDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Detalhes da Trilha',
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
          final trail = _controller.trailDetails.value;
          var _ = _controller.assessments;

          final bool isTrailStarted = trail?.userTrails?.first.status == UserTrailStatusEnum.inProgress;

          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (trail == null) {
            return Center(child: Text('Houve um erro ao carregar a Trilha.'));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Insets.medium.height,
                      ImageWidget(image: trail.coverImageFile, width: double.infinity, height: 220),
                      Container(
                        padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trail.name,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Insets.small.height,
                            Text(trail.description ?? '', style: secondaryTextStyle(size: 16)),
                            Insets.medium.height,
                            Text(
                              'Tempo de expiração da trilha: ${TrailOptions.trailTimeOptions[trail.expirationTime] ?? 'n/d'}',
                              style: primaryTextStyle(weight: FontWeight.bold),
                            ),
                            if (_userController.user.value!.isStudent && trail.userTrails!.first.expiresAt != null) ...[
                              Text(
                                'Expira em: ${trail.userTrails!.first.expiresAt!.format('dd/MM/yyyy')}',
                                style: primaryTextStyle(weight: FontWeight.bold),
                              ),
                            ],
                            Insets.extraLarge.height,
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Aulas', style: primaryTextStyle(size: 20, weight: FontWeight.w500, color: Colors.black)),
                      ),
                      Insets.small.height,
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        itemCount: trail.classes?.length ?? 0,
                        separatorBuilder: (context, index) => Insets.small.height,
                        itemBuilder: (context, index) {
                          final ClassModel clas = trail.classes![index];
                          return Obx(() {
                            if (_controller.isLoading.value) {
                              return CircularProgressIndicator();
                            }
                            return classCard(clas, trail);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_userController.user.value!.isStudent && trail.trailStatus != UserTrailStatusEnum.completed)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ActionButton(
                          theme: ActionButtonTheme.grey,
                          title: isTrailStarted ? 'Continuar Trilha' : 'Iniciar Trilha',
                          onPressed: () async {
                            if (isTrailStarted) {
                              final classes = trail.classes ?? [];
                              final ClassModel? nextClass = classes.firstWhereOrNull((c) => c.isCompleted == false);

                              if (nextClass == null) {
                                Get.customSnackbar('Trilha Concluída', 'Você já completou todas as aulas desta trilha!');
                                return;
                              }

                              final int currentIndex = classes.indexOf(nextClass);
                              if (currentIndex > 0) {
                                final previousClass = classes[currentIndex - 1];
                                if (previousClass.hasAssessment! == true && previousClass.assessment != null) {
                                  final approved = _controller.isAssessmentApproved(previousClass.assessment!.id);
                                  if (!approved) {
                                    Get.customSnackbar(
                                      'Atenção',
                                      'Você precisa ser aprovado na avaliação da aula anterior antes de continuar.',
                                    );
                                    return;
                                  }
                                }
                              }

                              Get.toNamed('/class_details/${nextClass.id}', arguments: nextClass);
                            } else {
                              await _controller.startTrail(trail.id);
                              await _controller.fetchById(trail.id);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              Insets.large.height,
            ],
          );
        }),
      ),
    );
  }

  Future<bool> validateIfPreviousIsConcluded(ClassModel clas, TrailModel trail) async {
    // if not student, can access freely
    if (!_userController.user.value!.isStudent) {
      return true;
    }

    if (clas.isCompleted!) {
      return true;
    }

    // if the trail is not started
    if (trail.trailStatus != UserTrailStatusEnum.inProgress) {
      Get.customSnackbar('Aviso', 'Você precisa iniciar a Trilha primeiro.');
      return false;
    }

    final ClassModel? nextClass = trail.classes?.firstWhereOrNull((c) => c.isCompleted == false);

    // if is not the next class
    if (clas.id != nextClass?.id) {
      Get.customSnackbar('Aviso', 'Você precisa concluir as aulas anteriores primeiro.');
      return false;
    }

    // if the class before theres an assessment
    final int currentIndex = trail.classes!.indexOf(clas);
    if (currentIndex > 0) {
      final previousClass = trail.classes![currentIndex - 1];
      if (previousClass.hasAssessment! == true) {
        final assessment = previousClass.assessment;
        if (assessment != null) {
          final approved = _controller.isAssessmentApproved(assessment.id);
          if (!approved) {
            Get.customSnackbar('Aviso', 'A avaliação anterior precisa ser aprovada antes de continuar.');
            return false;
          }
        }
      }
    }

    return true;
  }

  Widget classCard(ClassModel clas, TrailModel trail) {
    AssessmentCompletionStatusEnum? assessmentStatus;
    if (clas.hasAssessment!) {
      assessmentStatus = _controller.getAssesmentStatus(clas.assessment!.id);
    }

    Color? borderColor;
    Color? backgroundColor;
    IconData? icon;
    Color? iconColor;

    if (clas.isCompleted! && assessmentStatus == AssessmentCompletionStatusEnum.approved) {
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green.withOpacity(0.4);
      icon = Icons.check;
      iconColor = Colors.green;
    } else if (clas.isCompleted! && assessmentStatus == AssessmentCompletionStatusEnum.waitingCorrection) {
      backgroundColor = Colors.amber.withOpacity(0.1);
      borderColor = Colors.amber.withOpacity(0.4);
      icon = Icons.hourglass_bottom;
      iconColor = Colors.amber.shade700;
    } else if (clas.isCompleted! && assessmentStatus == AssessmentCompletionStatusEnum.repproved) {
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red.withOpacity(0.4);
      icon = Icons.cancel;
      iconColor = Colors.red;
    }

    return InkWell(
      onTap: () async {
        if (await validateIfPreviousIsConcluded(clas, trail)) {
          Get.toNamed('/class_details/${clas.id}', arguments: clas);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            if (icon != null)
              Container(
                decoration: BoxDecoration(
                  color: iconColor!.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: Icon(icon, color: iconColor, size: 20),
              ),
            Insets.medium.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clas.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    clas.description,
                    style: secondaryTextStyle(size: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (clas.isCompleted! && assessmentStatus == AssessmentCompletionStatusEnum.waitingCorrection) ...[
                    Insets.small.height,
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        'Avaliação enviada! Aguarde a correção para avançar.',
                        style: secondaryTextStyle(size: 12, color: Colors.amber.shade900),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
