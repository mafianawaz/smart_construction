import '../models/portfolio_report_models.dart';
import 'portfolio_format.dart';

/// Metrics organizations are ranked on. Higher is better for every metric.
enum BenchmarkMetric {
  activeProjects,
  bidPipeline,
  employees,
  efficiency,
  pendingCos,
}

extension BenchmarkMetricX on BenchmarkMetric {
  /// Row label in the Organization Comparison cards.
  String get label {
    switch (this) {
      case BenchmarkMetric.activeProjects:
        return 'Active Projects';
      case BenchmarkMetric.bidPipeline:
        return 'Bid Pipeline';
      case BenchmarkMetric.employees:
        return 'Employees';
      case BenchmarkMetric.efficiency:
        return 'Efficiency';
      case BenchmarkMetric.pendingCos:
        return 'Pending COs';
    }
  }

  /// Caption on the Benchmarking Summary ranking cards.
  String get rankingTitle {
    switch (this) {
      case BenchmarkMetric.activeProjects:
        return 'MOST ACTIVE PROJECTS';
      case BenchmarkMetric.bidPipeline:
        return 'LARGEST BID PIPELINE';
      case BenchmarkMetric.employees:
        return 'MOST EMPLOYEES';
      case BenchmarkMetric.efficiency:
        return 'BEST EFFICIENCY';
      case BenchmarkMetric.pendingCos:
        return 'MOST PENDING COS';
    }
  }

  double valueOf(PortfolioOrgMetrics o) {
    switch (this) {
      case BenchmarkMetric.activeProjects:
        return o.activeProjects.toDouble();
      case BenchmarkMetric.bidPipeline:
        return o.bidPipeline;
      case BenchmarkMetric.employees:
        return o.employees.toDouble();
      case BenchmarkMetric.efficiency:
        return o.efficiency;
      case BenchmarkMetric.pendingCos:
        return o.pendingCos.toDouble();
    }
  }

  String format(PortfolioOrgMetrics o) {
    switch (this) {
      case BenchmarkMetric.activeProjects:
        return '${o.activeProjects}';
      case BenchmarkMetric.bidPipeline:
        return PortfolioFormat.moneyK(o.bidPipeline);
      case BenchmarkMetric.employees:
        return '${o.employees}';
      case BenchmarkMetric.efficiency:
        return PortfolioFormat.efficiency(o.efficiency);
      case BenchmarkMetric.pendingCos:
        return '${o.pendingCos}';
    }
  }
}

/// The four metrics that get a "leader" card in the Benchmarking Summary.
const List<BenchmarkMetric> kRankingCardMetrics = [
  BenchmarkMetric.activeProjects,
  BenchmarkMetric.bidPipeline,
  BenchmarkMetric.employees,
  BenchmarkMetric.efficiency,
];

class OrgBenchmarkResult {
  const OrgBenchmarkResult({
    required this.org,
    required this.index,
    required this.ranks,
  });

  final PortfolioOrgMetrics org;

  /// Relative Performance Index, 5..100 (percent).
  final double index;
  final Map<BenchmarkMetric, int> ranks;
}

class PortfolioBenchmark {
  const PortfolioBenchmark({required this.results, required this.leaders});

  /// Sorted by [OrgBenchmarkResult.index], best first.
  final List<OrgBenchmarkResult> results;

  /// Organization with the highest value per metric, or null when every
  /// organization is at zero.
  final Map<BenchmarkMetric, PortfolioOrgMetrics?> leaders;

  OrgBenchmarkResult? get topResult => results.isEmpty ? null : results.first;

  /// Pure function of the organization list, so both screens agree.
  static PortfolioBenchmark compute(List<PortfolioOrgMetrics> orgs) {
    const metrics = BenchmarkMetric.values;

    final maxes = <BenchmarkMetric, double>{
      for (final m in metrics)
        m: orgs.fold<double>(0, (a, o) => m.valueOf(o) > a ? m.valueOf(o) : a),
    };

    final results = <OrgBenchmarkResult>[
      for (final org in orgs)
        OrgBenchmarkResult(
          org: org,
          index: _index(org, metrics, maxes),
          ranks: {
            for (final m in metrics)
              // Rank = number of organizations with a value >= this one, so
              // organizations tied at the bottom share the lowest place
              // (matches the reference: two idle orgs both show #3).
              m: orgs.where((o) => m.valueOf(o) >= m.valueOf(org)).length,
          },
        ),
    ];
    // Dart's sort is not guaranteed stable; break ties by input order.
    final order = {for (var i = 0; i < orgs.length; i++) orgs[i].id: i};
    results.sort((a, b) {
      final byIndex = b.index.compareTo(a.index);
      if (byIndex != 0) return byIndex;
      return order[a.org.id]!.compareTo(order[b.org.id]!);
    });

    final leaders = <BenchmarkMetric, PortfolioOrgMetrics?>{};
    for (final m in metrics) {
      PortfolioOrgMetrics? best;
      for (final o in orgs) {
        if (m.valueOf(o) <= 0) continue;
        if (best == null || m.valueOf(o) > m.valueOf(best)) best = o;
      }
      leaders[m] = best;
    }

    return PortfolioBenchmark(results: results, leaders: leaders);
  }

  /// Placeholder formula: mean of (value / best value) across all metrics,
  /// as a percentage, never below 5% so the bar stays visible.
  static double _index(
    PortfolioOrgMetrics org,
    List<BenchmarkMetric> metrics,
    Map<BenchmarkMetric, double> maxes,
  ) {
    var sum = 0.0;
    for (final m in metrics) {
      final max = maxes[m] ?? 0;
      if (max > 0) sum += m.valueOf(org) / max;
    }
    final pct = sum / metrics.length * 100;
    return pct < 5 ? 5 : (pct > 100 ? 100 : pct);
  }
}
