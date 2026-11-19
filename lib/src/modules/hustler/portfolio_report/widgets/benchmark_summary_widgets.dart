import 'package:flutter/material.dart';
import '../models/portfolio_benchmark.dart';
import '../models/portfolio_report_models.dart';
import 'report_palette.dart';
import 'report_primitives.dart';

/// One labelled value in a portfolio summary grid.
class SummaryStat {
  const SummaryStat({required this.label, required this.value, this.icon});

  final String label;
  final String value;

  /// Only used by the Organization Benchmarking grid (icon top-right).
  final IconData? icon;
}

/// Compact 3-column grid of centered stat tiles ("Benchmarking Summary" on
/// the Portfolio Report screen).
class CompactSummaryGrid extends StatelessWidget {
  const CompactSummaryGrid({super.key, required this.stats});

  final List<SummaryStat> stats;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < stats.length; i += 3) {
      final slice = stats.skip(i).take(3).toList();
      rows.add(
        Row(
          children: [
            for (var j = 0; j < 3; j++) ...[
              if (j > 0) const SizedBox(width: 8),
              Expanded(
                child: j < slice.length
                    ? _CompactTile(stat: slice[j])
                    : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      );
      if (i + 3 < stats.length) rows.add(const SizedBox(height: 8));
    }
    return Column(children: rows);
  }
}

class _CompactTile extends StatelessWidget {
  const _CompactTile({required this.stat});

  final SummaryStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ReportPalette.border),
      ),
      child: Column(
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: ReportPalette.body),
          ),
          const SizedBox(height: 6),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ReportPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// Two-column grid of larger tiles with a trailing icon (Portfolio Summary on
/// the Organization Benchmarking screen).
class IconSummaryGrid extends StatelessWidget {
  const IconSummaryGrid({super.key, required this.stats});

  final List<SummaryStat> stats;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < stats.length; i += 2) {
      final left = stats[i];
      final right = i + 1 < stats.length ? stats[i + 1] : null;
      rows.add(
        Row(
          children: [
            Expanded(child: _IconTile(stat: left)),
            const SizedBox(width: 10),
            Expanded(
              child: right == null
                  ? const SizedBox.shrink()
                  : _IconTile(stat: right),
            ),
          ],
        ),
      );
      if (i + 2 < stats.length) rows.add(const SizedBox(height: 10));
    }
    return Column(children: rows);
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.stat});

  final SummaryStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ReportPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  stat.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: ReportPalette.body,
                  ),
                ),
              ),
              if (stat.icon != null)
                Icon(stat.icon, size: 14, color: ReportPalette.muted),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ReportPalette.text,
            ),
          ),
        ],
      ),
    );
  }
}

/// "MOST ACTIVE PROJECTS — #1 Dev Sandbox Organization" card.
class RankingCard extends StatelessWidget {
  const RankingCard({
    super.key,
    required this.metric,
    required this.leader,
  });

  final BenchmarkMetric metric;

  /// Null when every organization is at zero for this metric.
  final PortfolioOrgMetrics? leader;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ReportPalette.cardFill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ReportPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.rankingTitle,
            style: const TextStyle(
              fontSize: 9.5,
              letterSpacing: 0.4,
              fontWeight: FontWeight.w600,
              color: ReportPalette.muted,
            ),
          ),
          const SizedBox(height: 6),
          if (leader == null)
            const Text(
              '—',
              style: TextStyle(fontSize: 13, color: ReportPalette.muted),
            )
          else
            Row(
              children: [
                const ReportRankBadge(1),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    leader!.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ReportPalette.text,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
