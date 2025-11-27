import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class ScreenLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback? onBack;
  final Color appBarColor;
  final bool centerTitle;

  const ScreenLayout({
    super.key,
    required this.title,
    required this.body,
    this.onBack,
    this.appBarColor = const Color(0xff030da7),
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          centerTitle: centerTitle,
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: onBack ?? () => Get.secureBack(),
          ),
        ),
        body: body,
      ),
    );
  }
}
