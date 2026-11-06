import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/clue_connection/clue_connection_create_controller.dart';
import 'package:unisinos_usp_app/models/clue_connection_model.dart';
import 'package:unisinos_usp_app/models/living_clue_model.dart';
import 'package:unisinos_usp_app/screens/living_clue/living_clue_connect_screen.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';

class Links extends ClueConnectionCreateController {
  int saves = 0;
  @override
  Future<bool> save(ClueConnectionModel model) async {
    saves++;
    return true;
  }
}

void main() {
  for (final width in [390.0, 1280.0]) {
    testWidgets(
      'link form preserves source, validates required fields and fits $width',
      (tester) async {
        Get.testMode = true;
        final links = Links();
        Get.put<ClueConnectionCreateController>(links);
        Get.put(AiAssistantContextService());
        addTearDown(Get.reset);
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(
          GetMaterialApp(
            home: Scaffold(
              body: TextButton(
                onPressed: () => Get.toNamed(
                  '/link',
                  arguments: LivingClueModel(
                    id: 1,
                    name: 'Pista de origem preservada',
                    categoryId: 1,
                  ),
                ),
                child: const Text('Vincular'),
              ),
            ),
            getPages: [
              GetPage(
                name: '/link',
                page: () => const LivingClueConnectScreen(),
              ),
            ],
          ),
        );
        await tester.tap(find.text('Vincular'));
        await tester.pumpAndSettle();
        expect(find.byType(SpaceConversationRoom), findsOneWidget);
        expect(find.text('Pista de origem preservada'), findsOneWidget);
        await tester.ensureVisible(find.text('Salvar conexão'));
        await tester.tap(find.text('Salvar conexão'));
        await tester.pumpAndSettle();
        expect(links.saves, 0);
        expect(find.text('Obrigatório'), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
