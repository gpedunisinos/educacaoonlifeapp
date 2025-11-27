import 'package:unisinos_usp_app/controllers/module_controller.dart';
import 'package:unisinos_usp_app/models/class_model.dart';
import 'package:unisinos_usp_app/models/module_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:widgets_spo/utils.dart';

class ModuleDetailsScreen extends StatelessWidget {
  final ModuleController _controller = Get.find<ModuleController>();

  final List<ModuleModel> modulesList = Get.arguments['modulesList'];

  ModuleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Obx(() {
            final module = _controller.moduleDetails.value;

            return Text(
              module != null ? 'Módulo ${modulesList.indexOf(module)}' : '',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            );
          }),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Get.secureBack();
            },
          ),
        ),
        body: Obx(() {
          final module = _controller.moduleDetails.value;

          if (_controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (module == null) {
            return Center(child: Text('Houve um erro ao carregar o Módulo.'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Insets.medium.height,
                Image.network(
                  'https://picsum.photos/500/300?random=3',
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.name,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Insets.small.height,
                      Text(module.trail!.description!, style: secondaryTextStyle(size: 16)),
                      Insets.medium.height,
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xff030da7),
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Módulo ${modulesList.indexOf(module) + 1}/${modulesList.length}',
                                    style: TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  Insets.small.height,
                                  Text(
                                    module.trail!.name,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  Insets.small.height,
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff030da7),
                                      foregroundColor: Colors.white,
                                      side: BorderSide(color: Colors.white),
                                    ),
                                    onPressed: () {},
                                    child: Text('Continuar Trilha'),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            CircularPercentIndicator(
                              radius: 43.0,
                              lineWidth: 16.0,
                              percent: 0.75,
                              center: Text('${(0.75 * 100).toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                              progressColor: Colors.white,
                              backgroundColor: Color(0xff434abe),
                            ),
                            Insets.small.width,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Aulas',
                    style: primaryTextStyle(size: 20, weight: FontWeight.bold),
                  ),
                ),
                Insets.small.height,
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  itemCount: module.classes?.length ?? 0,
                  separatorBuilder: (context, index) => Insets.small.height,
                  itemBuilder: (context, index) {
                    final ClassModel c = module.classes![index];

                    return InkWell(
                      onTap: () {
                        Get.toNamed('/class_details/${c.id}', arguments: c);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          Insets.small.width,
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            child: Image.network(
                              'https://picsum.photos/120/80?1',
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Insets.small.width,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name!,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${c.description}',
                                style: secondaryTextStyle(size: 14),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                Insets.large.height,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Próximos Módulos',
                    style: primaryTextStyle(size: 20, weight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: modulesList.length,
                  itemBuilder: (context, index) {
                    final nextModule = modulesList[index];
                    return ListTile(
                      title: Text(nextModule.name, style: const TextStyle(fontSize: 14)),
                      subtitle: Text('${nextModule.classes?.length} aulas concluídas', style: secondaryTextStyle(size: 12)),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black),
                      onTap: () => Get.toNamed(
                        '/module_details/${nextModule.id}',
                        arguments: {'module': nextModule, 'modulesList': modulesList},
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
