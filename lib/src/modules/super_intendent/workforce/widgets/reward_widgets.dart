import 'package:flutter/material.dart';

import '../models/reward_model.dart';
import '../models/worker_model.dart';
import 'wf_common.dart';
import 'wf_palette.dart';

IconData _iconFor(RewardIconKind k) {
  switch (k) {
    case RewardIconKind.champion:
      return Icons.workspace_premium_outlined;
    case RewardIconKind.topPerformer:
      return Icons.emoji_events_outlined;
    case RewardIconKind.earlyBird:
      return Icons.access_time;
    case RewardIconKind.teamPlayer:
      return Icons.groups_outlined;
    case RewardIconKind.star:
      return Icons.star_border;
  }
}

/// One awarded reward: round icon, title/description, date + awarder, points.
class RewardCard extends StatelessWidget {
  const RewardCard({super.key, required this.reward});
  final RewardModel reward;

  @override
  Widget build(BuildContext context) {
    final r = reward;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: WfPalette.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WfPalette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: WfPalette.orangeSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(_iconFor(r.icon), size: 17, color: WfPalette.orange),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  r.description,
                  style: const TextStyle(fontSize: 10.5, color: WfPalette.muted),
                ),
                const SizedBox(height: 6),
                Text(
                  WorkforceDates.full(r.awardedOn),
                  style: const TextStyle(fontSize: 9.5, color: WfPalette.hint),
                ),
                Text(
                  'Awarded by: ${r.awardedBy}',
                  style: const TextStyle(fontSize: 9.5, color: WfPalette.hint),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '+${wfThousands(r.points)} pts',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: WfPalette.orange,
            ),
          ),
        ],
      ),
    );
  }
}
