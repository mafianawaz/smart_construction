import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';
import 'labor_tag.dart';
import 'rates_section_intro.dart';

/// Project prevailing-wage card: header, wage breakdown rows, total rate and
/// OT multiplier.
class PrevailingWageCard extends StatelessWidget {
  final PrevailingWageModel wage;

  const PrevailingWageCard({super.key, required this.wage});

  @override
  Widget build(BuildContext context) {
    return RatesCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            wage.projectName,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: LaborRatesPalette.ink,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              LaborTag(
                label: wage.classificationName,
                foreground: LaborRatesPalette.chipBlueFg,
                background: LaborRatesPalette.chipBlueBg,
                fontSize: 10,
              ),
              const SizedBox(width: 8),
              Text(
                'Effective: ${wage.effectiveLabel}',
                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _row('Base Wage Rate', wage.baseWage),
          _row('Health & Welfare (H&W)', wage.healthAndWelfare),
          _row('Pension', wage.pension),
          _row('Vacation / Holiday', wage.vacationHoliday),
          _row('Training', wage.training),
          _row('Fringe Total', wage.fringeTotal),
          const Divider(height: 20, color: LaborRatesPalette.divider),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TOTAL RATE',
                      style: TextStyle(
                        fontSize: 8,
                        letterSpacing: 0.4,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatUsd(wage.totalRate),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: LaborRatesPalette.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'OT MULTIPLIER',
                    style: TextStyle(
                      fontSize: 8,
                      letterSpacing: 0.4,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LaborTag(
                    label: wage.multiplierLabel,
                    foreground: AppColors.primaryOrange,
                    background: LaborRatesPalette.orangeTint,
                    fontSize: 10,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textMuted),
          ),
          Text(
            formatUsd(value),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: LaborRatesPalette.ink,
            ),
          ),
        ],
      ),
    );
  }
}
