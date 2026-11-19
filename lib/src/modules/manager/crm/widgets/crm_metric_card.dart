import 'package:flutter/material.dart';

import 'crm_palette.dart';

class CrmMetricItem {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const CrmMetricItem({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });
}

/// Two-column grid of compact metric cards: small icon + label on top, big
/// value underneath (Analytics tab).
class CrmMetricGrid extends StatelessWidget {
  final List<CrmMetricItem> items;

  const CrmMetricGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      final right = i + 1 < items.length ? items[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: _MetricCard(item: items[i])),
            const SizedBox(width: 10),
            Expanded(
              child: right == null
                  ? const SizedBox.shrink()
                  : _MetricCard(item: right),
            ),
          ],
        ),
      );
      if (i + 2 < items.length) rows.add(const SizedBox(height: 10));
    }
    return Column(children: rows);
  }
}

class _MetricCard extends StatelessWidget {
  final CrmMetricItem item;

  const _MetricCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 14, color: CrmPalette.textMuted),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              item.value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: item.valueColor ?? CrmPalette.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
