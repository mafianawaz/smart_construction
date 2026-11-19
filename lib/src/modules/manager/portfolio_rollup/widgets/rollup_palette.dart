import 'package:flutter/material.dart';

import '../models/rollup_enums.dart';

/// Local palette stand-in so this module has no cross-feature imports.
/// Reconcile with the shared `AppColors` when convenient (see NOTES).
class RollupPalette {
  RollupPalette._();

  static const Color orange = Color(0xFFF26A21);
  static const Color navy = Color(0xFF0B1220);
  static const Color background = Color(0xFFF7F7F8);
  static const Color card = Colors.white;
  static const Color border = Color(0xFFE5E7EB);
  static const Color text = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color track = Color(0xFFE5E7EB);
  static const Color green = Color(0xFF16A34A);
  static const Color greenSoft = Color(0xFFDCFCE7);
  static const Color lime = Color(0xFF34C759);
  static const Color blue = Color(0xFF3B82F6);
  static const Color red = Color(0xFFDC2626);
  static const Color slate = Color(0xFF6B7280);

  /// Strong status colour: filter chips, Gantt bars and Gantt row labels.
  static Color statusColor(RollupStatus s) => switch (s) {
        RollupStatus.planning => green,
        RollupStatus.active => orange,
        RollupStatus.complete => lime,
        RollupStatus.closed => slate,
        RollupStatus.bid => const Color(0xFF6366F1),
      };

  /// Soft badge colours: status pill on heatmap / financial cards.
  static ({Color bg, Color fg}) badge(RollupStatus s) => switch (s) {
        RollupStatus.active => (bg: greenSoft, fg: green),
        RollupStatus.planning =>
          (bg: const Color(0xFFFFEDD5), fg: orange),
        RollupStatus.complete =>
          (bg: const Color(0xFFDBEAFE), fg: const Color(0xFF2563EB)),
        RollupStatus.closed =>
          (bg: const Color(0xFFF3F4F6), fg: const Color(0xFF4B5563)),
        RollupStatus.bid =>
          (bg: const Color(0xFFEDE9FE), fg: const Color(0xFF6D28D9)),
      };
}
