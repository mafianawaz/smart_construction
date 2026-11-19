import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';

/// Right-aligned "REG: / OT:" pair. A null rate renders as muted italic
/// "not set". REG is orange when set, OT is dark — matching the design.
class RateValueColumn extends StatelessWidget {
  final double? regularRate;
  final double? overtimeRate;

  const RateValueColumn({
    super.key,
    required this.regularRate,
    required this.overtimeRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _line('REG:', regularRate, accent: true),
        const SizedBox(height: 4),
        _line('OT:', overtimeRate, accent: false),
      ],
    );
  }

  Widget _line(String label, double? value, {required bool accent}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 9, color: AppColors.textMuted),
        ),
        const SizedBox(width: 6),
        if (value == null)
          Text(
            'not set',
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          )
        else
          Text(
            formatUsd(value),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accent ? AppColors.primaryOrange : LaborRatesPalette.ink,
            ),
          ),
      ],
    );
  }
}
