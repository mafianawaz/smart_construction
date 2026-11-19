import 'package:flutter/material.dart';

/// Local palette stand-in so this module has no cross-feature imports.
/// Reconcile with the shared `AppColors` when convenient (see NOTES).
class CfoPalette {
  CfoPalette._();

  static const Color orange = Color(0xFFF26A21);
  static const Color orangeSoft = Color(0xFFFFEDD5);
  static const Color background = Color(0xFFF7F7F8);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color green = Color(0xFF16A34A);
  static const Color blue = Color(0xFF2563EB);
  static const Color red = Color(0xFFDC2626);
}
