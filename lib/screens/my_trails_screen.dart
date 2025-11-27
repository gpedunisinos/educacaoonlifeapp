import 'package:unisinos_usp_app/controllers/trail_controller.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/models/user_trail_model.dart';
import 'package:unisinos_usp_app/widgets/grade_card.dart';
import 'package:unisinos_usp_app/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';

class MyTrailsScreen extends StatelessWidget {
  final TrailController _controller = Get.find<TrailController>();

  MyTrailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Minhas Trilhas',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  //     child: InputSearch(
                  //       hintText: 'Pesquise uma trilha',
                  //       iconColor: Colors.black87,
                  //       onSearch: (text) {
                  //         _controller.searchTrails(text);
                  //       },
                  //     ),
                  //   ),
                  // ),
                  // Insets.medium.width,
                  IconButton.outlined(
                    onPressed: () => Get.toNamed('/notifications'),
                    icon: const Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.notifications_none, color: Color(0xff848484), size: 28),
                      ],
                    ),
                  )
                ],
              ),
              Insets.small.height,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Certificados',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Insets.small.height,
              ItemCard(
                image: MFile(id: 0, extension: 'png', path: 'assets/certificate.png'),
                title: 'Meus certificados',
                subtitle: 'Trilhas concluídas',
                onClick: () => Get.toNamed('/certificates'),
              ),
              Insets.medium.height,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Avaliações',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Insets.small.height,
              ItemCard(
                image: MFile(id: 0, extension: 'png', path: 'assets/assessment_list.png'),
                title: 'Minhas avaliações',
                subtitle: 'Avaliações concluídas',
                onClick: () => Get.toNamed('/concluded_assessments'),
              ),
              Insets.medium.height,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Aulas Offline',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Insets.small.height,
              ItemCard(
                image: MFile(id: 0, extension: 'png', path: 'assets/offline_class.png'),
                title: 'Assistir aulas offline',
                subtitle: 'Aulas disponíveis',
                onClick: () => Get.toNamed('/class_list_offline'),
              ),
              Insets.medium.height,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Minhas Trilhas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Insets.small.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Em andamento',
                  style: secondaryTextStyle(size: 16, weight: FontWeight.w500),
                ),
              ),
              Insets.small.height,
              Obx(() {
                List<UserTrailModel> userTrails = _controller.userTrails;
                List<UserTrailModel> inProgress = userTrails.where((trail) => trail.status == UserTrailStatusEnum.inProgress).toList();

                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 320,
                  ),
                  child: PaginatedSeparatedListView(
                    items: inProgress,
                    isLoading: _controller.isLoading.value,
                    onFetchMore: (offset) => _controller.fetchUserTrails(offset: offset),
                    separatorBuilder: (context, _) => Insets.small.height,
                    shrinkWrap: true,
                    emptyListWidget: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('Nenhuma Trilha em andamento'),
                      ),
                    ),
                    itemBuilder: (context, trail, index) {
                      final classes = trail.trail?.classes ?? [];

                      double progress = 0;
                      if (classes.isNotEmpty) {
                        int completedCount = classes.where((c) => c.isCompleted ?? false).length;
                        progress = completedCount / classes.length;
                      }

                      return InkWell(
                        onTap: () {
                          Get.toNamed('/trails/${trail.trail!.categoryId}', arguments: trail.trail!.category);
                        },
                        child: GradeCard(
                          image: trail.trail?.coverImageFile,
                          title: trail.trail!.name,
                          subtitle: '${classes.length} aulas',
                          progress: progress,
                        ),
                      );
                    },
                  ),
                );
              }),
              Insets.large.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Concluídas - Aprovadas',
                  style: secondaryTextStyle(size: 16, weight: FontWeight.w500),
                ),
              ),
              Insets.small.height,
              Obx(() {
                List<UserTrailModel> completedTrails =
                    _controller.userTrails.where((trail) => trail.status == UserTrailStatusEnum.completed).toList();

                return ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: PaginatedSeparatedListView(
                    items: completedTrails,
                    isLoading: _controller.isLoading.value,
                    onFetchMore: (offset) => _controller.fetchUserTrails(offset: offset),
                    separatorBuilder: (context, _) => Insets.small.height,
                    shrinkWrap: true,
                    emptyListWidget: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text('Nenhuma Trilha concluída'),
                      ),
                    ),
                    itemBuilder: (context, completed, index) {
                      final classes = completed.trail?.classes ?? [];

                      return GradeCard(
                        image: completed.trail?.coverImageFile,
                        title: completed.trail!.name,
                        subtitle: '${classes.length} aulas',
                        finalGrade: completed.score,
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
