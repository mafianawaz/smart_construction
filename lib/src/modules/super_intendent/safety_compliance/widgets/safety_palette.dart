import 'package:flutter/material.dart';

import '../models/safety_models.dart';

/// Local palette for this feature (kept local so the module has no guessed
/// cross-feature imports; see NOTES for swapping to AppColors).
class SafetyPalette {
  SafetyPalette._();

  static const Color orange = Color(0xFFF26A21);
  static const Color orangeSoft = Color(0xFFFFF1E8);
  static const Color background = Color(0xFFF7F7F9);
  static const Color card = Colors.white;
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textFaint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color surfaceMuted = Color(0xFFF3F4F6);

  static const Color red = Color(0xFFEF4444);
  static const Color redSoft = Color(0xFFFEE2E2);
  static const Color green = Color(0xFF10B981);
  static const Color greenSoft = Color(0xFFD1FAE5);
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberSoft = Color(0xFFFEF3C7);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleSoft = Color(0xFFF1EAFE);

  static Color toneColor(SafetyTone tone) {
    switch (tone) {
      case SafetyTone.good:
        return green;
      case SafetyTone.warning:
        return amber;
      case SafetyTone.danger:
        return red;
      case SafetyTone.neutral:
        return textMuted;
    }
  }

  static Color toneSoft(SafetyTone tone) {
    switch (tone) {
      case SafetyTone.good:
        return greenSoft;
      case SafetyTone.warning:
        return amberSoft;
      case SafetyTone.danger:
        return redSoft;
      case SafetyTone.neutral:
        return surfaceMuted;
    }
  }

  static  List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
}
