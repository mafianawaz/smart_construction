import 'package:flutter/material.dart';

import '../models/daily_digest_models.dart';
import '../models/digest_format.dart';
import 'dd_action_button.dart';
import 'dd_chips.dart';
import 'dd_field_row.dart';
import 'dd_palette.dart';

/// One ranked digest item. [rank] is its 1-based position among the items
/// currently shown (snoozed items drop out and the rest move up).
class DdItemCard extends StatelessWidget {
  final int rank;
  final DigestItem item;
  final bool acknowledged;
  final VoidCallback onOpen;
  final VoidCallback onAcknowledge;
  final ValueChanged<int> onSnooze;
  final VoidCallback onAssign;
  final VoidCallback onBasisTap;

  /// Snooze options in days.
  static const List<int> snoozeOptions = [1, 3, 7];

  const DdItemCard({
    super.key,
    required this.rank,
    required this.item,
    required this.acknowledged,
    required this.onOpen,
    required this.onAcknowledge,
    required this.onSnooze,
    required this.onAssign,
    required this.onBasisTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DdPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DdPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DdFieldRow(label: '#', text: '$rank'),
          DdFieldRow(
            label: 'Agent',
            child: Align(
              alignment: Alignment.centerLeft,
              child: DdAgentTag(code: item.agentCode),
            ),
          ),
          DdFieldRow(
            label: 'Title',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: DdPalette.textPrimary,
                  ),
                ),
                if (item.dedupedFrom != null) ...[
                  const SizedBox(height: 5),
                  DdDedupChip(count: item.dedupedFrom!),
                ],
              ],
            ),
          ),
          DdFieldRow(label: 'Project', text: item.project),
          DdFieldRow(
            label: 'Recoverable \$',
            text: DigestFormat.money(item.recoverable),
          ),
          DdFieldRow(
            label: 'Severity',
            child: Align(
              alignment: Alignment.centerLeft,
              child: DdSeverityChip(severity: item.severity),
            ),
          ),
          DdFieldRow(label: 'Deadline', text: item.deadline),
          DdFieldRow(label: 'Why ranked', text: item.whyRanked),
          DdFieldRow(
            label: 'Basis',
            child: GestureDetector(
              onTap: onBasisTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                item.basis,
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: DdPalette.textPrimary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          DdFieldRow(
            label: 'Actions',
            child: DdActionGrid(
              children: [
                DdActionButton(label: 'Open', onTap: onOpen),
                DdActionButton(
                  label: acknowledged ? 'Acked ✓' : 'Ack',
                  disabled: acknowledged,
                  onTap: onAcknowledge,
                ),
                PopupMenuButton<int>(
                  tooltip: 'Snooze',
                  padding: EdgeInsets.zero,
                  onSelected: onSnooze,
                  itemBuilder: (_) => [
                    for (final days in snoozeOptions)
                      PopupMenuItem<int>(
                        value: days,
                        child: Text('$days day${days == 1 ? '' : 's'}'),
                      ),
                  ],
                  child: const DdActionButton(
                    label: 'Snooze',
                    trailingChevron: true,
                  ),
                ),
                DdActionButton(label: 'Assign', onTap: onAssign),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
