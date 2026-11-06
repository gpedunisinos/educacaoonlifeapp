import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';

/// Refreshes permission-dependent controls without replacing the route or State.
class ModeAwarePage extends StatelessWidget {
  const ModeAwarePage({super.key, required this.builder});
  final Widget Function() builder;
  @override
  Widget build(BuildContext context) => Obx(() {
    Get.find<UserController>().user.value;
    return builder();
  });
}
