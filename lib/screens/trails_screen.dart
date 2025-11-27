import 'package:unisinos_usp_app/controllers/trail_list_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/widgets/card_slider.dart';
import 'package:unisinos_usp_app/widgets/trail_card_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class TrailsScreen extends StatelessWidget {
  final TrailListController _controller = Get.find<TrailListController>();
  final CategoryModel category = Get.arguments;

  TrailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Trilhas',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name!,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Obx(() {
                List<TrailModel> trails = _controller.trailsList;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, _) => Insets.large.height,
                  itemCount: trails.length,
                  itemBuilder: (context, index) {
                    TrailModel trail = trails[index];
                    return ContentCard(
                      height: 300,
                      item: CardModel(
                        id: trail.id,
                        title: trail.name,
                        subtitle: '${trail.classes?.length ?? 0} aulas - ${trail.getClassesDuration} duração',
                        image: trail.coverImageFile,
                      ),
                      buttonBuilder: (item) => TrailCardButton(
                        item: item,
                        title: 'Ver Trilha',
                        onTap: () {
                          Get.toNamed('/trail_details/${item.id}');
                        },
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
