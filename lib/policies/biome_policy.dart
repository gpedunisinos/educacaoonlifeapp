import 'package:unisinos_usp_app/policies/profile_policy.dart';

class BiomePolicy extends ProfilePolicy<Object> {
  BiomePolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: false);
}
