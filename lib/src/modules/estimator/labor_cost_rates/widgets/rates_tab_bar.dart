import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';
import '../models/labor_rates_models.dart';
import 'labor_rates_palette.dart';

/// Horizontally scrolling pill row. Selected pill is solid orange, the rest
/// are outlined. Kept local because the shared `PillTabGroup<T>` isn't
/// confirmed to scroll, and this design has six tabs that overflow.
class RatesTabBar extends StatelessWidget {
  final List<LaborRatesTab> tabs;
  final LaborRatesTab selected;
  final ValueChanged<LaborRatesTab> onChanged;

  const RatesTabBar({
    super.key,
    required this.tabs,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final tab = tabs[i];
          final isSelected = tab == selected;
          return GestureDetector(
            onTap: () => onChanged(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryOrange : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryOrange
                      : LaborRatesPalette.cardBorder,
                ),
              ),
              child: Text(
                tab.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : LaborRatesPalette.ink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
