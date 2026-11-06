import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Centers short forms while allowing scrolling above the keyboard and in
/// landscape, without fixing their height to the full device screen.
class AuthFormViewport extends StatelessWidget {
  const AuthFormViewport({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: math.max(0, constraints.maxHeight - 48),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}
