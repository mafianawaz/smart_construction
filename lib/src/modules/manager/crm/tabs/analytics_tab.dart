import 'package:flutter/material.dart';

import '../analytics/crm_analytics.dart';
import '../logic.dart';
import '../widgets/crm_card.dart';
import '../widgets/crm_charts.dart';
import '../widgets/crm_metric_card.dart';
import '../widgets/crm_palette.dart';

/// Analytics tab: headline metrics, pipeline funnel, forecast + lost reasons,
/// sales leaderboard and source effectiveness. Everything is derived from the
/// opportunity list via [CrmAnalytics], so it matches the Pipeline tab.
class AnalyticsTab extends StatelessWidget {
  final CrmLogic logic;

  const AnalyticsTab({super.key, required this.logic});

  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  Widget build(BuildContext context) {
    final a = logic.analytics;
    final forecast = a.forecastByMonth();
    final lostReasons = a.lostReasons();
    final leaderboard = a.leaderboard();
    final sources = a.sources();

    return ListView(
      children: [
        CrmMetricGrid(
          items: [
            CrmMetricItem(
              label: 'Open Pipeline',
              value: crmMoney(a.openPipeline),
              icon: Icons.attach_money,
            ),
            CrmMetricItem(
              label: 'Weighted',
              value: crmMoney(a.weightedPipeline),
              icon: Icons.trending_up,
            ),
            CrmMetricItem(
              label: 'Won',
              value: '${a.wonCount}',
              icon: Icons.star_border,
            ),
            CrmMetricItem(
              label: 'Lost',
              value: '${a.lostCount}',
              icon: Icons.warning_amber_rounded,
            ),
            CrmMetricItem(
              label: 'Win Rate',
              value: '${a.winRatePercent}%',
              icon: Icons.adjust,
            ),
            CrmMetricItem(
              label: 'Avg Days to Win',
              value: '${a.avgDaysToWin ?? 0}',
              icon: Icons.schedule,
            ),
          ],
        ),
        const SizedBox(height: 12),
        CrmCard(
          title: 'Pipeline Funnel',
          child: CrmFunnelChart(rows: a.funnel()),
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: CrmCard(
                  title: 'Forecast',
                  subtitle: '(Open Deals by Close Month)',
                  padding: const EdgeInsets.all(12),
                  child: forecast.isEmpty
                      ? const CrmCardEmpty('No deals with expected close dates.')
                      : Column(
                          children: [
                            for (final m in forecast)
                              _KeyValueRow(
                                title: '${_monthNames[m.month.month - 1]} ${m.month.year}',
                                subtitle:
                                    '${m.deals} deal${m.deals == 1 ? '' : 's'}',
                                value: crmCompactMoney(m.weighted),
                              ),
                          ],
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CrmCard(
                  title: 'Lost Reasons',
                  padding: const EdgeInsets.all(12),
                  child: lostReasons.isEmpty
                      ? const CrmCardEmpty('No lost deals yet.')
                      : Column(
                          children: [
                            for (final r in lostReasons)
                              _KeyValueRow(
                                title: r.reason,
                                subtitle: crmCompactMoney(r.value),
                                value: '${r.count}',
                              ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        CrmCard(
          title: 'Sales Leaderboard',
          child: leaderboard.isEmpty
              ? const CrmCardEmpty('No assigned opportunities.')
              : Column(
                  children: [
                    for (var i = 0; i < leaderboard.length; i++)
                      _LeaderRow(rank: i + 1, row: leaderboard[i]),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        CrmCard(
          title: 'Source Effectiveness',
          child: sources.isEmpty
              ? const CrmCardEmpty('No opportunities yet.')
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - 10) / 2;
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final s in sources)
                          SizedBox(width: width, child: _SourceTile(row: s)),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Title + muted subtitle on the left, bold value on the right.
class _KeyValueRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;

  const _KeyValueRow({
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: CrmPalette.text,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeaderRow extends StatelessWidget {
  final int rank;
  final RepRow row;

  const _LeaderRow({required this.rank, required this.row});

  @override
  Widget build(BuildContext context) {
    final first = rank == 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: first ? CrmPalette.orangeTint : CrmPalette.chipFill,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$rank',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: first ? CrmPalette.orange : CrmPalette.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: CrmPalette.text,
                  ),
                ),
                Text(
                  '${row.won} won · ${row.open} open · ${row.winRatePercent}% win rate',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: CrmPalette.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            crmCompactMoney(row.wonValue),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: CrmPalette.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceTile extends StatelessWidget {
  final SourceRow row;

  const _SourceTile({required this.row});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            row.source,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9.5,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w700,
              color: CrmPalette.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            crmMoney(row.wonValue),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CrmPalette.text,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${row.won}/${row.total} won · ${row.winRatePercent}%',
            style: const TextStyle(fontSize: 10, color: CrmPalette.textMuted),
          ),
        ],
      ),
    );
  }
}
