import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unisinos_usp_app/screens/management/management_shell.dart';

/// Shares the Central's navigation while retaining each record's controllers,
/// validation and route guards.
class ManagementRecordScaffold extends StatelessWidget {
  const ManagementRecordScaffold({
    super.key,
    required this.section,
    required this.title,
    required this.subtitle,
    required this.body,
    this.actions = const [],
    this.form = false,
  });
  final String section;
  final String title;
  final String subtitle;
  final Widget body;
  final List<Widget> actions;
  final bool form;

  @override
  Widget build(BuildContext context) => ManagementShell(
    section: section,
    title: title,
    subtitle: subtitle,
    actions: actions,
    backLabel: form ? 'Voltar à lista' : 'Central de Gestão',
    onBack: () {
      final destination = form ? '/$section' : '/management';
      if (Get.previousRoute == destination) {
        Get.back();
      } else {
        Get.offNamed(destination);
      }
    },
    child: form
        ? Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: body,
            ),
          )
        : body,
  );
}
