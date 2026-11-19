import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';

/// A single label/value line shown in a [CalculatorResultsCard].
class CalculatorResultItem {
  final String label;
  final String value;

  const CalculatorResultItem(this.label, this.value);
}

/// Renders a list of computed result lines as a simple summary card.
///
/// Fully generic — it has no knowledge of Concrete, Masonry, or Lumber &
/// Framing. Each module's form widget builds its own `List<CalculatorResultItem>`
/// with friendly labels, so this card can be reused by any current or future
/// calculator category without modification.
class CalculatorResultsCard extends StatelessWidget {
  const CalculatorResultsCard({super.key, required this.items, this.title = 'Estimate'});

  final List<CalculatorResultItem> items;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(fontSize: 13, color: AppColors.textDark),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.value,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
