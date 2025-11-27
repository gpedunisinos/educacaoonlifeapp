import 'package:unisinos_usp_app/controllers/category_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/models/trail_model.dart';
import 'package:unisinos_usp_app/widgets/banner_carroussel.dart';
import 'package:unisinos_usp_app/widgets/card_slider.dart';
import 'package:unisinos_usp_app/widgets/trail_card_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class StudentHomeScreen extends StatelessWidget {
  final CategoryController _controller = Get.find<CategoryController>();

  StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                final banners = _controller.getRandomBanners();

                return banners.isEmpty
                    ? Container(
                        width: double.infinity,
                        height: 280,
                        color: Colors.grey[300],
                        child: Icon(Icons.image_not_supported, size: 42, color: Colors.grey[600]),
                      )
                    : BannerCarousel(
                        banners: banners,
                      );
              }),
              Insets.large.height,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Obx(() {
                  List<CategoryModel> categories = _controller.categories;

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      CategoryModel category = categories[index];
                      List<TrailModel>? trails = category.trails;

                      if (trails == null || trails.isEmpty) {
                        return SizedBox.shrink();
                      }

                      return Column(
                        children: [
                          CardSlider(
                            height: 310,
                            title: category.name,
                            items: trails.map((trail) {
                              return CardModel(
                                id: trail.id,
                                title: trail.name,
                                subtitle: trail.description ?? '',
                                image: trail.coverImageFile,
                              );
                            }).toList(),
                            buttonBuilder: (item) =>
                                TrailCardButton(item: item, title: 'Ver Trilha', onTap: () => Get.toNamed('/trail_details/${item.id}')),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed('/trails/${category.id}', arguments: category),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 0, 24),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Ver mais',
                                  style: secondaryTextStyle(weight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
