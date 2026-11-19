import 'package:flutter/material.dart';

import '../models/rollup_enums.dart';
import 'rollup_palette.dart';

/// Health Heatmap / Portfolio Gantt / Financial Rollup pill row.
class RollupTabBar extends StatelessWidget {
  const RollupTabBar({super.key, required this.selected, required this.onChanged});

  final RollupTab selected;
  final ValueChanged<RollupTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final t in RollupTab.values)
            _TabPill(
              label: t.label,
              selected: t == selected,
              onTap: () => onChanged(t),
            ),
        ],
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  const _TabPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? RollupPalette.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? RollupPalette.orange : RollupPalette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : RollupPalette.text,
          ),
        ),
      ),
    );
  }
}
