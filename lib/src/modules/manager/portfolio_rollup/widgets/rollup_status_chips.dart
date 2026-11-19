import 'package:flutter/material.dart';

import '../models/rollup_enums.dart';
import 'rollup_palette.dart';

/// `outlined`: heatmap row — white chips, selected one is navy.
/// `colored`: Gantt / Financial row — "STATUS:" label, selected chips are
/// filled with the status colour, unselected are outlined in it.
enum RollupChipStyle { outlined, colored }

class RollupStatusChips extends StatelessWidget {
  const RollupStatusChips({
    super.key,
    required this.statuses,
    required this.selected,
    required this.onToggle,
    required this.style,
  });

  final List<RollupStatus> statuses;
  final Set<RollupStatus> selected;
  final ValueChanged<RollupStatus> onToggle;
  final RollupChipStyle style;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      if (style == RollupChipStyle.colored)
        const Padding(
          padding: EdgeInsets.only(right: 2),
          child: Text(
            'STATUS:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: RollupPalette.muted,
            ),
          ),
        ),
      for (final s in statuses)
        _Chip(
          status: s,
          selected: selected.contains(s),
          style: style,
          onTap: () => onToggle(s),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: chips,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.status,
    required this.selected,
    required this.style,
    required this.onTap,
  });

  final RollupStatus status;
  final bool selected;
  final RollupChipStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fill;
    final Color stroke;
    final Color fg;
    if (style == RollupChipStyle.outlined) {
      fill = selected ? RollupPalette.navy : Colors.white;
      stroke = selected ? RollupPalette.navy : RollupPalette.border;
      fg = selected ? Colors.white : RollupPalette.text;
    } else {
      final c = RollupPalette.statusColor(status);
      fill = selected ? c : Colors.white;
      stroke = c;
      fg = selected ? Colors.white : c;
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: stroke),
        ),
        child: Text(
          status.upperLabel,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: fg,
          ),
        ),
      ),
    );
  }
}
