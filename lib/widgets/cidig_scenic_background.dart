import 'package:flutter/material.dart';

class CidigScenicBackground extends StatelessWidget {
  const CidigScenicBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xB3020914), Color(0xB303162F), Color(0xB3051F3D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          left: -260,
          top: -180,
          child: Container(
            width: 560,
            height: 560,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x2E2AB9FF), Color(0x0032B9FF)],
              ),
            ),
          ),
        ),
        Positioned(
          right: -190,
          top: 90,
          child: Container(
            width: 480,
            height: 480,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x1D58DFFF), Color(0x0058DFFF)],
              ),
            ),
          ),
        ),
        Positioned(
          left: -120,
          bottom: -260,
          child: Container(
            width: 760,
            height: 520,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0x1B00D0FF), Color(0x0000D0FF)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
