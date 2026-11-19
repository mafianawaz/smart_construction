import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';
import 'labor_tag.dart';
import 'rate_value_column.dart';
import 'rates_section_intro.dart';

class JobClassificationCard extends StatelessWidget {
  final JobClassificationModel classification;

  const JobClassificationCard({super.key, required this.classification});

  @override
  Widget build(BuildContext context) {
    return RatesCardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  classification.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: LaborRatesPalette.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  classification.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    height: 1.4,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                LaborTag(
                  label: classification.isActive ? 'ACTIVE' : 'INACTIVE',
                  foreground: classification.isActive
                      ? AppColors.primaryOrange
                      : AppColors.textMuted,
                  background: Colors.transparent,
                  outlined: true,
                  fontSize: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LaborTag(
                label: classification.code,
                foreground: AppColors.primaryOrange,
                background: LaborRatesPalette.orangeTint,
                fontSize: 8,
              ),
              const SizedBox(height: 8),
              RateValueColumn(
                regularRate: classification.regularRate,
                overtimeRate: classification.overtimeRate,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
