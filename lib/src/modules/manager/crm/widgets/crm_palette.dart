import 'package:flutter/material.dart';

import '../models/crm_models.dart';

/// Local palette for the CRM module.
///
/// Mirrors the orange/peach theme but lives here so the module compiles
/// without depending on unconfirmed `AppColors` fields. Reconcile with
/// `AppColors` later (see NOTES_CRM.md).
class CrmPalette {
  CrmPalette._();

  static const Color orange = Color(0xFFF26B1D);
  static const Color orangeDark = Color(0xFFD9540A);
  static const Color orangeTint = Color(0xFFFFF3E8);

  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color chipFill = Color(0xFFF3F4F6);

  static const Color text = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color textFaint = Color(0xFF9CA3AF);
  static const Color dark = Color(0xFF111827);

  static const Color success = Color(0xFF16A34A);
  static const Color successTint = Color(0xFFDCFCE7);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerTint = Color(0xFFFEE2E2);

  static const Color warnFill = Color(0xFFFEF3C7);
  static const Color warnBorder = Color(0xFFFCD34D);
  static const Color warnText = Color(0xFF92400E);

  static const Color blue = Color(0xFF2563EB);
  static const Color blueTint = Color(0xFFDBEAFE);
  static const Color purple = Color(0xFF7C3AED);
  static const Color purpleTint = Color(0xFFEDE9FE);
  static const Color teal = Color(0xFF0F766E);
  static const Color amber = Color(0xFFD97706);
  static const Color pink = Color(0xFFEC4899);
}

extension OrgTypeStyle on OrgType {
  /// Fill colour for the solid type badge in the organization sheet.
  Color get color {
    switch (this) {
      case OrgType.vendor:
        return CrmPalette.success;
      case OrgType.subcontractor:
        return CrmPalette.blue;
      case OrgType.gcContractor:
        return CrmPalette.purple;
      case OrgType.ownerRep:
        return CrmPalette.teal;
      case OrgType.supplier:
        return CrmPalette.amber;
    }
  }
}

extension OpportunityStageStyle on OpportunityStage {
  /// Top-border colour of the stage tile on the board.
  Color get color {
    switch (this) {
      case OpportunityStage.lead:
        return const Color(0xFF9CA3AF);
      case OpportunityStage.qualified:
        return CrmPalette.blue;
      case OpportunityStage.estimating:
        return CrmPalette.purple;
      case OpportunityStage.bidSubmitted:
        return const Color(0xFFEAB308);
      case OpportunityStage.negotiation:
        return CrmPalette.pink;
      case OpportunityStage.won:
        return CrmPalette.success;
      case OpportunityStage.lost:
        return CrmPalette.danger;
    }
  }
}

/// "$1,234,567" — whole dollars, thousands separators.
String crmMoney(double value) {
  final digits = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final fromEnd = digits.length - i;
    buffer.write(digits[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}';
}

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// "Nov 12"
String crmShortDate(DateTime date) => '${_months[date.month - 1]} ${date.day}';

/// First letters of the first two words, upper-cased ("Organization Admin" -> "OA").
String crmInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters.isEmpty ? '?' : letters;
}
