import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/controllers/node_graph/node_graph_controller.dart';
import 'package:unisinos_usp_app/models/node_model.dart';
import 'package:unisinos_usp_app/models/node_link_model.dart';
import 'package:unisinos_usp_app/models/node_type_model.dart';
import 'package:unisinos_usp_app/screens/node_graph/node_graph_screen.dart';
import 'package:unisinos_usp_app/services/ai_assistant_context_service.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/locker_service.dart';

class RoomGraph extends NodeGraphController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class RoomUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

void main() {
  late RoomGraph graph;
  setUp(() {
    Get.testMode = true;
    Get.put<UserController>(RoomUser()).user.value = const AuthUser(
      id: 1,
      name: 'Teste',
      email: 'test@example.com',
      token: 'test',
      profile: 10,
      usageMode: 'explorer',
    );
    Get.put(AiAssistantContextService());
    Get.put(LockerService());
    graph = RoomGraph();
    Get.put<NodeGraphController>(graph);
    final type = NodeTypeModel(id: 1, name: 'Ambiental', color: '#8EDBCB');
    graph.nodeTypes.add(type);
    graph.selectedTypeIds.add(1);
    for (var i = 1; i <= 3; i++) {
      graph.graphNodes.add(
        NodeGraphNodeState(
          node: NodeModel(
            id: i,
            name: ['Água', 'Floresta', 'Cidade'][i - 1],
            color: '#8EDBCB',
            nodeTypeId: 1,
            nodeType: type,
          ),
          position: Offset((i - 2) * 150, 0),
          degree: i == 3 ? 0 : 1,
        ),
      );
    }
    graph.graphLinks.add(
      NodeLinkModel(id: 1, sourceNodeId: 1, targetNodeId: 2),
    );
  });
  tearDown(Get.reset);
  test(
    'search composes with type and degree filters without losing positions',
    () {
      graph.selectedNodeId.value = 1;
      graph.updateSearch(' FLORESTA ');
      expect(graph.visibleNodes.map((n) => n.node.id), [2]);
      expect(graph.selectedNodeId.value, isNull);
      expect(graph.visibleLinks, isEmpty);
      graph.updateSearch('');
      expect(graph.visibleLinks.length, 1);
      expect(graph.graphNodes.first.position, const Offset(-150, 0));
      graph.updateMinimumDegree(1);
      expect(graph.visibleNodes.length, 2);
      graph.toggleType(1, false);
      expect(graph.visibleNodes, isEmpty);
    },
  );
  for (final size in [
    const Size(1440, 900),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    testWidgets('selection, search and zoom remain usable at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const GetMaterialApp(home: NodeGraphScreen()));
      await tester.pumpAndSettle();
      expect(find.text('SALA DE PROBLEMÁTICAS'), findsOneWidget);
      final matrix = tester
          .widget<InteractiveViewer>(find.byType(InteractiveViewer))
          .transformationController!;
      final before = matrix.value.getMaxScaleOnAxis();
      await tester.tap(find.byTooltip('Ampliar'));
      await tester.pumpAndSettle();
      expect(matrix.value.getMaxScaleOnAxis(), greaterThan(before));
      graph.selectNode(1);
      await tester.pumpAndSettle();
      expect(find.text('1 conexões'), findsOneWidget);
      final graphRect = tester.getRect(find.byType(InteractiveViewer));
      expect(graphRect.width, greaterThan(size.width * .9));
      if (size.width >= 1000) {
        expect(
          tester.getRect(find.text('1 conexões')).bottom,
          lessThan(graphRect.top),
        );
        expect(
          tester.getRect(find.byType(TextField)).right,
          lessThan(tester.getRect(find.text('1 conexões')).left),
        );
      }

      expect(
        tester
            .widget<OutlinedButton>(
              find.widgetWithText(OutlinedButton, 'Conectar'),
            )
            .onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), 'Floresta');
      await tester.pumpAndSettle();
      expect(graph.visibleNodes.single.node.id, 2);
      expect(graph.selectedNodeId.value, isNull);
      expect(tester.takeException(), isNull);
    });
  }
}
