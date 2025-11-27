import 'package:unisinos_usp_app/controllers/trail_controller.dart';
import 'package:unisinos_usp_app/models/mfile_model.dart';
import 'package:unisinos_usp_app/widgets/grade_card.dart';
import 'package:unisinos_usp_app/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';
import 'package:widgets_spo/widgets/paginated_listview.dart';

class TeacherHomeScreen extends StatelessWidget {
  final TrailController _controller = Get.find<TrailController>();
  final TextEditingController _searchController = TextEditingController();

  TeacherHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff030da7),
          centerTitle: true,
          title: const Text(
            'Menu Professor',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton.outlined(
                  onPressed: () => Get.toNamed('/notifications'),
                  icon: const Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.notifications_none, color: Color(0xff848484), size: 28),
                    ],
                  ),
                ),
              ),
              Insets.small.height,
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Visualização das provas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Insets.medium.height,
              Align(
                child: GestureDetector(
                  onTap: () => Get.toNamed('/pending_assessments'),
                  child: ItemCard(
                    image: MFile(id: 0, extension: 'png', path: 'assets/assessment_list.png'),
                    title: 'Provas pendentes',
                    subtitle: 'Aguardando correção',
                  ),
                ),
              ),
              Insets.small.height,
              Align(
                child: GestureDetector(
                  onTap: () => Get.toNamed('/concluded_assessments'),
                  child: ItemCard(
                    image: MFile(id: 0, extension: 'png', path: 'assets/assessment_list.png'),
                    title: 'Provas concluídas',
                    subtitle: '',
                  ),
                ),
              ),
              Insets.small.height,
              Align(
                child: GestureDetector(
                  onTap: () => Get.toNamed('/assessment_performance'),
                  child: ItemCard(
                    image: MFile(id: 0, extension: 'png', path: 'assets/charts.png'),
                    title: 'Desempenho das Avaliações',
                    subtitle: '',
                  ),
                ),
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
              Expanded(
                child: Obx(() {
                  var trails = _controller.searchedTrails;

                  return PaginatedListView(
                    items: trails,
                    isLoading: _controller.isLoading.value,
                    onFetchMore: (offset) => _controller.fetch(search: _searchController.text, offset: offset),
                    itemBuilder: (context, trail, index) {
                      return GradeCard(
                        image: trail.coverImageFile,
                        title: trail.name,
                        subtitle: trail.description,
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
