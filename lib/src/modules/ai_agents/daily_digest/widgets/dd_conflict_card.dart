import 'package:flutter/material.dart';

import '../models/daily_digest_models.dart';
import 'dd_action_button.dart';
import 'dd_chips.dart';
import 'dd_field_row.dart';
import 'dd_palette.dart';

/// A conflict between two agents, shown above ordinary ranked items.
class DdConflictCard extends StatelessWidget {
  final DigestConflict conflict;
  final bool acknowledged;
  final VoidCallback onOpen;
  final VoidCallback onAcknowledge;
  final VoidCallback onAssign;

  const DdConflictCard({
    super.key,
    required this.conflict,
    required this.acknowledged,
    required this.onOpen,
    required this.onAcknowledge,
    required this.onAssign,
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
          DdFieldRow(
            label: 'Conflict',
            text: '• ${conflict.project} — ${conflict.summary}',
          ),
          DdFieldRow(
            label: 'Position A',
            child: _Position(
              agent: conflict.positionAAgent,
              text: conflict.positionAText,
            ),
          ),
          DdFieldRow(label: 'Impact A', text: conflict.impactA),
          DdFieldRow(
            label: 'Position B',
            child: _Position(
              agent: conflict.positionBAgent,
              text: conflict.positionBText,
            ),
          ),
          DdFieldRow(label: 'Impact B', text: conflict.impactB),
          DdFieldRow(
            label: 'Hierarchy applied',
            text: conflict.hierarchyApplied,
          ),
          DdFieldRow(
            label: 'Actions',
            child: DdActionGrid(
              children: [
                DdActionButton(label: 'Open', onTap: onOpen),
                DdActionButton(
                  label: acknowledged ? 'Acknowledged ✓' : 'Acknowledge',
                  disabled: acknowledged,
                  onTap: onAcknowledge,
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

class _Position extends StatelessWidget {
  final String agent;
  final String text;

  const _Position({required this.agent, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DdAgentTag(code: agent),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: DdPalette.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
