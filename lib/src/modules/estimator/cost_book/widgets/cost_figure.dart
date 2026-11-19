import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'cost_book_palette.dart';

/// Tiny caption over a bold value (MAT / $0.58, LABOR MULT / 1.260).
/// `accent` paints both orange, as the TOTAL column does in the design.
class CostFigure extends StatelessWidget {
  final String label;
  final String value;
  final bool accent;

  const CostFigure({
    super.key,
    required this.label,
    required this.value,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 0.4,
            color: accent ? AppColors.primaryOrange : AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: accent ? AppColors.primaryOrange : CostBookPalette.ink,
          ),
        ),
      ],
    );
  }
}
