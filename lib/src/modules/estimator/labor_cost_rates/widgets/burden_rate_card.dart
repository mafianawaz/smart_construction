import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';
import 'labor_tag.dart';
import 'rates_section_intro.dart';

/// Burden profile: header with total %, then one row per component grouped
/// by category (taxes, benefits, insurance, overhead).
class BurdenRateCard extends StatelessWidget {
  final BurdenRateModel burden;

  const BurdenRateCard({super.key, required this.burden});

  @override
  Widget build(BuildContext context) {
    return RatesCardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  burden.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: LaborRatesPalette.ink,
                  ),
                ),
              ),
              LaborTag(
                label: burden.isActive ? 'ACTIVE' : 'INACTIVE',
                foreground: burden.isActive
                    ? AppColors.primaryOrange
                    : AppColors.textMuted,
                background: Colors.transparent,
                outlined: true,
                fontSize: 8,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final category in BurdenCategory.values)
            ..._section(category),
          const Divider(height: 20, color: LaborRatesPalette.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL BURDEN',
                style: TextStyle(
                  fontSize: 8,
                  letterSpacing: 0.4,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                burden.totalLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: LaborRatesPalette.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _section(BurdenCategory category) {
    final rows =
        burden.components.where((c) => c.category == category).toList();
    if (rows.isEmpty) return const [];
    return [
      Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2),
        child: Text(
          category.label.toUpperCase(),
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            color: AppColors.primaryOrange,
          ),
        ),
      ),
      for (final c in rows)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                c.label,
                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
              ),
              Text(
                '${c.percent.toStringAsFixed(2)}%',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: LaborRatesPalette.ink,
                ),
              ),
            ],
          ),
        ),
    ];
  }
}
