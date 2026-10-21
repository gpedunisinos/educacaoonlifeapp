import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/services/mode_switch_routes.dart';
import 'package:unisinos_usp_app/widgets/mode_aware_page.dart';

class LocalModeUser extends UserController {
  @override
  // ignore: must_call_super
  void onInit() {}
}

class Consultation extends StatefulWidget {
  @override
  State<Consultation> createState() => ConsultationState();
}

class ConsultationState extends State<Consultation> {
  final search = TextEditingController();
  int selection = 0;
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        TextField(controller: search),
        TextButton(
          onPressed: () => setState(() => selection++),
          child: Text('Seleção $selection'),
        ),
        if (Get.find<UserController>().user.value!.canAuthor)
          const Text('Criar pista'),
      ],
    ),
  );
}

void main() {
  test('mode shortcut is limited to consultation routes', () {
    for (final route in [
      '/living_clues/map',
      '/space/research/42',
      '/nodes/graph',
      '/space/agents/1',
    ]) {
      expect(canSwitchModeOnRoute(route), isTrue);
    }
    for (final route in [
      '/living_clues/update?id=1',
      '/living_clues/map/create',
      '/living_clues/type_select',
      '/clue_connections/create',
      '/categories/update',
      '/unknown',
    ]) {
      expect(canSwitchModeOnRoute(route), isFalse);
    }
  });
  testWidgets(
    'mode refresh preserves consultation state, search and selection',
    (tester) async {
      final users = Get.put<UserController>(LocalModeUser());
      users.user.value = const AuthUser(
        id: 1,
        name: 'Teste',
        email: 'test@example.com',
        token: 'test',
        profile: 10,
        usageMode: 'explorer',
      );
      addTearDown(Get.reset);
      await tester.pumpWidget(
        MaterialApp(home: ModeAwarePage(builder: () => Consultation())),
      );
      await tester.enterText(find.byType(TextField), 'água');
      await tester.tap(find.text('Seleção 0'));
      await tester.pump();
      final state = tester.state(find.byType(Consultation));
      users.user.value = AuthUser.fromJson({
        ...users.user.value!.toJson(),
        'usage_mode': 'inventor',
      });
      await tester.pump();
      expect(tester.state(find.byType(Consultation)), same(state));
      expect(find.text('Seleção 1'), findsOneWidget);
      expect(find.text('água'), findsOneWidget);
      expect(find.text('Criar pista'), findsOneWidget);
      users.user.value = AuthUser.fromJson({
        ...users.user.value!.toJson(),
        'usage_mode': 'explorer',
      });
      await tester.pump();
      expect(find.text('Criar pista'), findsNothing);
      expect(find.text('água'), findsOneWidget);
    },
  );
}
