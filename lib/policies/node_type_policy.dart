import 'package:unisinos_usp_app/policies/profile_policy.dart';

class NodeTypePolicy extends ProfilePolicy<Object> {
  NodeTypePolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: false);
}
