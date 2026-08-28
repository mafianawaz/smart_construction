import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryOrange = Color(0xFFF07C2E);
  static const Color primaryOrangeDark = Color(0xFFE8681A);
  static const Color accentPeach = Color(0xFFF3A66E);

  static const Color background = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1C1C1E);
  static const Color textMuted = Color(0xFF8A8A8E);
  static const Color fieldBorder = Color(0xFFE3E3E6);
  static const Color fieldFill = Color(0xFFFAFAFA);


  static const Color actionButtonLeave =   Color(0xFF4675E8);
  static const Color actionButtonCalculator =   Color(0xFF00A980);

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryOrange, primaryOrangeDark],
  );
}