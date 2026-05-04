import 'package:unisinos_usp_app/policies/profile_policy.dart';

class UserPolicy extends ProfilePolicy<Object> {
  UserPolicy(super.user)
      : super(allowRegularView: false, allowRegularManage: false);
}
