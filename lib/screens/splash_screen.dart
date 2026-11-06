import 'package:flutter/material.dart';
import 'package:unisinos_usp_app/widgets/space_conversation.dart';
import 'package:unisinos_usp_app/screens/space/research_room_painter.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/controllers/auth/user_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Get.find<UserController>().redirectLoggedUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(painter: ResearchRoomPainter()),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 180,
                    height: 72,
                    child: IareteConversationSignal(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Educação OnLIFE',
                    style: TextStyle(color: spaceChatText, fontSize: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Preparando nossa expedição…',
                    style: TextStyle(color: spaceChatMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
