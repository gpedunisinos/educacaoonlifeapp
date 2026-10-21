import 'package:flutter/material.dart';

/// Theme-aware field for administrative forms. The legacy shared InputText
/// fixes its text and cursor to black, regardless of the surrounding theme.
class ManagementInput extends StatelessWidget {
  const ManagementInput({
    super.key,
    required this.controller,
    this.hintText,
    this.validator,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    this.readOnly = false,
  });
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final int maxLines;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool readOnly;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    validator: validator,
    maxLines: maxLines,
    obscureText: obscureText,
    keyboardType: keyboardType,
    readOnly: readOnly,
    decoration: InputDecoration(labelText: hintText),
  );
}
