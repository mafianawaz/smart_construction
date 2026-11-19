import 'package:flutter/material.dart';

import '../models/permit_models.dart';

/// Local stand-in for the shared `AppColors` tokens (see NOTES_REPORTS_PERMITS.md).
class PermitsPalette {
  PermitsPalette._();

  static const Color background = Color(0xFFF5F5F7);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color fieldFill = Color(0xFFF3F4F6);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color warningIcon = Color(0xFFF59E0B);

  static ({Color fg, Color bg}) urgency(PermitUrgency u) => switch (u) {
        PermitUrgency.critical =>
          (fg: const Color(0xFFE5484D), bg: const Color(0xFFFDECEC)),
        PermitUrgency.soon =>
          (fg: const Color(0xFFF08A24), bg: const Color(0xFFFFF1E0)),
        PermitUrgency.upcoming =>
          (fg: const Color(0xFFD99A00), bg: const Color(0xFFFFF6DB)),
        PermitUrgency.safe =>
          (fg: const Color(0xFF1FA463), bg: const Color(0xFFE3F6EC)),
      };
}
