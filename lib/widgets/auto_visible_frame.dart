import 'package:flutter/material.dart';

/// Creates a heavy embedded view only near the visible scroll viewport.
class AutoVisibleFrame extends StatefulWidget {
  const AutoVisibleFrame({super.key, required this.builder});
  final WidgetBuilder builder;

  @override
  State<AutoVisibleFrame> createState() => _AutoVisibleFrameState();
}

class _AutoVisibleFrameState extends State<AutoVisibleFrame> {
  final Set<ScrollPosition> _positions = {};
  bool _active = false;
  bool _scheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_active) return;
    for (final position in _positions) {
      position.removeListener(_scheduleCheck);
    }
    _positions.clear();
    context.visitAncestorElements((element) {
      if (element is StatefulElement && element.state is ScrollableState) {
        final position = (element.state as ScrollableState).position;
        if (_positions.add(position)) position.addListener(_scheduleCheck);
      }
      return true;
    });
    _scheduleCheck();
  }

  void _scheduleCheck() {
    if (_scheduled || _active) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) return;
      final box = context.findRenderObject();
      if (box is! RenderBox || !box.hasSize || !box.attached) return;
      final rect = box.localToGlobal(Offset.zero) & box.size;
      final screen = Offset.zero & MediaQuery.sizeOf(context);
      var visibleArea = screen;
      context.visitAncestorElements((element) {
        if (element is StatefulElement && element.state is ScrollableState) {
          final viewport = element.findRenderObject();
          if (viewport is RenderBox && viewport.hasSize && viewport.attached) {
            visibleArea = visibleArea.intersect(
              viewport.localToGlobal(Offset.zero) & viewport.size,
            );
          }
        }
        return true;
      });
      if (visibleArea.inflate(200).overlaps(rect)) {
        for (final position in _positions) {
          position.removeListener(_scheduleCheck);
        }
        _positions.clear();
        setState(() => _active = true);
      }
    });
  }

  @override
  void dispose() {
    for (final position in _positions) {
      position.removeListener(_scheduleCheck);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _active
      ? widget.builder(context)
      : const ColoredBox(color: Color(0xFF071623));
}
