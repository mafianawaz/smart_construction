import 'package:flutter/material.dart';

import '../models/rollup_enums.dart';
import 'rollup_palette.dart';

/// Soft status pill on the heatmap ("ACTIVE") and financial ("Active") cards.
class RollupStatusBadge extends StatelessWidget {
  const RollupStatusBadge({
    super.key,
    required this.status,
    this.upperCase = false,
  });

  final RollupStatus status;
  final bool upperCase;

  @override
  Widget build(BuildContext context) {
    final c = RollupPalette.badge(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(upperCase ? 10 : 6),
      ),
      child: Text(
        upperCase ? status.upperLabel : status.label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: c.fg,
        ),
      ),
    );
  }
}
