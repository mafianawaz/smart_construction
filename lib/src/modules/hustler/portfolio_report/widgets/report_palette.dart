import 'package:flutter/material.dart';

/// Local colour tokens for the Portfolio Report module (no `AppColors`
/// dependency; swap when the shared theme import path is confirmed).
class ReportPalette {
  ReportPalette._();

  static const Color primary = Color(0xFFFF6A00);
  static const Color primaryTint = Color(0xFFFFF1E8);

  static const Color text = Color(0xFF111827);
  static const Color body = Color(0xFF4B5563);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color chipFill = Color(0xFFF3F4F6);
  static const Color barText = Color(0xFF8B93A1);
  static const Color track = Color(0xFFE5E7EB);
  static const Color cardFill = Color(0xFFF9FAFB);

  static const Color activeText = Color(0xFF15803D);
  static const Color activeFill = Color(0xFFDCFCE7);
  static const Color idleText = Color(0xFF6B7280);
  static const Color idleFill = Color(0xFFF3F4F6);

  static const Color rankText = Color(0xFF92400E);
  static const Color rankFill = Color(0xFFFEF3C7);
}
