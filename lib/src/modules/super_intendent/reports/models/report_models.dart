enum ReportGroup { takeoff, estimate }

extension ReportGroupX on ReportGroup {
  String get label => switch (this) {
        ReportGroup.takeoff => 'TAKEOFF REPORTS',
        ReportGroup.estimate => 'ESTIMATE REPORTS',
      };
}

enum ReportDateRange { allTime, last30Days, last90Days }

extension ReportDateRangeX on ReportDateRange {
  String get label => switch (this) {
        ReportDateRange.allTime => 'All time',
        ReportDateRange.last30Days => 'Last 30 days',
        ReportDateRange.last90Days => 'Last 90 days',
      };
}

class ReportType {
  final String id;
  final String label;
  final ReportGroup group;

  const ReportType({
    required this.id,
    required this.label,
    required this.group,
  });
}

class ReportProject {
  final String id;
  final String name;

  const ReportProject({required this.id, required this.name});
}

class ReportFilters {
  final String? projectId;
  final ReportDateRange range;

  const ReportFilters({this.projectId, this.range = ReportDateRange.allTime});

  bool get isActive =>
      projectId != null || range != ReportDateRange.allTime;

  ReportFilters copyWith({
    String? projectId,
    bool clearProject = false,
    ReportDateRange? range,
  }) {
    return ReportFilters(
      projectId: clearProject ? null : (projectId ?? this.projectId),
      range: range ?? this.range,
    );
  }
}

/// Tabular result of one report run.
class ReportTableModel {
  final List<String> columns;
  final List<List<String>> rows;

  /// Optional last row rendered bold (e.g. totals).
  final List<String>? totals;

  const ReportTableModel({
    required this.columns,
    required this.rows,
    this.totals,
  });
}
