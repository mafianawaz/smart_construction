import 'package:flutter/material.dart';

import 'equipment_palette.dart';

/// Section title + white card used by Assignments / Repair / Hour Log.
/// Shows [emptyMessage] centred when [rows] is empty, otherwise the rows
/// separated by dividers. Screen-agnostic: tabs only supply data.
class EquipmentHistoryCard extends StatelessWidget {
  const EquipmentHistoryCard({
    super.key,
    required this.title,
    required this.emptyMessage,
    this.rows = const [],
  });

  final String title;
  final String emptyMessage;
  final List<EquipmentHistoryRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: EquipmentPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: EquipmentPalette.card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: EquipmentPalette.border),
          ),
          child: rows.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36),
                  child: Center(
                    child: Text(
                      emptyMessage,
                      style: const TextStyle(
                          fontSize: 11, color: EquipmentPalette.textMuted),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      if (i > 0)
                        const Divider(
                            height: 1, color: EquipmentPalette.border),
                      rows[i],
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

/// One record line inside [EquipmentHistoryCard].
class EquipmentHistoryRow extends StatelessWidget {
  const EquipmentHistoryRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: EquipmentPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 12, color: EquipmentPalette.textMuted),
                ),
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: EquipmentPalette.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
