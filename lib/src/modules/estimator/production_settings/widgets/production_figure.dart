import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import 'production_palette.dart';

/// Tiny caption over a bold value. Pass [valueColor] for profit/loss, or
/// [dot] to prefix the value with a coloured dot (confidence).
class ProductionFigure extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool dot;
  final bool muted;

  const ProductionFigure({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.dot = false,
    this.muted = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = valueColor ??
        (muted ? AppColors.textMuted : ProductionPalette.ink);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 0.4,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dot) ...[
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: muted ? FontWeight.w500 : FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
