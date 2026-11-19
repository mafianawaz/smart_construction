import 'package:flutter/material.dart';

import 'crm_palette.dart';

class CrmStatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color tint;

  const CrmStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.tint,
  });
}

/// Two-column grid of stat cards.
///
/// [stacked] = false: icon left, value + label right (Organizations).
/// [stacked] = true: round icon on top, centred value + label (Pipeline).
class CrmStatGrid extends StatelessWidget {
  final List<CrmStatItem> items;
  final bool stacked;

  const CrmStatGrid({super.key, required this.items, this.stacked = false});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final left = items[i];
      final right = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: _StatCard(item: left, stacked: stacked)),
            const SizedBox(width: 10),
            Expanded(
              child: right == null
                  ? const SizedBox.shrink()
                  : _StatCard(item: right, stacked: stacked),
            ),
          ],
        ),
      );
      if (i + 2 < items.length) rows.add(const SizedBox(height: 10));
    }
    return Column(children: rows);
  }
}

class _StatCard extends StatelessWidget {
  final CrmStatItem item;
  final bool stacked;

  const _StatCard({required this.item, required this.stacked});

  @override
  Widget build(BuildContext context) {
    final icon = Container(
      width: stacked ? 34 : 30,
      height: stacked ? 34 : 30,
      decoration: BoxDecoration(
        color: item.tint,
        shape: stacked ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: stacked ? null : BorderRadius.circular(8),
      ),
      child: Icon(item.icon, size: stacked ? 18 : 16, color: item.color),
    );

    final value = Text(
      item.value,
      style: TextStyle(
        fontSize: stacked ? 15 : 18,
        fontWeight: FontWeight.w700,
        color: CrmPalette.text,
      ),
    );
    final label = Text(
      item.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 11, color: CrmPalette.textMuted),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: stacked
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [icon, const SizedBox(height: 8), value, label],
            )
          : Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [value, label],
                  ),
                ),
              ],
            ),
    );
  }
}
