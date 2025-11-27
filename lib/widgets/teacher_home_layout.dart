import 'package:unisinos_usp_app/screens/page_layout.dart';
import 'package:unisinos_usp_app/screens/profile_screen.dart';
import 'package:unisinos_usp_app/screens/search_screen.dart';
import 'package:unisinos_usp_app/screens/teacher_home_screen.dart';
import 'package:flutter/material.dart';

class TeacherHomeLayout extends StatelessWidget {
  const TeacherHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      pages: [
        TeacherHomeScreen(),
        SearchScreen(),
        ProfileScreen(),
      ],
      navItems: [
        buildNavItem(icon: Icons.home_outlined, label: 'Home'),
        buildNavItem(icon: Icons.search, label: 'Pesquisar'),
        buildNavItem(icon: Icons.person_outline, label: 'Perfil'),
      ],
    );
  }
}
