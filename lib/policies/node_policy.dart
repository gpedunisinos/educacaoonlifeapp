import 'package:unisinos_usp_app/policies/profile_policy.dart';

class NodePolicy extends ProfilePolicy<Object> {
  NodePolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: true);
}
