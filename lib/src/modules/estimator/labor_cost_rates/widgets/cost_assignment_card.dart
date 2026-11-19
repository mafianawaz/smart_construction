import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';
import 'labor_tag.dart';
import 'rates_section_intro.dart';

/// Employee cost assignment: who, which salary category + burden profile,
/// and the resulting base vs fully burdened hourly cost.
class CostAssignmentCard extends StatelessWidget {
  final CostAssignmentModel assignment;

  const CostAssignmentCard({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return RatesCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            assignment.employeeName,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: LaborRatesPalette.ink,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              LaborTag(
                label: assignment.salaryCategoryName,
                foreground: LaborRatesPalette.chipBlueFg,
                background: LaborRatesPalette.chipBlueBg,
                fontSize: 10,
              ),
              LaborTag(
                label: assignment.burdenRateName,
                foreground: AppColors.primaryOrange,
                background: LaborRatesPalette.orangeTint,
                fontSize: 10,
              ),
            ],
          ),
          const Divider(height: 20, color: LaborRatesPalette.divider),
          Row(
            children: [
              _stat('BASE / HR', formatUsd(assignment.baseHourly), false),
              _stat(
                'BURDEN',
                '${assignment.burdenPercent.toStringAsFixed(2)}%',
                false,
              ),
              _stat('BURDENED / HR', formatUsd(assignment.burdenedHourly), true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, bool accent) {
    return Expanded(
      child: Column(
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
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: accent ? AppColors.primaryOrange : LaborRatesPalette.ink,
            ),
          ),
        ],
      ),
    );
  }
}
