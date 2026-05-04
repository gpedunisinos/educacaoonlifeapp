import 'package:unisinos_usp_app/policies/profile_policy.dart';

class ClueConnectionPolicy extends ProfilePolicy<Object> {
  ClueConnectionPolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: true);
}
