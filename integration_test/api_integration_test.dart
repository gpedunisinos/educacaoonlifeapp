import 'dart:convert';

import 'package:unisinos_usp_app/main.dart' as app;
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets_spo/widgets_spo.dart';

void main() {
  /*************** CAUTION ****************/
  /*  DON'T TESTS CREATE, STORE, UPDATE,  */
  /*  DESTROY or other functions that can */
  /*  change data. RISK OF DEATH!         */
  /*  This is a real API integration!     */
  /****************************************/

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<UserModel> _apiLogin() async {
    String? userPref = Util.prefs.getString('user');

    if (userPref != null) {
      UserModel localUser = UserModel.fromJson(jsonDecode(userPref));
      return localUser;
    }

    UserWebclient webClient = UserWebclient();
    UserModel user = await webClient.login(mail: 'aluno@efv.com.br', password: 'efv@164962');
    SharedPreferences.setMockInitialValues({'user': jsonEncode(user.toJson())});
    return user;
  }

  testWidgets(
    'user api tests',
    (WidgetTester tester) async {
      app.main();

      await tester.pumpAndSettle();
      await _apiLogin();

      UserWebclient webClient = UserWebclient();

      //check index
      var models = await webClient.fetchUsers(limit: 25, offset: 0);
      expect(
        models,
        isInstanceOf<List<UserModel>>(),
        reason: "index not return a correct data",
      );
    },
  );
}
