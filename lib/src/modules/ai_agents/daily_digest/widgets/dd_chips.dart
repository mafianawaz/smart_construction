import 'package:flutter/material.dart';

import '../models/daily_digest_models.dart';
import 'dd_palette.dart';

/// Small green agent tag, e.g. "A3".
class DdAgentTag extends StatelessWidget {
  final String code;

  const DdAgentTag({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: DdPalette.agentBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: DdPalette.agentFg,
        ),
      ),
    );
  }
}

/// CRITICAL / HIGH / MED / LOW chip.
class DdSeverityChip extends StatelessWidget {
  final DigestSeverity severity;

  const DdSeverityChip({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    final style = DdPalette.severityStyle(severity);
    return Container(
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
    );
  }
}

/// "Deduped from 2" — how many raw flags were merged into this item.
class DdDedupChip extends StatelessWidget {
  final int count;

  const DdDedupChip({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: DdPalette.surfaceMuted,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: DdPalette.border),
      ),
      child: Text(
        'Deduped from $count',
        style: const TextStyle(fontSize: 10.5, color: DdPalette.textSecondary),
      ),
    );
  }
}
