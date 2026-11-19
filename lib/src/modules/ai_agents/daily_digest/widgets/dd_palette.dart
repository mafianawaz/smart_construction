import 'package:flutter/material.dart';

import '../models/daily_digest_models.dart';

/// Local palette stand-in for the Daily Digest feature.
///
/// TODO: reconcile with the shared AppColors once the import path is confirmed.
class DdPalette {
  DdPalette._();

  static const Color primary = Color(0xFFD9640A);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF4B5563);
  static const Color textMuted = Color(0xFF6B7280);

  // Agent code tag (A2, A3 ...)
  static const Color agentBg = Color(0xFFDDF5E6);
  static const Color agentFg = Color(0xFF15803D);

  static DdSeverityStyle severityStyle(DigestSeverity s) {
    switch (s) {
      case DigestSeverity.critical:
        return const DdSeverityStyle(
          label: 'CRITICAL',
          background: Color(0xFFFEE2E2),
          foreground: Color(0xFFC81E1E),
        );
      case DigestSeverity.high:
        return const DdSeverityStyle(
          label: 'HIGH',
          background: Color(0xFFFFE6D5),
          foreground: Color(0xFFC2410C),
        );
      case DigestSeverity.med:
        return const DdSeverityStyle(
          label: 'MED',
          background: Color(0xFFFEF3C7),
          foreground: Color(0xFFB45309),
        );
      case DigestSeverity.low:
        return const DdSeverityStyle(
          label: 'LOW',
          background: Color(0xFFE5E7EB),
          foreground: Color(0xFF374151),
        );
    }
  }
}

class DdSeverityStyle {
  final String label;
  final Color background;
  final Color foreground;

  const DdSeverityStyle({
    required this.label,
    required this.background,
    required this.foreground,
  });
}
