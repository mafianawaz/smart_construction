// Pure-Dart analytics for the CRM Analytics and Reports tabs (no Flutter
// imports). Everything is derived from the opportunity list, so when the
// backend later serves pre-aggregated numbers only this file needs swapping.

import '../models/crm_models.dart';

// ───────────────────────────── Report range ─────────────────────────────

enum ReportRange { last7, last30, last90, thisYear, allTime }

extension ReportRangeX on ReportRange {
  String get label {
    switch (this) {
      case ReportRange.last7:
        return 'Last 7 days';
      case ReportRange.last30:
        return 'Last 30 days';
      case ReportRange.last90:
        return 'Last 90 days';
      case ReportRange.thisYear:
        return 'This year';
      case ReportRange.allTime:
        return 'All time';
    }
  }

  /// Inclusive start of the range; `null` means unbounded.
  DateTime? startFrom(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    switch (this) {
      case ReportRange.last7:
        return today.subtract(const Duration(days: 7));
      case ReportRange.last30:
        return today.subtract(const Duration(days: 30));
      case ReportRange.last90:
        return today.subtract(const Duration(days: 90));
      case ReportRange.thisYear:
        return DateTime(now.year);
      case ReportRange.allTime:
        return null;
    }
  }
}

// ───────────────────────────── Result rows ─────────────────────────────

class FunnelRow {
  final OpportunityStage stage;
  final int count;
  final double pipeline;
  final double weighted;

  const FunnelRow({
    required this.stage,
    required this.count,
    required this.pipeline,
    required this.weighted,
  });
}

class ForecastMonth {
  /// First day of the month.
  final DateTime month;
  final int deals;
  final double total;
  final double weighted;

  const ForecastMonth({
    required this.month,
    required this.deals,
    required this.total,
    required this.weighted,
  });
}

class LostReasonRow {
  final String reason;
  final int count;
  final double value;

  const LostReasonRow({
    required this.reason,
    required this.count,
    required this.value,
  });
}

class RepRow {
  final String name;
  final int open;
  final int won;
  final int lost;
  final double openValue;
  final double wonValue;

  const RepRow({
    required this.name,
    required this.open,
    required this.won,
    required this.lost,
    required this.openValue,
    required this.wonValue,
  });

  int get winRatePercent {
    final closed = won + lost;
    return closed == 0 ? 0 : ((won / closed) * 100).round();
  }
}

class SourceRow {
  final String source;
  final int total;
  final int won;
  final double wonValue;

  const SourceRow({
    required this.source,
    required this.total,
    required this.won,
    required this.wonValue,
  });

  int get winRatePercent => total == 0 ? 0 : ((won / total) * 100).round();
}

class StageTimeRow {
  final OpportunityStage stage;
  final double avgDays;
  final int samples;

  const StageTimeRow({
    required this.stage,
    required this.avgDays,
    required this.samples,
  });
}

class WinLossSummary {
  final int won;
  final int lost;
  final double wonValue;
  final double lostValue;
  final int? avgDaysToWin;
  final List<LostReasonRow> lostReasons;

  const WinLossSummary({
    required this.won,
    required this.lost,
    required this.wonValue,
    required this.lostValue,
    required this.avgDaysToWin,
    required this.lostReasons,
  });

  bool get isEmpty => won + lost == 0;
  int get winRatePercent {
    final closed = won + lost;
    return closed == 0 ? 0 : ((won / closed) * 100).round();
  }

  double get avgWonDealSize => won == 0 ? 0 : wonValue / won;
}

// ───────────────────────────── Engine ─────────────────────────────

class CrmAnalytics {
  final List<OpportunityModel> opportunities;
  final DateTime now;

  const CrmAnalytics(this.opportunities, {required this.now});

  // ── Headline numbers (Analytics tab) ──

  List<OpportunityModel> get _open =>
      opportunities.where((o) => o.stage.isOpen).toList();
  List<OpportunityModel> get _won =>
      opportunities.where((o) => o.stage == OpportunityStage.won).toList();
  List<OpportunityModel> get _lost =>
      opportunities.where((o) => o.stage == OpportunityStage.lost).toList();

  double get openPipeline => _open.fold(0.0, (s, o) => s + o.value);
  double get weightedPipeline => _open.fold(0.0, (s, o) => s + o.weightedValue);
  int get openDeals => _open.length;
  int get wonCount => _won.length;
  int get lostCount => _lost.length;

  /// Won / (Won + Lost), whole percent; 0 when nothing is closed.
  int get winRatePercent {
    final closed = wonCount + lostCount;
    return closed == 0 ? 0 : ((wonCount / closed) * 100).round();
  }

  int? get avgDaysToWin => _avgDaysToWin(_won);

  static int? _avgDaysToWin(Iterable<OpportunityModel> won) {
    final days = <int>[];
    for (final o in won) {
      final created = o.createdAt;
      final closed = o.closedAt;
      if (created == null || closed == null) continue;
      final d = closed.difference(created).inDays;
      days.add(d < 0 ? 0 : d);
    }
    if (days.isEmpty) return null;
    return (days.reduce((a, b) => a + b) / days.length).round();
  }

  /// One row per stage, in pipeline order (always all stages).
  List<FunnelRow> funnel() {
    return [
      for (final stage in OpportunityStage.values)
        () {
          final inStage = opportunities.where((o) => o.stage == stage);
          return FunnelRow(
            stage: stage,
            count: inStage.length,
            pipeline: inStage.fold(0.0, (s, o) => s + o.value),
            weighted: inStage.fold(0.0, (s, o) => s + o.weightedValue),
          );
        }(),
    ];
  }

  /// Open deals that have an expected close date, grouped by month (sorted).
  List<ForecastMonth> forecastByMonth() {
    final buckets = <int, List<OpportunityModel>>{};
    for (final o in _open) {
      final d = o.expectedCloseDate;
      if (d == null) continue;
      buckets.putIfAbsent(d.year * 12 + d.month - 1, () => []).add(o);
    }
    final keys = buckets.keys.toList()..sort();
    return [
      for (final k in keys)
        ForecastMonth(
          month: DateTime(k ~/ 12, k % 12 + 1),
          deals: buckets[k]!.length,
          total: buckets[k]!.fold(0.0, (s, o) => s + o.value),
          weighted: buckets[k]!.fold(0.0, (s, o) => s + o.weightedValue),
        ),
    ];
  }

  List<LostReasonRow> lostReasons([Iterable<OpportunityModel>? source]) {
    final map = <String, List<OpportunityModel>>{};
    for (final o in source ?? _lost) {
      final r = (o.lostReason ?? '').trim();
      map.putIfAbsent(r.isEmpty ? 'No reason given' : r, () => []).add(o);
    }
    final rows = [
      for (final e in map.entries)
        LostReasonRow(
          reason: e.key,
          count: e.value.length,
          value: e.value.fold(0.0, (s, o) => s + o.value),
        ),
    ]..sort((a, b) => b.count.compareTo(a.count));
    return rows;
  }

  /// Assigned opportunities only, best closer first.
  List<RepRow> leaderboard() {
    final rows = _repRows(opportunities.where((o) => o.assignee != null));
    rows.sort((a, b) {
      final byWon = b.wonValue.compareTo(a.wonValue);
      if (byWon != 0) return byWon;
      final byOpen = b.openValue.compareTo(a.openValue);
      return byOpen != 0 ? byOpen : a.name.compareTo(b.name);
    });
    return rows;
  }

  List<SourceRow> sources() {
    final map = <String, List<OpportunityModel>>{};
    for (final o in opportunities) {
      map.putIfAbsent(o.sourceLabel, () => []).add(o);
    }
    final rows = [
      for (final e in map.entries)
        () {
          final won = e.value.where((o) => o.stage == OpportunityStage.won);
          return SourceRow(
            source: e.key,
            total: e.value.length,
            won: won.length,
            wonValue: won.fold(0.0, (s, o) => s + o.value),
          );
        }(),
    ]..sort((a, b) => b.total.compareTo(a.total));
    return rows;
  }

  // ── Reports ──

  bool _inRange(DateTime? date, DateTime? start) {
    if (start == null) return true;
    if (date == null) return false;
    return !date.isBefore(start);
  }

  /// Weighted revenue per month for the next [months] months (zero-filled).
  /// Deals with no expected close date, or one already in a past month, are
  /// not projected.
  List<ForecastMonth> monthlyProjection({int months = 6}) {
    final byKey = {
      for (final m in forecastByMonth()) m.month.year * 12 + m.month.month - 1: m,
    };
    return [
      for (var i = 0; i < months; i++)
        () {
          final month = DateTime(now.year, now.month + i);
          return byKey[month.year * 12 + month.month - 1] ??
              ForecastMonth(month: month, deals: 0, total: 0, weighted: 0);
        }(),
    ];
  }

  /// Won/Lost deals that closed inside [range] (closedAt, falling back to
  /// createdAt when the backend has no close time).
  List<OpportunityModel> closedIn(ReportRange range) {
    final start = range.startFrom(now);
    return opportunities.where((o) {
      if (o.stage != OpportunityStage.won && o.stage != OpportunityStage.lost) {
        return false;
      }
      return _inRange(o.closedAt ?? o.createdAt, start);
    }).toList();
  }

  WinLossSummary winLoss(ReportRange range) {
    final closed = closedIn(range);
    final won = closed.where((o) => o.stage == OpportunityStage.won).toList();
    final lost = closed.where((o) => o.stage == OpportunityStage.lost).toList();
    return WinLossSummary(
      won: won.length,
      lost: lost.length,
      wonValue: won.fold(0.0, (s, o) => s + o.value),
      lostValue: lost.fold(0.0, (s, o) => s + o.value),
      avgDaysToWin: _avgDaysToWin(won),
      lostReasons: lostReasons(lost),
    );
  }

  /// Average days spent in each *completed* stay (a stage the deal has since
  /// left). The stage a deal is currently sitting in is excluded.
  List<StageTimeRow> timeInStage(ReportRange range) {
    final start = range.startFrom(now);
    final samples = <OpportunityStage, List<double>>{};
    for (final o in opportunities) {
      final history = [...o.stageHistory]
        ..sort((a, b) => a.enteredAt.compareTo(b.enteredAt));
      for (var i = 0; i < history.length - 1; i++) {
        final t = history[i];
        if (!t.stage.isOpen) continue;
        if (start != null && t.enteredAt.isBefore(start)) continue;
        final hours = history[i + 1].enteredAt.difference(t.enteredAt).inHours;
        samples.putIfAbsent(t.stage, () => []).add(hours / 24.0);
      }
    }
    return [
      for (final stage in OpportunityStage.values)
        if (samples[stage] != null)
          StageTimeRow(
            stage: stage,
            avgDays:
                samples[stage]!.reduce((a, b) => a + b) / samples[stage]!.length,
            samples: samples[stage]!.length,
          ),
    ];
  }

  /// Per-assignee breakdown of deals created inside [range].
  List<RepRow> repPerformance(ReportRange range) {
    final start = range.startFrom(now);
    final rows =
        _repRows(opportunities.where((o) => _inRange(o.createdAt, start)));
    rows.sort((a, b) => b.wonValue.compareTo(a.wonValue));
    return rows;
  }

  List<RepRow> _repRows(Iterable<OpportunityModel> source) {
    final map = <String, List<OpportunityModel>>{};
    for (final o in source) {
      map.putIfAbsent(o.assigneeLabel, () => []).add(o);
    }
    return [
      for (final e in map.entries)
        () {
          final list = e.value;
          final won = list.where((o) => o.stage == OpportunityStage.won);
          return RepRow(
            name: e.key,
            open: list.where((o) => o.stage.isOpen).length,
            won: won.length,
            lost: list.where((o) => o.stage == OpportunityStage.lost).length,
            openValue: list
                .where((o) => o.stage.isOpen)
                .fold(0.0, (s, o) => s + o.value),
            wonValue: won.fold(0.0, (s, o) => s + o.value),
          );
        }(),
    ];
  }

  // ── CSV exports ──

  String winLossCsv(ReportRange range) {
    final rows = <List<Object?>>[
      ['Title', 'Organization', 'Outcome', 'Value', 'Assignee', 'Source', 'Lost reason', 'Closed'],
      for (final o in closedIn(range))
        [
          o.title,
          o.organizationName,
          o.stage.label,
          o.value.round(),
          o.assigneeLabel,
          o.sourceLabel,
          o.lostReason ?? '',
          _iso(o.closedAt),
        ],
    ];
    return _csv(rows);
  }

  String timeInStageCsv(ReportRange range) {
    return _csv([
      ['Stage', 'Average days', 'Samples'],
      for (final r in timeInStage(range))
        [r.stage.label, r.avgDays.toStringAsFixed(1), r.samples],
    ]);
  }

  String repPerformanceCsv(ReportRange range) {
    return _csv([
      ['Rep', 'Open', 'Won', 'Lost', 'Win rate %', 'Open value', 'Won value'],
      for (final r in repPerformance(range))
        [r.name, r.open, r.won, r.lost, r.winRatePercent, r.openValue.round(), r.wonValue.round()],
    ]);
  }

  static String _iso(DateTime? d) => d == null
      ? ''
      : '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _csv(List<List<Object?>> rows) {
    String cell(Object? v) {
      final s = '${v ?? ''}';
      return RegExp(r'[",\n]').hasMatch(s) ? '"${s.replaceAll('"', '""')}"' : s;
    }

    return rows.map((r) => r.map(cell).join(',')).join('\n');
  }
}
