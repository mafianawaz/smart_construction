import 'package:flutter/material.dart';

import '../models/equipment_models.dart';

/// Local palette for this feature (no guessed cross-feature imports; swap for
/// AppColors when you like, see NOTES).
class SuperInEquipmentPalette {
  SuperInEquipmentPalette._();

  static const Color orange = Color(0xFFF26A21);
  static const Color orangeSoft = Color(0xFFFDEDE3);
  static const Color background = Color(0xFFF7F8FA);
  static const Color fieldFill = Color(0xFFF8F9FB);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textFaint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color chipGrey = Color(0xFFF3F4F6);
  static const Color red = Color(0xFFEF4444);
  static const Color redSoft = Color(0xFFFEE2E2);
  static const Color green = Color(0xFF10B981);
  static const Color greenSoft = Color(0xFFD1FAE5);
  static const Color greenText = Color(0xFF059669);
  static const Color teal = Color(0xFF14B8A6);
  static const Color tealSoft = Color(0xFFCCFBF1);
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueSoft = Color(0xFFDBEAFE);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0F000000), blurRadius: 10, offset: Offset(0, 3)),
  ];

  static Color statusText(EquipmentStatus s) {
    switch (s) {
      case EquipmentStatus.available:
        return greenText;
      case EquipmentStatus.assigned:
        return const Color(0xFF0F766E);
      case EquipmentStatus.inRepair:
        return const Color(0xFFB91C1C);
    }
  }

  static Color statusSoft(EquipmentStatus s) {
    switch (s) {
      case EquipmentStatus.available:
        return greenSoft;
      case EquipmentStatus.assigned:
        return tealSoft;
      case EquipmentStatus.inRepair:
        return redSoft;
    }
  }
}
