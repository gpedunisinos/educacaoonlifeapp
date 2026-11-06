import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/services/participant_chat/participant_chat_service.dart';
import 'package:unisinos_usp_app/widgets/participant_chat_panel.dart';

void main() {
  testWidgets('opens chat from a button outside the navigator', (tester) async {
    final service = Get.put(ParticipantChatService());
    addTearDown(Get.reset);

    await tester.pumpWidget(
      GetMaterialApp(
        home: const Scaffold(),
        builder: (context, child) => Overlay.wrap(
          child: Stack(children: [child!, const ParticipantChatButton()]),
        ),
      ),
    );
    await tester.tap(find.byTooltip('Conversas entre participantes'));
    await tester.pumpAndSettle();

    expect(find.byType(ParticipantChatPanel), findsOneWidget);
    expect(tester.takeException(), isNull);

    service.active.value = ParticipantConversation.fromJson({
      'id': 'conversation',
      'name': 'Participante',
      'activity': '',
    });
    await tester.pump();
    await tester.tap(find.byTooltip('Bloquear conversa'));
    await tester.pumpAndSettle();
    expect(find.text('Bloquear conversa?'), findsOneWidget);
  });
}
