import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:widgets_spo/utils.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff030da7),
          centerTitle: true,
          title: Center(
            child: SvgPicture.asset(
              'assets/logo.svg',
              width: 30,
              height: 30,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Menu Administrador',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Insets.small.height,
              Text(
                'Aqui neste menu é possível editar, adicionar ou excluir.',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Insets.extraLarge.height,
              menuCardItem('Categoria', 'Gerenciar categorias, editar ou excluir', '/categories_manager'),
              menuCardItem('Trilha', 'Gerenciar trilhas, editar ou excluir', '/trails_manager'),
              menuCardItem('Aulas', 'Gerenciar aulas, editar ou excluir', '/classes_manager'),
              menuCardItem('Usuários', 'Gerenciar usuários, editar ou excluir', '/users_list'),
              menuCardItem('Relatórios', 'Acessar relatórios', '/report'),
              menuCardItem('Configurações', 'Configurações gerais', '/configurations'),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCardItem(String title, String subtitle, String toNamed) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color(0xff004fef),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
            shadows: const [
              Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
            ],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: secondaryTextStyle(
            color: Colors.white.withOpacity(0.8),
            size: 12,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white.withOpacity(0.9)),
        onTap: () {
          Get.toNamed(toNamed);
        },
      ),
    );
  }
}
