import 'package:flutter/material.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import '../logic.dart';
import '../widgets/reward_widgets.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';

/// Workforce → Rewards ("My Rewards": totals + awarded list).
class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Row(
          children: [
            Icon(Icons.mode_comment_outlined, size: 17, color: WfPalette.orange),
            SizedBox(width: 8),
            Text(
              'My Rewards',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: WfPalette.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        WfStatGrid(
          tiles: [
            WfStatTile(
              icon: Icons.star_border,
              value: '${logic.totalRewards}',
              label: 'Total Rewards',
              valueColor: WfPalette.orange,
            ),
            WfStatTile(
              icon: Icons.star_border,
              value: wfThousands(logic.pointsEarned),
              label: 'Points Earned',
              valueColor: WfPalette.orange,
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (logic.rewards.isEmpty)
          const AppEmptyState(
            icon: Icons.emoji_events_outlined,
            title: 'No rewards yet',
            message: 'Recognition and rewards you earn will appear here.',
            showButton: false,
          )
        else
          for (final r in logic.rewards) RewardCard(reward: r),
      ],
    );
  }
}
