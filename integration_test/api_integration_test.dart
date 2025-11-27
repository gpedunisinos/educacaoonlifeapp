import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';
import 'package:unisinos_usp_app/webclients/user_webclient.dart';
import 'package:widgets_spo/widgets_spo.dart';

void main() {
  /*************** CAUTION ****************/
  /*  DON'T TESTS CREATE, STORE, UPDATE,  */
  /*  DESTROY or other functions that can */
  /*  change data. RISK OF DEATH!         */
  /*  This is a real API integration!     */
  /****************************************/

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<AuthUser> _apiLogin() async {
    String? userPref = Util.prefs.getString('user');

    if (userPref != null) {
      AuthUser localUser = AuthUser.fromJson(jsonDecode(userPref));
      return localUser;
    }

    UserWebclient webClient = UserWebclient();
    AuthUser user = await webClient.login(mail: 'aluno@efv.com.br', password: 'efv@164962');
    SharedPreferences.setMockInitialValues({'user': jsonEncode(user.toJson())});
    return user;
  }
}
