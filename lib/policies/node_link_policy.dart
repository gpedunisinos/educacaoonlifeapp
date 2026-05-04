import 'package:unisinos_usp_app/policies/profile_policy.dart';

class NodeLinkPolicy extends ProfilePolicy<Object> {
  NodeLinkPolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: true);
}
