/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:flutter/material.dart';

import '../../utils/defai_themes.dart';

class NeonTextField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final IconData? icon;

  const NeonTextField({
    super.key,
    required this.hint,
    this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Icon(icon, color: NeonColors.neonCyan)
            : null,
        hintText: hint,
        hintStyle: const TextStyle(color: NeonColors.textGrey),
        filled: true,
        fillColor: NeonColors.surface,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: NeonColors.neonCyan.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: NeonColors.neonCyan, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
