import 'package:flutter/material.dart';
import '../logic.dart';
import '../widgets/kpi_assignment_widgets.dart';
import '../widgets/wf_common.dart';
import '../widgets/wf_palette.dart';

/// Performance → Analytics: the signed-in user's own rating/KPI summary.
class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key, required this.logic});
  final WorkforceLogic logic;

  @override
  Widget build(BuildContext context) {
    final mine = logic.myResults;
    return ListView(
      children: [
        WfStatGrid(
          tiles: [
            WfStatTile(
              icon: Icons.star_border,
              value: '${logic.totalRatings}',
              label: 'Total Ratings',
            ),
            WfStatTile(
              icon: Icons.trending_up,
              value: logic.averageScore.toStringAsFixed(1),
              label: 'Average Score',
            ),
            WfStatTile(
              icon: Icons.track_changes,
              value: '${logic.myActiveKpis}',
              label: 'Active KPIs',
            ),
            WfStatTile(
              icon: Icons.bar_chart,
              value: '${logic.myAchievementPercent}%',
              label: 'KPI Achievement',
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: WfPalette.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'My KPI Performance',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: WfPalette.text,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (mine.isEmpty)
          const WfDashedBox(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor: WfPalette.fill,
                  child: Icon(Icons.shield_outlined, size: 20, color: WfPalette.hint),
                ),
                SizedBox(height: 12),
                Text(
                  'No KPIs Assigned',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: WfPalette.text,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "You don't have any KPIs assigned yet. Your manager will assign KPIs with target values for you to track.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: WfPalette.muted),
                ),
              ],
            ),
          )
        else
          for (final r in mine) KpiResultCard(result: r),
      ],
    );
  }
}
