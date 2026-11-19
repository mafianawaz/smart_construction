import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';

/// Local palette stand-in for the AI Agents feature.
///
/// TODO: reconcile with the shared AppColors (primaryOrange, textMuted, ...)
/// once the import path is confirmed.
class AiAgentsPalette {
  AiAgentsPalette._();

  static const Color primary = Color(0xFFFF6A00);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF6B7280);

  // Schedule health chips
  static const Color currentBg = Color(0xFFDCEBFF);
  static const Color currentFg = Color(0xFF1D4ED8);
  static const Color staleBg = Color(0xFFFFE6D5);
  static const Color staleFg = Color(0xFFC2410C);

  static AiFlagStyle flagStyle(FlagSeverity severity) {
    switch (severity) {
      case FlagSeverity.critical:
        return const AiFlagStyle(
          label: 'CRITICAL',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFC81E1E),
        );
      case FlagSeverity.high:
        return const AiFlagStyle(
          label: 'HIGH',
          background: Color(0xFFFFE6D5),
          foreground: Color(0xFFC2410C),
        );
      case FlagSeverity.med:
        return const AiFlagStyle(
          label: 'MED',
          background: Color(0xFFFEF3C7),
          foreground: Color(0xFFB45309),
        );
      case FlagSeverity.low:
        return const AiFlagStyle(
          label: 'LOW',
          background: Color(0xFFE5E7EB),
          foreground: Color(0xFF374151),
        );
    }
  }
}

class AiFlagStyle {
  final String label;
  final Color background;
  final Color foreground;

  const AiFlagStyle({
    required this.label,
    required this.background,
    required this.foreground,
  });
}
