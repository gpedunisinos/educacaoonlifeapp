import 'package:flutter/rendering.dart';

/// Positions a measured guide card in the same coordinate space as its target.
/// Prefer an unobstructed side; if none fits, cover as little of the target as possible.
class AnchoredTutorialLayout extends SingleChildLayoutDelegate {
  AnchoredTutorialLayout({required this.target, required this.insets});
  final Rect target;
  final EdgeInsets insets;

  Rect bounds(Size size) => Rect.fromLTRB(
    insets.left.clamp(0, size.width / 2),
    insets.top.clamp(0, size.height / 2),
    (size.width - insets.right).clamp(size.width / 2, size.width),
    (size.height - insets.bottom).clamp(size.height / 2, size.height),
  );

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final available = bounds(constraints.biggest);
    final width = available.width.clamp(0.0, 420.0);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: available.height,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final available = bounds(size);
    final focus = target.inflate(8);
    const gap = 14.0;
    final candidates = [
      Offset(target.center.dx - childSize.width / 2, focus.bottom + gap),
      Offset(
        target.center.dx - childSize.width / 2,
        focus.top - gap - childSize.height,
      ),
      Offset(focus.right + gap, target.center.dy - childSize.height / 2),
      Offset(
        focus.left - gap - childSize.width,
        target.center.dy - childSize.height / 2,
      ),
    ];
    Offset best = available.topLeft;
    double bestOverlap = double.infinity, bestDistance = double.infinity;
    for (final candidate in candidates) {
      final point = Offset(
        candidate.dx.clamp(
          available.left,
          (available.right - childSize.width).clamp(
            available.left,
            available.right,
          ),
        ),
        candidate.dy.clamp(
          available.top,
          (available.bottom - childSize.height).clamp(
            available.top,
            available.bottom,
          ),
        ),
      );
      final rect = point & childSize;
      final intersection = rect.intersect(focus);
      final overlap = intersection.isEmpty
          ? 0.0
          : intersection.width * intersection.height;
      final distance = (rect.center - target.center).distanceSquared;
      if (overlap < bestOverlap ||
          (overlap == bestOverlap && distance < bestDistance)) {
        best = point;
        bestOverlap = overlap;
        bestDistance = distance;
      }
    }
    return best;
  }

  @override
  bool shouldRelayout(AnchoredTutorialLayout oldDelegate) =>
      target != oldDelegate.target || insets != oldDelegate.insets;
}
