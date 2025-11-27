import 'package:unisinos_usp_app/controllers/category_controller.dart';
import 'package:unisinos_usp_app/models/category_model.dart';
import 'package:unisinos_usp_app/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';
import 'package:widgets_spo/widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CategoryController _controller = Get.find<CategoryController>();

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _controller.resetSearched();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Text(
            'Pesquisar',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: InputSearch(
                  hintText: 'Pesquise uma trilha',
                  iconColor: Colors.black87,
                  onSearch: (text) {
                    _searchController.text = text ?? '';
                    _controller.searchCategories(text);
                  },
                ),
              ),
              Insets.extraLarge.height,
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categorias',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Insets.large.height,
              Expanded(
                child: Obx(() {
                  List<CategoryModel> categories = _controller.searchedCategories;

                  return PaginatedSeparatedListView(
                    items: categories,
                    isLoading: _controller.isLoading.value,
                    onFetchMore: (offset) => _controller.fetchCategories(search: _searchController.text, offset: offset),
                    separatorBuilder: (context, _) => Insets.large.height,
                    itemBuilder: (context, category, index) {
                      CategoryModel category = categories[index];

                      return GestureDetector(
                        onTap: () => Get.toNamed('/trails/${category.id}', arguments: category),
                        child: Row(
                          children: [
                            ImageWidget(
                              width: 60,
                              height: 60,
                              image: category.trails?.firstOrNull?.coverImageFile,
                            ),
                            Insets.small.width,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.name!,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${category.trails?.length} aula(s)',
                                  style: secondaryTextStyle(size: 14),
                                ),
                              ],
                            )
                          ],
                        ),
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
