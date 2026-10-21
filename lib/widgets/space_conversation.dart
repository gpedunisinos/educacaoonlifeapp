import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/screens/space/research_room_painter.dart';
import 'package:unisinos_usp_app/screens/space/space_record_shell.dart';
import 'package:unisinos_usp_app/widgets/safe_back_button.dart';

const spaceChatAccent = Color(0xFF9CE7DF);
const spaceChatText = Color(0xFFE2F1F5);
const spaceChatMuted = Color(0xFF9DB9C7);
const spaceChatUser = Color(0xFF143D47);
const spaceChatReply = Color(0xEE0A1C2B);

BoxDecoration spaceChatBubble(bool user) => BoxDecoration(
  color: user ? spaceChatUser : spaceChatReply,
  border: Border.all(
    color: user ? const Color(0xFF438482) : const Color(0xFF294A5A),
  ),
  borderRadius: BorderRadius.circular(14),
);

BoxDecoration spaceChatComposer() => BoxDecoration(
  color: const Color(0xFF071522),
  border: Border.all(color: const Color(0xFF355965)),
  borderRadius: BorderRadius.circular(14),
);

/// The same ship materials frame global, agent and clue conversations.
class SpaceConversationSurface extends StatelessWidget {
  const SpaceConversationSurface({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xF2091928),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF477B83)),
        boxShadow: const [BoxShadow(color: Color(0x2259CEC6), blurRadius: 28)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: ResearchRoomPainter()),
              ),
            ),
            child,
          ],
        ),
      ),
    ),
  );
}

class SpaceConversationHeader extends StatelessWidget {
  const SpaceConversationHeader({
    super.key,
    required this.title,
    required this.eyebrow,
    this.subtitle,
    this.leading,
    this.actions = const [],
    this.iarete = false,
  });
  final Widget title;
  final String eyebrow;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget> actions;
  final bool iarete;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 12, 10, 14),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFF294A5A))),
    ),
    child: Row(
      children: [
        if (leading != null) leading!,
        if (iarete)
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: IareteConversationSignal(),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: spaceChatAccent,
                  fontSize: 10,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 7),
              DefaultTextStyle(
                style: const TextStyle(
                  color: spaceChatText,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                child: title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                DefaultTextStyle(
                  style: const TextStyle(
                    color: spaceChatMuted,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  child: subtitle!,
                ),
              ],
            ],
          ),
        ),
        ...actions,
      ],
    ),
  );
}

class SpaceConversationRoom extends StatelessWidget {
  const SpaceConversationRoom({
    super.key,
    required this.title,
    required this.eyebrow,
    required this.child,
    this.subtitle,
    this.actions = const [],
  });
  final Widget title;
  final String eyebrow;
  final Widget? subtitle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Theme(
    data: spaceRecordTheme(),
    child: Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: ResearchRoomPainter()),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width < 650 ? 10 : 36,
                vertical: 12,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: SpaceConversationSurface(
                    child: Column(
                      children: [
                        SpaceConversationHeader(
                          title: title,
                          eyebrow: eyebrow,
                          subtitle: subtitle,
                          leading: const SafeBackButton(),
                          actions: actions,
                        ),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// A quiet thread-like presence, inspired by Iareté's cockpit flow.
class IareteConversationSignal extends StatefulWidget {
  const IareteConversationSignal({super.key});
  @override
  State<IareteConversationSignal> createState() =>
      _IareteConversationSignalState();
}

class _IareteConversationSignalState extends State<IareteConversationSignal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _phase = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  );
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _phase.stop();
    } else if (!_phase.isAnimating) {
      _phase.repeat();
    }
  }

  @override
  void dispose() {
    _phase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: 64,
      height: 42,
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _phase,
          builder: (_, __) =>
              CustomPaint(painter: _SignalPainter(_phase.value * math.pi * 2)),
        ),
      ),
    ),
  );
}

class _SignalPainter extends CustomPainter {
  const _SignalPainter(this.phase);
  final double phase;
  @override
  void paint(Canvas canvas, Size size) {
    const colors = [
      spaceChatAccent,
      Color(0xFF81BDDE),
      Color(0xFFC7B3D8),
      Color(0xFFDCC99B),
    ];
    for (var strand = 0; strand < 20; strand++) {
      final path = Path();
      for (var step = 0; step <= 48; step++) {
        final u = step / 48;
        final envelope = math.sin(u * math.pi);
        final y =
            size.height * .5 +
            envelope *
                size.height *
                .34 *
                math.sin(u * math.pi * 3 + phase + strand * .33);
        final x = size.width * u;
        if (step == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = .7
          ..color = colors[strand % colors.length].withValues(
            alpha: .25 + (strand % 4) * .12,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(_SignalPainter oldDelegate) => phase != oldDelegate.phase;
}
