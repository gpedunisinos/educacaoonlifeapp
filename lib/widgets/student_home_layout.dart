import 'package:unisinos_usp_app/screens/my_trails_screen.dart';
import 'package:unisinos_usp_app/screens/page_layout.dart';
import 'package:unisinos_usp_app/screens/profile_screen.dart';
import 'package:unisinos_usp_app/screens/search_screen.dart';
import 'package:unisinos_usp_app/screens/student_home_screen.dart';
import 'package:flutter/material.dart';

class StudentHomeLayout extends StatelessWidget {
  const StudentHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      pages: [
        StudentHomeScreen(),
        SearchScreen(),
        MyTrailsScreen(),
        ProfileScreen(),
      ],
      navItems: [
        buildNavItem(icon: Icons.home_outlined, label: 'Home'),
        buildNavItem(icon: Icons.search, label: 'Pesquisar'),
        buildNavItem(icon: Icons.play_arrow_outlined, label: 'Minhas Trilhas'),
        buildNavItem(icon: Icons.person_outline, label: 'Perfil'),
      ],
    );
  }
}
