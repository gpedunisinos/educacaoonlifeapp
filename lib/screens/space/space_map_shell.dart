import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/screens/space/research_room_painter.dart';

const mapIce = Color(0xFF9CE7DF);
const mapPanel = Color(0xF20A1C2A);

/// Navigation console around the map. Map gestures and overlays remain inside
/// their own viewport, clear of the ship's decorative structure.
class SpaceMapShell extends StatelessWidget {
  const SpaceMapShell({
    super.key,
    required this.back,
    required this.actions,
    required this.child,
  });
  final Widget back;
  final List<Widget> actions;
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, bounds) {
      final compact = bounds.maxWidth < 700;
      return Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: ResearchRoomPainter()),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 10 : 26,
                  12,
                  compact ? 10 : 26,
                  12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: mapPanel,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2F5661)),
                      ),
                      child: compact
                          ? Column(
                              children: [
                                Row(
                                  children: [
                                    back,
                                    const SizedBox(width: 12),
                                    const Expanded(child: _MapIdentity()),
                                  ],
                                ),
                                Wrap(
                                  alignment: WrapAlignment.end,
                                  spacing: 2,
                                  children: actions,
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                back,
                                const SizedBox(width: 18),
                                const Expanded(child: _MapIdentity()),
                                ...actions,
                              ],
                            ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: mapPanel,
                            border: Border.all(color: const Color(0xFF2F5661)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _MapIdentity extends StatelessWidget {
  const _MapIdentity();
  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'TERRA / EXPLORAÇÃO',
        style: TextStyle(color: mapIce, fontSize: 9, letterSpacing: 1.2),
      ),
      Text(
        'Mapa de pistas',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}
