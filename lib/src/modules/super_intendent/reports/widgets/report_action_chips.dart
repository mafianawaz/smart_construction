import 'package:flutter/material.dart';

import 'reports_palette.dart';

/// Horizontally scrolling row: Expand / Data Filters / Reset / Print.
class ReportActionChips extends StatelessWidget {
  final VoidCallback onExpand;
  final VoidCallback onDataFilters;
  final VoidCallback onReset;
  final VoidCallback onPrint;
  final bool filtersActive;

  const ReportActionChips({
    super.key,
    required this.onExpand,
    required this.onDataFilters,
    required this.onReset,
    required this.onPrint,
    this.filtersActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(icon: Icons.open_in_full_rounded, label: 'Expand', onTap: onExpand),
          const SizedBox(width: 8),
          _Chip(
            icon: Icons.filter_alt_outlined,
            label: 'Data Filters',
            onTap: onDataFilters,
            showDot: filtersActive,
          ),
          const SizedBox(width: 8),
          _Chip(icon: Icons.refresh_rounded, label: 'Reset', onTap: onReset),
          const SizedBox(width: 8),
          _Chip(icon: Icons.print_outlined, label: 'Print', onTap: onPrint),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDot;

  const _Chip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: ReportsPalette.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ReportsPalette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: ReportsPalette.textDark),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: ReportsPalette.textDark,
              ),
            ),
            if (showDot) ...[
              const SizedBox(width: 6),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: ReportsPalette.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
