import 'package:flutter/material.dart';
import '../data/safety_format.dart';
import '../models/safety_models.dart';
import 'safety_common_widgets.dart';
import 'safety_palette.dart';

/// "TOTAL RECORDABLE  0  [icon]" tile in the Annual Summary card.
class OshaSummaryTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final Color? iconColor;

  const OshaSummaryTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      decoration: BoxDecoration(
        color: SafetyPalette.surfaceMuted.withAlpha(110),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SafetyPalette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8.5,
                    letterSpacing: 0.3,
                    color: SafetyPalette.textFaint,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? SafetyPalette.textDark,
                  ),
                ),
              ],
            ),
          ),
          Icon(icon, size: 18, color: iconColor ?? SafetyPalette.textFaint),
        ],
      ),
    );
  }
}

/// A row in the OSHA 300 log.
class OshaLogEntryTile extends StatelessWidget {
  final OshaLogEntry entry;

  const OshaLogEntryTile({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SafetyPalette.surfaceMuted.withAlpha(110),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SafetyPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Case ${entry.caseNumber}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: SafetyPalette.textDark,
                ),
              ),
              const Spacer(),
              SafetyTonePill(
                label: entry.classification.label,
                tone: entry.classification.tone,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${entry.employee} · ${entry.jobTitle}',
            style: const TextStyle(
              fontSize: 11.5,
              color: SafetyPalette.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            entry.description,
            style: const TextStyle(
              fontSize: 11,
              color: SafetyPalette.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            SafetyFormat.date(entry.date),
            style: const TextStyle(
              fontSize: 10,
              color: SafetyPalette.textFaint,
            ),
          ),
        ],
      ),
    );
  }
}
