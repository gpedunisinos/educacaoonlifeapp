import 'package:get/get.dart';
import 'package:unisinos_usp_app/widgets/ai_assistant_launcher.dart';
import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/widgets/cidig_scenic_background.dart';
import 'package:unisinos_usp_app/widgets/starfield_background.dart';

/// Keeps every route at a readable width, with full-width ambient backgrounds.
class AppPageViewport extends StatelessWidget {
  const AppPageViewport({super.key, required this.child});

  static const double maxWidth = 1040;
  final Widget child;

  @override
  Widget build(BuildContext context) => Obx(() {
    final route = AiAssistantLauncher.activeRoute.value;
    final immersive = route == '/space' || route == '/living_clues/map';
    return Stack(
      fit: StackFit.expand,
      children: [
        Visibility(visible: !immersive, child: const StarfieldBackground()),
        Visibility(visible: !immersive, child: const CidigScenicBackground()),
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: immersive ? double.infinity : maxWidth,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) => MediaQuery(
                // Routes using MediaQuery for padding, grids or map controls must
                // measure the actual content viewport, not the outer window.
                data: MediaQuery.of(context).copyWith(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                ),
                child: SizedBox.expand(child: child),
              ),
            ),
          ),
        ),
      ],
    );
  });
}
