import 'package:flutter/material.dart';

/// Local palette stand-in so this feature has no guessed cross-feature
/// imports. Swap for `AppColors` once confirmed.
class TcPalette {
  TcPalette._();

  static const orange = Color(0xFFF97316);
  static const orangeBg = Color(0xFFFFF7ED);
  static const orangeBorder = Color(0xFFFED7AA);

  static const purple = Color(0xFF7C3AED);
  static const purpleBg = Color(0xFFF5F3FF);
  static const purpleBorder = Color(0xFFDDD6FE);

  static const green = Color(0xFF16A34A);
  static const greenBg = Color(0xFFF0FDF4);
  static const greenBorder = Color(0xFFBBF7D0);

  static const red = Color(0xFFEF4444);

  static const text = Color(0xFF111827);
  static const muted = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const surface = Color(0xFFF3F4F6);
  static const white = Colors.white;
}
