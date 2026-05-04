import 'package:unisinos_usp_app/policies/profile_policy.dart';

class CategoryPolicy extends ProfilePolicy<Object> {
  CategoryPolicy(super.user)
      : super(allowRegularView: true, allowRegularManage: false);
}
