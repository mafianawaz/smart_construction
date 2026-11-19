import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';
import 'labor_tag.dart';
import 'rates_section_intro.dart';

/// Salary category: name/description on the left, annual salary and the
/// derived hourly rate on the right.
class SalaryCategoryCard extends StatelessWidget {
  final SalaryCategoryModel category;

  const SalaryCategoryCard({super.key, required this.category});

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
                  category.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: LaborRatesPalette.ink,
                  ),
                ),
                if (category.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      height: 1.4,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                LaborTag(
                  label: category.isActive ? 'ACTIVE' : 'INACTIVE',
                  foreground: category.isActive
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
              _stat('ANNUAL', formatUsd(category.annualSalary), accent: true),
              const SizedBox(height: 8),
              _stat('HOURLY', formatUsd(category.hourlyRate), accent: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, {required bool accent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            letterSpacing: 0.4,
            color: AppColors.textMuted,
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
    );
  }
}
