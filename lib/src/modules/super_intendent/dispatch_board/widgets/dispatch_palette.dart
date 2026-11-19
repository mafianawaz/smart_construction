import 'package:flutter/material.dart';

/// Local palette for this feature (kept local so the module has no guessed
/// cross-feature imports; see NOTES for swapping to AppColors).
class DispatchPalette {
  DispatchPalette._();

  static const Color orange = Color(0xFFF26A21);
  static const Color orangeSoft = Color(0xFFFFF1E8);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color background = Color(0xFFF6F7F9);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textFaint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color surfaceMuted = Color(0xFFF3F4F6);
  static const Color red = Color(0xFFEF4444);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
}
