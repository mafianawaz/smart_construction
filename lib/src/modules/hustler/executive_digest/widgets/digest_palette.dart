import 'package:flutter/material.dart';

import '../models/executive_digest_models.dart';

/// Local colour tokens for the Executive Digest module.
/// Kept local (not `AppColors`) so the module has no cross-feature imports.
class DigestPalette {
  DigestPalette._();

  static const Color primary = Color(0xFFFF6A00);
  static const Color primaryTint = Color(0xFFFFF1E8);
  static const Color summaryFill = Color(0xFFFFF4EC);
  static const Color summaryBorder = Color(0xFFFBDCC8);

  static const Color text = Color(0xFF111827);
  static const Color body = Color(0xFF4B5563);
  static const Color muted = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color chipFill = Color(0xFFF3F4F6);
  static const Color barText = Color(0xFF8B93A1);

  static const Color highlightText = Color(0xFF2563EB);
  static const Color highlightFill = Color(0xFFEFF5FF);

  static const Color high = Color(0xFFDC2626);
  static const Color highFill = Color(0xFFFEE2E2);
  static const Color medium = Color(0xFFB45309);
  static const Color mediumFill = Color(0xFFFEF3C7);
  static const Color low = Color(0xFF047857);
  static const Color lowFill = Color(0xFFD1FAE5);

  static Color sectionColor(DigestSectionKind kind) {
    switch (kind) {
      case DigestSectionKind.financial:
        return const Color(0xFF059669);
      case DigestSectionKind.operational:
        return const Color(0xFF2563EB);
      case DigestSectionKind.risk:
        return const Color(0xFFC2410C);
      case DigestSectionKind.opportunity:
        return const Color(0xFF7C3AED);
    }
  }

  static Color sectionFill(DigestSectionKind kind) {
    switch (kind) {
      case DigestSectionKind.financial:
        return const Color(0xFFE3F6EE);
      case DigestSectionKind.operational:
        return const Color(0xFFE6EEFD);
      case DigestSectionKind.risk:
        return const Color(0xFFFDEBC8);
      case DigestSectionKind.opportunity:
        return const Color(0xFFF1E8FD);
    }
  }

  static IconData sectionIcon(DigestSectionKind kind) {
    switch (kind) {
      case DigestSectionKind.financial:
        return Icons.attach_money_rounded;
      case DigestSectionKind.operational:
        return Icons.settings_outlined;
      case DigestSectionKind.risk:
        return Icons.warning_amber_rounded;
      case DigestSectionKind.opportunity:
        return Icons.lightbulb_outline_rounded;
    }
  }

  static Color priorityColor(DigestActionPriority p) {
    switch (p) {
      case DigestActionPriority.high:
        return high;
      case DigestActionPriority.medium:
        return medium;
      case DigestActionPriority.low:
        return low;
    }
  }

  static Color priorityFill(DigestActionPriority p) {
    switch (p) {
      case DigestActionPriority.high:
        return highFill;
      case DigestActionPriority.medium:
        return mediumFill;
      case DigestActionPriority.low:
        return lowFill;
    }
  }
}
