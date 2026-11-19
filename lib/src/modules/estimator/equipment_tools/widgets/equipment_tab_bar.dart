import 'package:flutter/material.dart';

import '../models/equipment_models.dart';
import 'equipment_palette.dart';

/// Horizontally scrollable segmented tab row (the design clips the tail:
/// "Overview | Assignments | Repair | Hour Log | Preventative Maintenance | D…").
class EquipmentTabBar extends StatelessWidget {
  const EquipmentTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final EquipmentDetailTab selected;
  final ValueChanged<EquipmentDetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: EquipmentPalette.tabTrack,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(2),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: EquipmentDetailTab.values.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (_, i) {
          final tab = EquipmentDetailTab.values[i];
          final isSelected = tab == selected;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isSelected
                    ? Border.all(color: EquipmentPalette.border)
                    : null,
              ),
              child: Text(
                tab.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? EquipmentPalette.textPrimary
                      : EquipmentPalette.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
