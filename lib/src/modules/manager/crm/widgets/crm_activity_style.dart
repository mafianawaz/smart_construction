import 'package:flutter/material.dart';

import '../models/crm_activity_models.dart';
import 'crm_palette.dart';

extension CallOutcomeStyle on CallOutcome {
  /// Fill colour of the outcome pill on a call card.
  Color get color {
    switch (this) {
      case CallOutcome.connected:
        return CrmPalette.success;
      case CallOutcome.voicemail:
        return CrmPalette.blue;
      case CallOutcome.noAnswer:
        return CrmPalette.amber;
      case CallOutcome.busy:
        return CrmPalette.amber;
      case CallOutcome.wrongNumber:
        return CrmPalette.danger;
    }
  }
}

extension TaskPriorityStyle on TaskPriority {
  Color get color {
    switch (this) {
      case TaskPriority.low:
        return CrmPalette.textMuted;
      case TaskPriority.medium:
        return CrmPalette.amber;
      case TaskPriority.high:
        return CrmPalette.danger;
    }
  }
}

extension QuoteStatusStyle on QuoteStatus {
  Color get color {
    switch (this) {
      case QuoteStatus.draft:
        return CrmPalette.textMuted;
      case QuoteStatus.sent:
        return CrmPalette.blue;
      case QuoteStatus.accepted:
        return CrmPalette.success;
      case QuoteStatus.declined:
        return CrmPalette.danger;
    }
  }
}

/// "Aug 5, 8:30 PM"
String crmDateTime(DateTime d) {
  final hour = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final minute = d.minute.toString().padLeft(2, '0');
  final suffix = d.hour >= 12 ? 'PM' : 'AM';
  return '${crmShortDate(d)}, $hour:$minute $suffix';
}

/// "08/05/2026" — matches the reference's mm/dd/yyyy date inputs.
String crmSlashDate(DateTime d) {
  final month = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$month/$day/${d.year}';
}

/// "Dec 1, 2026"
String crmLongDate(DateTime d) => '${crmShortDate(d)}, ${d.year}';

/// Like `crmMoney` but keeps cents when there are any ($1,234.50).
String crmMoneyPrecise(double value) {
  final cents = (value * 100).round();
  final whole = cents ~/ 100;
  final frac = cents % 100;
  final base = crmMoney(whole.toDouble());
  return frac == 0 ? base : '$base.${frac.toString().padLeft(2, '0')}';
}
