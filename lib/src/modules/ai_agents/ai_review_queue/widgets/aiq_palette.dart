import 'package:flutter/material.dart';

/// Local palette for the AI Review Queue.
///
/// Stand-in for the shared `AppColors` (kept feature-local on purpose so this
/// module has no guessed cross-feature imports). Swap to `AppColors` fields
/// when reconciling — see NOTES_AI_REVIEW_QUEUE.md.
class AiqPalette {
  const AiqPalette._();

  static const Color bg = Color(0xFFF7F8FA);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderStrong = Color(0xFFD1D5DB);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color faint = Color(0xFF9CA3AF);
  static const Color fillMuted = Color(0xFFF1F3F5);

  static const Color orange = Color(0xFFF26B1D);

  static const Color agentBg = Color(0xFFDDF7E5);
  static const Color agentText = Color(0xFF166534);

  static const Color warnBg = Color(0xFFFFEDD5);
  static const Color warnText = Color(0xFFC2410C);

  static const Color green = Color(0xFF16A34A);
  static const Color error = Color(0xFFDC2626);
  static const Color ink = Color(0xFF0F172A);
}
