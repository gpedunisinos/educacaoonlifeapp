import 'package:unisinos_usp_app/policies/model_policy.dart';
import 'package:unisinos_usp_app/services/auth_user.dart';

class BiomePolicy extends ModelPolicy<Object> {
  BiomePolicy(super.user);

  @override
  bool viewAny() {
    if (user == null) {
      return false;
    } else if (user!.isAdmin) {
      return true;
    } else if (user!.profile == AuthUser.regularProfile) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool view(Object? model) {
    if (user == null || model == null) {
      return false;
    } else if (user!.isAdmin) {
      return true;
    } else if (user!.profile == AuthUser.regularProfile) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool create() {
    if (user == null) {
      return false;
    } else if (user!.isAdmin) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool update(Object? model) {
    if (user == null || model == null) {
      return false;
    } else if (user!.isAdmin) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool delete(Object? model) {
    if (user == null || model == null) {
      return false;
    } else if (user!.isAdmin) {
      return true;
    } else {
      return false;
    }
  }
}
