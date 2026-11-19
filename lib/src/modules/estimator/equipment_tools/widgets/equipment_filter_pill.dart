import 'package:flutter/material.dart';

import 'equipment_palette.dart';

/// Pill-shaped dropdown trigger ("All Status" / "All Type").
///
/// [filled] = orange background (an active/primary filter, as "All Status"
/// appears in the reference); otherwise white with a border.
/// Generic over the menu value; [null] value means "all".
class EquipmentFilterPill<T> extends StatelessWidget {
  const EquipmentFilterPill({
    super.key,
    required this.label,
    required this.allLabel,
    required this.options,
    required this.optionLabel,
    required this.onSelected,
    this.filled = false,
  });

  final String label;
  final String allLabel;
  final List<T> options;
  final String Function(T) optionLabel;
  final ValueChanged<T?> onSelected;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final fg = filled ? Colors.white : EquipmentPalette.textPrimary;
    return PopupMenuButton<int>(
      tooltip: '',
      offset: const Offset(0, 36),
      color: Colors.white,
      onSelected: (i) => onSelected(i < 0 ? null : options[i]),
      itemBuilder: (_) => [
        PopupMenuItem<int>(
          value: -1,
          child: Text(allLabel, style: const TextStyle(fontSize: 12)),
        ),
        for (var i = 0; i < options.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Text(optionLabel(options[i]),
                style: const TextStyle(fontSize: 12)),
          ),
      ],
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: filled ? EquipmentPalette.orange : EquipmentPalette.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: filled ? EquipmentPalette.orange : EquipmentPalette.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w500, color: fg)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 14, color: fg),
          ],
        ),
      ),
    );
  }
}
