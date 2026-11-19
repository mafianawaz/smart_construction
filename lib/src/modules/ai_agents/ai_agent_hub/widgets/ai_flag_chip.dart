import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';
import 'ai_agents_palette.dart';

/// Severity chip ("CRITICAL", "HIGH", "MED", "LOW") with an optional count
/// shown as plain text to its right, e.g. [HIGH] 6.
class AiFlagChip extends StatelessWidget {
  final FlagSeverity severity;
  final int? count;

  const AiFlagChip({super.key, required this.severity, this.count});

  @override
  Widget build(BuildContext context) {
    final style = AiAgentsPalette.flagStyle(severity);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            style.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: style.foreground,
            ),
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 6),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              color: AiAgentsPalette.textPrimary,
            ),
          ),
        ],
      ],
    );
  }
}

/// "Open flags:" row used on agent cards — label then one chip per non-zero
/// severity, or an em dash when there are none.
class AiOpenFlagsRow extends StatelessWidget {
  final FlagCounts flags;

  const AiOpenFlagsRow({super.key, required this.flags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Open flags:',
          style: TextStyle(fontSize: 12, color: AiAgentsPalette.textMuted),
        ),
        if (flags.isEmpty)
          const Text(
            '—',
            style: TextStyle(fontSize: 12, color: AiAgentsPalette.textMuted),
          )
        else
          for (final s in flags.nonZero)
            AiFlagChip(severity: s, count: flags.countFor(s)),
      ],
    );
  }
}
