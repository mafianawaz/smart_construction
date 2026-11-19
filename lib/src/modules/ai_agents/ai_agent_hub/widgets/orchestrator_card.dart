import 'package:flutter/material.dart';

import '../models/ai_agent_models.dart';
import 'ai_agents_palette.dart';
import 'ai_flag_chip.dart';
import 'ai_key_value_row.dart';
import 'ai_status_pill.dart';

/// Tinted card at the top of the digest: orchestrator description, the
/// "Today's digest" CTA, run times, stacked open-flag counts and pending
/// reviews, with links that jump to the Flags / Review queue tabs.
class OrchestratorCard extends StatelessWidget {
  final OrchestratorModel orchestrator;
  final int pendingReviews;
  final VoidCallback onDigestTap;
  final VoidCallback onFlagsTap;
  final VoidCallback onReviewQueueTap;

  const OrchestratorCard({
    super.key,
    required this.orchestrator,
    required this.pendingReviews,
    required this.onDigestTap,
    required this.onFlagsTap,
    required this.onReviewQueueTap,
  });

  @override
  Widget build(BuildContext context) {
    final severities = FlagSeverity.values;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AiAgentsPalette.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AiAgentsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            orchestrator.headline,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              height: 1.35,
              color: AiAgentsPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: onDigestTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: AiAgentsPalette.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Today's digest",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AiKeyValueRow(
            label: 'Status',
            valueWidget: Align(
              alignment: Alignment.centerLeft,
              child: AiStatusPill(enabled: orchestrator.enabled),
            ),
          ),
          const SizedBox(height: 10),
          AiKeyValueRow(
            label: 'Last run · next run',
            value: '${orchestrator.lastRun} · ${orchestrator.nextRun}',
          ),
          const SizedBox(height: 10),
          AiKeyValueRow(
            label: 'Open flags',
            valueWidget: orchestrator.flags.isEmpty
                ? const Text(
                    '—',
                    style: TextStyle(
                      fontSize: 12,
                      color: AiAgentsPalette.textMuted,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final s in severities)
                        if (orchestrator.flags.countFor(s) > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AiFlagChip(
                                  severity: s,
                                  count: orchestrator.flags.countFor(s),
                                ),
                                if (s == FlagSeverity.low) ...[
                                  const SizedBox(width: 6),
                                  AiLinkText(
                                    text: '→ Flags',
                                    onTap: onFlagsTap,
                                  ),
                                ],
                              ],
                            ),
                          ),
                    ],
                  ),
          ),
          const SizedBox(height: 4),
          AiKeyValueRow(
            label: 'Pending reviews',
            valueWidget: Row(
              children: [
                Text(
                  '$pendingReviews',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AiAgentsPalette.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                AiLinkText(text: '→ Review queue', onTap: onReviewQueueTap),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
