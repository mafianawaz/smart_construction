import 'package:flutter/material.dart';

import 'rollup_palette.dart';

/// "Health 100" / "SPI 1" / "CPI 2.45" with a thin progress bar underneath.
class RollupMetricBar extends StatelessWidget {
  const RollupMetricBar({
    super.key,
    required this.label,
    required this.valueText,
    required this.fraction,
    required this.barColor,
    this.valueColor,
  });

  final String label;
  final String valueText;

  /// 0..1 fill of the bar.
  final double fraction;
  final Color barColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 10.5, color: RollupPalette.muted)),
            Text(
              valueText,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: valueColor ?? RollupPalette.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1).toDouble(),
            minHeight: 4,
            backgroundColor: RollupPalette.track,
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
          ),
        ),
      ],
    );
  }
}
