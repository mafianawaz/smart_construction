import 'package:flutter/material.dart';

import '../models/report_models.dart';
import 'reports_palette.dart';

/// Card listing every report, grouped (Takeoff / Estimate) with collapsible headers.
class ReportPickerCard extends StatelessWidget {
  final List<ReportType> reports;
  final ReportType selected;
  final bool Function(ReportGroup) isExpanded;
  final ValueChanged<ReportGroup> onToggleGroup;
  final ValueChanged<ReportType> onSelect;

  const ReportPickerCard({
    super.key,
    required this.reports,
    required this.selected,
    required this.isExpanded,
    required this.onToggleGroup,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: ReportsPalette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ReportsPalette.border),
      ),
      child: Column(
        children: [
          for (final group in ReportGroup.values)
            _GroupSection(
              group: group,
              items: reports.where((r) => r.group == group).toList(),
              selected: selected,
              expanded: isExpanded(group),
              onToggle: () => onToggleGroup(group),
              onSelect: onSelect,
            ),
        ],
      ),
    );
  }
}

class _GroupSection extends StatelessWidget {
  final ReportGroup group;
  final List<ReportType> items;
  final ReportType selected;
  final bool expanded;
  final VoidCallback onToggle;
  final ValueChanged<ReportType> onSelect;

  const _GroupSection({
    required this.group,
    required this.items,
    required this.selected,
    required this.expanded,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    group.label,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: ReportsPalette.textSecondary,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      size: 20, color: ReportsPalette.textSecondary),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 180),
          crossFadeState:
              expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Column(
            children: [
              for (final item in items)
                _ReportRow(
                  item: item,
                  isSelected: item.id == selected.id,
                  onTap: () => onSelect(item),
                ),
              const SizedBox(height: 6),
            ],
          ),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _ReportRow extends StatelessWidget {
  final ReportType item;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReportRow({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Icon(
              Icons.description,
              size: 18,
              color: isSelected ? ReportsPalette.orange : ReportsPalette.docIcon,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? ReportsPalette.orange
                      : ReportsPalette.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
