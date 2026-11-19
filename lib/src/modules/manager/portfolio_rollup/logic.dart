import 'dart:math' as math;

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'data/portfolio_rollup_mock_data.dart';
import 'models/rollup_enums.dart';
import 'models/rollup_project_model.dart';

/// Roll-up of one filtered list: what the Health Heatmap summary row shows.
class RollupSummary {
  const RollupSummary({
    required this.count,
    required this.avgHealth,
    required this.avgSpi,
    required this.avgCpi,
  });

  final int count;
  final double avgHealth;
  final double avgSpi;
  final double avgCpi;
}

/// Where a project's bar sits inside the portfolio's overall date range,
/// both as 0..1 fractions of the track width.
class GanttSegment {
  const GanttSegment({required this.left, required this.width});
  final double left;
  final double width;
}

/// State for the Portfolio Rollup screen.
///
/// Uses `GetBuilder` + `update()` on plain fields (same pattern as
/// `PricingLogic`), not `Rx`/`Obx`.
///
/// Shared across all three tabs: PM, Start After, End Before, Min Health.
/// Per tab: the status chip selection (the reference shows ACTIVE only on the
/// heatmap and all four statuses on Gantt / Financial). An empty selection
/// means "no status filter".
class PortfolioRollupLogic extends GetxController {
  // ── state ────────────────────────────────────────────────────────────
  RollupTab tab = RollupTab.heatmap;
  bool isLoading = true;
  List<RollupProject> all = [];

  String? pm; // null = Any PM
  DateTime? startAfter;
  DateTime? endBefore;
  double minHealth = 0;

  static const List<RollupStatus> _heatmapStatuses = RollupStatus.values;
  static const List<RollupStatus> _timelineStatuses = [
    RollupStatus.planning,
    RollupStatus.active,
    RollupStatus.complete,
    RollupStatus.closed,
  ];

  final Map<RollupTab, Set<RollupStatus>> _selected = {
    RollupTab.heatmap: {RollupStatus.active},
    RollupTab.gantt: {..._timelineStatuses},
    RollupTab.financial: {..._timelineStatuses},
  };

  // ── lifecycle ────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading = true;
    update();
    // API seam: see PortfolioRollupMockData.fetchProjects.
    all = await PortfolioRollupMockData.fetchProjects();
    isLoading = false;
    update();
  }

  // ── tab / status ─────────────────────────────────────────────────────
  void selectTab(RollupTab t) {
    if (t == tab) return;
    tab = t;
    update();
  }

  /// Chips offered by [t]: heatmap has BID, the other two do not.
  List<RollupStatus> availableStatuses(RollupTab t) =>
      t == RollupTab.heatmap ? _heatmapStatuses : _timelineStatuses;

  Set<RollupStatus> selectedStatuses(RollupTab t) => _selected[t]!;

  void toggleStatus(RollupStatus s) {
    final set = _selected[tab]!;
    if (!set.remove(s)) set.add(s);
    update();
  }

  // ── shared filters ───────────────────────────────────────────────────
  List<String> get pmOptions {
    final names = all.map((p) => p.pm).whereType<String>().toSet().toList()
      ..sort();
    return names;
  }

  void setPm(String? v) {
    pm = v;
    update();
  }

  void setStartAfter(DateTime? v) {
    startAfter = v;
    update();
  }

  void setEndBefore(DateTime? v) {
    endBefore = v;
    update();
  }

  void setMinHealth(double v) {
    minHealth = v.roundToDouble();
    update();
  }

  bool get hasActiveFilters =>
      pm != null || startAfter != null || endBefore != null || minHealth > 0;

  /// Resets PM / dates / min health. Status chips are left alone: they are a
  /// view choice, not a filter field.
  void clearFilters() {
    pm = null;
    startAfter = null;
    endBefore = null;
    minHealth = 0;
    update();
  }

  // ── derived lists ────────────────────────────────────────────────────
  List<RollupProject> get filtered {
    final available = availableStatuses(tab);
    final selected = selectedStatuses(tab);
    return all.where((p) {
      if (!available.contains(p.status)) return false;
      if (selected.isNotEmpty && !selected.contains(p.status)) return false;
      if (pm != null && p.pm != pm) return false;
      final s = startAfter;
      if (s != null && (p.start == null || p.start!.isBefore(s))) return false;
      final e = endBefore;
      if (e != null && (p.end == null || p.end!.isAfter(e))) return false;
      if (p.health < minHealth) return false;
      return true;
    }).toList();
  }

  RollupSummary get summary {
    final list = filtered;
    if (list.isEmpty) {
      return const RollupSummary(
          count: 0, avgHealth: 0, avgSpi: 0, avgCpi: 0);
    }
    double avg(double Function(RollupProject) f) =>
        list.fold<double>(0, (a, p) => a + f(p)) / list.length;
    return RollupSummary(
      count: list.length,
      avgHealth: avg((p) => p.health),
      avgSpi: avg((p) => p.spi),
      avgCpi: avg((p) => p.cpi),
    );
  }

  // ── gantt maths ──────────────────────────────────────────────────────
  /// Bars are positioned against the whole portfolio's date range (not the
  /// filtered one) so a bar doesn't jump when a chip is toggled.
  GanttSegment? ganttSegment(RollupProject p) {
    final s = p.start;
    final e = p.end;
    if (s == null || e == null) return null;

    DateTime? rangeStart;
    DateTime? rangeEnd;
    for (final q in all) {
      if (q.start != null &&
          (rangeStart == null || q.start!.isBefore(rangeStart))) {
        rangeStart = q.start;
      }
      if (q.end != null && (rangeEnd == null || q.end!.isAfter(rangeEnd))) {
        rangeEnd = q.end;
      }
    }
    if (rangeStart == null || rangeEnd == null) return null;

    final span = math.max(1, rangeEnd.difference(rangeStart).inDays);
    final width =
        (e.difference(s).inDays / span).clamp(0.02, 1.0).toDouble();
    final left = (s.difference(rangeStart).inDays / span)
        .clamp(0.0, 1.0 - width)
        .toDouble();
    return GanttSegment(left: left, width: width);
  }

  // ── export ───────────────────────────────────────────────────────────
  /// CSV of the current tab's filtered rows.
  ///
  /// Export seam: the screen currently copies this to the clipboard. Swap for
  /// a real share sheet / PDF once a file-handling package is confirmed
  /// (or POST /portfolio/rollup/export for a server-built summary).
  String buildExportCsv() {
    final df = DateFormat('yyyy-MM-dd');
    String d(DateTime? v) => v == null ? '' : df.format(v);
    String q(String? v) {
      final s = v ?? '';
      return s.contains(RegExp(r'[",\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
    }

    final rows = <List<String>>[];
    switch (tab) {
      case RollupTab.heatmap:
        rows.add(['ID', 'Project', 'PM', 'Status', 'Health', 'SPI', 'CPI',
          'Open RFIs', 'Open COs', 'Punch']);
        for (final p in filtered) {
          rows.add([
            p.code, p.name, p.pm ?? '', p.status.label,
            formatHealth(p.health), formatRatio(p.spi), formatRatio(p.cpi),
            '${p.openRfis}', '${p.openCos}', '${p.punch}',
          ]);
        }
      case RollupTab.gantt:
        rows.add(['ID', 'Project', 'PM', 'Status', 'Start', 'End']);
        for (final p in filtered) {
          rows.add([
            p.code, p.name, p.pm ?? '', p.status.label, d(p.start), d(p.end),
          ]);
        }
      case RollupTab.financial:
        rows.add(['ID', 'Project', 'PM', 'Status', 'Contract', 'Actual',
          'Variance %']);
        for (final p in filtered) {
          rows.add([
            p.code, p.name, p.pm ?? '', p.status.label,
            p.contract.toStringAsFixed(0), p.actual.toStringAsFixed(0),
            formatHealth(p.variancePct),
          ]);
        }
    }
    return rows.map((r) => r.map(q).join(',')).join('\n');
  }
}
