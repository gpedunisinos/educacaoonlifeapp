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
                    Row(
                      children: [
                        back,
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TERRA / EXPLORAÇÃO',
                                style: TextStyle(
                                  color: mapIce,
                                  fontSize: 10,
                                  letterSpacing: 1.7,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Mapa de pistas',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!compact)
                          const Text(
                            'EC–01 / CARTOGRAFIA',
                            style: TextStyle(
                              color: Color(0xFF9BB4C5),
                              fontSize: 10,
                              letterSpacing: 1.3,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: mapPanel,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF2F5661)),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 5,
                        children: actions,
                      ),
                    ),
                    const SizedBox(height: 10),
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
