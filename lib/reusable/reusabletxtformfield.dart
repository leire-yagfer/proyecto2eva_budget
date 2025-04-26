import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';

class ReusableTxtFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool readOnly; //especial para el campo de selección de fecha paraq ue en ese TextFormField no se pueda escribir
  final VoidCallback? onTap; //especial para la selección de fecha
  final String? Function(String?)? validator; //función para validar el campo

  const ReusableTxtFormField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text, //por defecto texto, pero para cantidad solo numérico
    this.readOnly = false, //por defecto false, true para la fecha
    this.onTap,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: context.watch<ThemeProvider>().palette()['fixedLightGrey']!,
        border: OutlineInputBorder(),
      ),
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
    );
  }
}
