import 'package:flutter/material.dart';

import '../models/kpi_model.dart';

/// Local palette so the module compiles without touching the shared
/// `AppColors`. Swap for AppColors fields when reconciling (see NOTES).
class WfPalette {
  static const Color orange = Color(0xFFF26B21);
  static const Color orangeSoft = Color(0xFFFFF1E8);
  static const Color text = Color(0xFF1F2937);
  static const Color muted = Color(0xFF6B7280);
  static const Color hint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color fill = Color(0xFFF3F4F6);
  static const Color fillSoft = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF2563EB);
  static const Color infoBg = Color(0xFFDBEAFE);
}

/// Category → chip / progress-bar colours (Financial orange, Safety green,
/// Quality blue as in the designs; the rest are my own picks).
extension KpiCategoryColors on KpiCategory {
  Color get color {
    switch (this) {
      case KpiCategory.financial:
        return WfPalette.orange;
      case KpiCategory.safety:
        return WfPalette.success;
      case KpiCategory.quality:
        return WfPalette.info;
      case KpiCategory.productivity:
        return const Color(0xFF7C3AED);
      case KpiCategory.schedule:
        return const Color(0xFF0D9488);
      case KpiCategory.custom:
        return WfPalette.muted;
    }
  }

  Color get softColor {
    switch (this) {
      case KpiCategory.financial:
        return WfPalette.orangeSoft;
      case KpiCategory.safety:
        return WfPalette.successBg;
      case KpiCategory.quality:
        return WfPalette.infoBg;
      case KpiCategory.productivity:
        return const Color(0xFFEDE9FE);
      case KpiCategory.schedule:
        return const Color(0xFFCCFBF1);
      case KpiCategory.custom:
        return WfPalette.fill;
    }
  }
}
