import 'package:flutter/material.dart';
import '../models/portfolio_benchmark.dart';
import '../models/portfolio_format.dart';
import 'report_palette.dart';
import 'report_primitives.dart';

/// One organization in "Organization Comparison": status, type, Relative
/// Performance Index bar and per-metric value + rank rows. The top-ranked
/// organization gets the orange border and orange bar.
class BenchmarkOrgCard extends StatelessWidget {
  const BenchmarkOrgCard({
    super.key,
    required this.result,
    required this.isLeader,
  });

  final OrgBenchmarkResult result;
  final bool isLeader;

  @override
  Widget build(BuildContext context) {
    final org = result.org;
    return ReportCard(
      highlight: isLeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  org.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ReportPalette.text,
                  ),
                ),
              ),
              ReportStatusPill(status: org.status),
            ],
          ),
          const SizedBox(height: 6),
          ReportTypeTag(org.typeLabel),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Relative Performance Index',
                  style: TextStyle(fontSize: 10.5, color: ReportPalette.body),
                ),
              ),
              Text(
                PortfolioFormat.percent(result.index),
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: ReportPalette.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _PerformanceBar(fraction: result.index / 100, leader: isLeader),
          const SizedBox(height: 14),
          for (final metric in BenchmarkMetric.values)
            _MetricRow(
              label: metric.label,
              value: metric.format(org),
              rank: result.ranks[metric] ?? 0,
            ),
        ],
      ),
    );
  }
}

class _PerformanceBar extends StatelessWidget {
  const _PerformanceBar({required this.fraction, required this.leader});

  final double fraction;
  final bool leader;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 5,
        child: Stack(
          children: [
            Container(color: ReportPalette.track),
            FractionallySizedBox(
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(
                color: leader
                    ? ReportPalette.primary
                    : const Color(0xFFCBD5E1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.rank,
  });

  final String label;
  final String value;
  final int rank;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: ReportPalette.body),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: ReportPalette.text,
            ),
          ),
          const SizedBox(width: 8),
          // Fixed width keeps the values aligned whether or not a row has the
          // wider "#1" trophy badge.
          SizedBox(
            width: 38,
            child: Align(
              alignment: Alignment.centerRight,
              child: ReportRankBadge(rank),
            ),
          ),
        ],
      ),
    );
  }
}
