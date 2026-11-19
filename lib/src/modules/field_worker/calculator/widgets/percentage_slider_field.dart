import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';


/// A labeled percentage input combining a draggable slider with a row of
/// quick-select chips. Reusable anywhere a percentage rate is collected —
/// profit margin, markup, overhead, burden rate, etc. — on any screen, not
/// just Calculator: it takes no domain knowledge, just a label/value/range.
///
/// Place this alongside `pill_tab_group.dart` in the shared widgets folder.
class PercentageSliderField extends StatelessWidget {
  const PercentageSliderField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.quickOptions = const [10, 15, 20, 25],
    this.min = 0,
    this.max = 50,
  });

  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final List<double> quickOptions;
  final double min;
  final double max;

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(min, max);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 9,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            value: clampedValue,
            min: min,
            max: max,
            activeColor: AppColors.primaryOrange,
            inactiveColor: AppColors.fieldFill,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            for (var i = 0; i < quickOptions.length; i++) ...[
              _QuickChip(
                label: '${quickOptions[i].toInt()}%',
                selected: clampedValue == quickOptions[i],
                onTap: () => onChanged(quickOptions[i]),
              ),
              if (i != quickOptions.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryOrange : AppColors.fieldFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
