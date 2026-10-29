import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/screens/space/research_room_painter.dart';

ThemeData spaceRecordTheme() => ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF9CE7DF),
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF050C18),
  // dropdown_search falls back to white unless the sheet color is explicit.
  // Its options and search field already inherit this dark theme's text colors.
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Color(0xFF091B2A),
    modalBackgroundColor: Color(0xFF091B2A),
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: const CardThemeData(
    color: Color(0xEE091B2A),
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      side: BorderSide(color: Color(0xFF2F5661)),
    ),
  ),
);

/// Full-screen reading surface in the ship's research room.
class SpaceRecordShell extends StatelessWidget {
  const SpaceRecordShell({
    super.key,
    required this.child,
    required this.onBack,
    required this.backLabel,
    this.actions = const [],
  });
  final Widget child;
  final VoidCallback onBack;
  final String backLabel;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Stack(
      children: [
        const Positioned.fill(
          child: CustomPaint(painter: ResearchRoomPainter()),
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width < 650 ? 16 : 42,
              vertical: 16,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton.icon(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back, size: 17),
                          label: Text(
                            backLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    ...actions,
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'EC–01 / ARQUIVO DE PISTAS',
                    style: TextStyle(
                      color: Color(0xFF9CE7DF),
                      fontSize: 10,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
