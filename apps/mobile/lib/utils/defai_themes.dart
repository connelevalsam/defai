/*
* Created by Connel Asikong on 11/03/2026
*
*/

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeonColors {
  static const darkBg = Color(0xFF0A0A0B);
  static const neonCyan = Color(0xFF00F3FF);
  static const neonPurple = Color(0xFFBC00FF);
  static const neonPink = Color(0xFFF900BF);
  static const surface = Color(0xFF1A1A1D);
  static const textGrey = Color(0xFF9DA1A7);
}

final neonTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: NeonColors.darkBg,
  colorScheme: const ColorScheme.dark(
    primary: NeonColors.neonCyan,
    secondary: NeonColors.neonPurple,
    surface: NeonColors.surface,
  ),
  textTheme: GoogleFonts.orbitronTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: Colors.white, displayColor: NeonColors.neonCyan),
);
