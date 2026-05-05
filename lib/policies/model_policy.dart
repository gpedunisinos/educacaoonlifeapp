import 'package:unisinos_usp_app/services/auth_user.dart';

abstract class ModelPolicy<T> {
  final AuthUser? user;

  ModelPolicy(this.user);

  bool viewAny();
  bool view(T? model);
  bool create();
  bool update(T? model);
  bool delete(T? model);
}
