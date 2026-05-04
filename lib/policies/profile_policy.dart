import 'package:unisinos_usp_app/policies/model_policy.dart';

abstract class ProfilePolicy<T> extends ModelPolicy<T> {
  final bool allowRegularView;
  final bool allowRegularManage;

  ProfilePolicy(
    super.user, {
    required this.allowRegularView,
    required this.allowRegularManage,
  });

  bool get _isAuthenticated => user != null;
  bool get _isAdmin => user?.isAdmin ?? false;
  bool get _isRegularUser => _isAuthenticated && !_isAdmin;

  @override
  bool viewAny() => _isAdmin || (allowRegularView && _isRegularUser);

  @override
  bool view(T? model) => model != null && viewAny();

  @override
  bool create() => _isAdmin || (allowRegularManage && _isRegularUser);

  @override
  bool update(T? model) => model != null && create();

  @override
  bool delete(T? model) => model != null && create();
}
