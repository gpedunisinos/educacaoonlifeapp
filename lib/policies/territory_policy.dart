import 'package:unisinos_usp_app/policies/profile_policy.dart';

class TerritoryPolicy extends ProfilePolicy<Object> {
  TerritoryPolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: false);
}
