import 'package:unisinos_usp_app/controllers/controllers.dart';
import 'package:unisinos_usp_app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/services/auth_provider.dart';
import 'package:widgets_spo/utils/util.dart';

class UserAuthService implements AuthService {
  UserModel? _user;

  void setUser(UserModel user) {
    _user = user;
  }

  @override
  String getToken() {
    if (_user == null || _user!.token == null || _user!.token!.isEmpty) {
      throw Exception('Token inválido ou usuário não logado');
    }
    return _user!.token!;
  }

  @override
  Future<void> logout() async {
    await Util.prefs.clear();

    Get.delete<NotificationController>(force: true);

    if (Get.currentRoute != '/login') {
      await Get.offAllNamed('/login');
    }
  }
}
