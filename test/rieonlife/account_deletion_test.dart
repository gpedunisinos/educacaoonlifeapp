import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';
import 'package:unisinos_usp_app/screens/space/space_account_panel.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';

class _Api extends UserWebclient {
  bool fail = false;
  int? deletedId;
  @override
  Future<void> deleteOwnAccount(int id) async {
    deletedId = id;
    if (fail) throw Exception('server error');
  }
}

class _SessionUser extends UserController {
  bool loggedOut = false;
  @override
  Future<void> logout() async => loggedOut = true;
}

class _User extends UserController {
  int requests = 0;
  bool fail = false;

  @override
  // The real initializer requires persistent storage and network services.
  // ignore: must_call_super
  void onInit() {}

  @override
  Future<void> deleteOwnAccount() async {
    requests++;
    if (fail) throw Exception('server error');
  }
}

void main() {
  test('ends the session only after the server confirms deletion', () async {
    final api = _Api()..fail = true;
    final user = _SessionUser()..webclient = api;
    user.user.value = const AuthUser(
      id: 1,
      name: 'Pessoa',
      email: 'test@example.test',
      token: 'session',
    );
    await expectLater(user.deleteOwnAccount(), throwsException);
    expect(user.loggedOut, isFalse);
    api.fail = false;
    await user.deleteOwnAccount();
    expect(api.deletedId, 1);
    expect(user.loggedOut, isTrue);
  });

  testWidgets('requires confirmation and reports deletion failures', (
    tester,
  ) async {
    final user = Get.put<UserController>(_User()) as _User;
    addTearDown(Get.reset);
    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: SpaceAccountPanel())),
    );
    await tester.tap(find.text('Excluir minha conta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(user.requests, 0);

    user.fail = true;
    await tester.tap(find.text('Excluir minha conta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir conta'));
    await tester.pumpAndSettle();
    expect(user.requests, 1);
    expect(
      find.text('Não foi possível excluir sua conta. Tente novamente.'),
      findsOneWidget,
    );
  });
}
