// Company Settings — models.
// Pure data + small label helpers. No UI, no GetX.

enum CompanySection { financial, people, operations }

extension CompanySectionX on CompanySection {
  String get label {
    switch (this) {
      case CompanySection.financial:
        return 'Financial';
      case CompanySection.people:
        return 'People';
      case CompanySection.operations:
        return 'Operations';
    }
  }

  /// Heading shown above the section's sub-tabs.
  String get heading => label;
}

enum FinancialTab { benchmarks, costAnalytics }

extension FinancialTabX on FinancialTab {
  String get label =>
      this == FinancialTab.benchmarks ? 'Benchmarks' : 'Cost Analytics';
}

enum OperationsTab { reportLocks, scopeSettings, distribution }

extension OperationsTabX on OperationsTab {
  String get label {
    switch (this) {
      case OperationsTab.reportLocks:
        return 'Report Locks';
      case OperationsTab.scopeSettings:
        return 'Scope Settings';
      case OperationsTab.distribution:
        return 'Distribution';
    }
  }
}

enum ReportLockStatus { unlocked, locked, supervisor }

extension ReportLockStatusX on ReportLockStatus {
  String get label {
    switch (this) {
      case ReportLockStatus.unlocked:
        return 'Unlocked';
      case ReportLockStatus.locked:
        return 'Locked';
      case ReportLockStatus.supervisor:
        return 'Supervisor';
    }
  }
}

/// A leave type, e.g. Vacation / Sick / Personal.
class LeaveTypeModel {
  final String id;
  final String name;
  final int annualAllowanceDays;
  final bool active;

  const LeaveTypeModel({
    required this.id,
    required this.name,
    required this.annualAllowanceDays,
    this.active = true,
  });

  LeaveTypeModel copyWith({
    String? name,
    int? annualAllowanceDays,
    bool? active,
  }) {
    return LeaveTypeModel(
      id: id,
      name: name ?? this.name,
      annualAllowanceDays: annualAllowanceDays ?? this.annualAllowanceDays,
      active: active ?? this.active,
    );
  }
}

/// Average daily production for one scope-of-work category.
class ProductionBenchmark {
  final String sow;
  final String unit;
  final double avgPerDay;
  final double minPerDay;
  final double maxPerDay;
  final int workDays;
  final int projects;
  final int entries;
  final DateTime lastEntry;

  const ProductionBenchmark({
    required this.sow,
    required this.unit,
    required this.avgPerDay,
    required this.minPerDay,
    required this.maxPerDay,
    required this.workDays,
    required this.projects,
    required this.entries,
    required this.lastEntry,
  });
}

/// The four stat tiles above the benchmark list.
class ProductionStats {
  final int sowTypesTracked;
  final int totalWorkDays;
  final int projectsContributing;
  final int dailyEntries;

  const ProductionStats({
    required this.sowTypesTracked,
    required this.totalWorkDays,
    required this.projectsContributing,
    required this.dailyEntries,
  });

  factory ProductionStats.from(List<ProductionBenchmark> items) {
    var maxProjects = 0;
    var days = 0;
    var entries = 0;
    for (final b in items) {
      if (b.projects > maxProjects) maxProjects = b.projects;
      days += b.workDays;
      entries += b.entries;
    }
    return ProductionStats(
      sowTypesTracked: items.length,
      totalWorkDays: days,
      projectsContributing: maxProjects,
      dailyEntries: entries,
    );
  }
}

/// A lock applied to a project's daily report.
class ReportLockModel {
  final String id;
  final String projectName;
  final String reason;
  final ReportLockStatus status;
  final DateTime date;

  const ReportLockModel({
    required this.id,
    required this.projectName,
    required this.reason,
    required this.status,
    required this.date,
  });
}

/// Filter option labels shared by logic + view.
class CompanySettingsFilters {
  static const String allUnits = 'All Units';
  static const String allTime = 'All Time';
  static const String allStatuses = 'All Statuses';
  static const String allProjects = 'All Projects';

  static const List<String> timeOptions = [
    allTime,
    'Last 30 Days',
    'Last 90 Days',
    'This Year',
  ];
}

/// Unit options for scope-of-work types.
const List<String> kScopeUnits = ['LF', 'SF', 'SY', 'CY', 'EA', 'HR', 'LS'];

/// A scope-of-work category, e.g. "Casing Removal" measured in LF.
class ScopeTypeModel {
  final String id;
  final String name;
  final String unit;

  const ScopeTypeModel({
    required this.id,
    required this.name,
    required this.unit,
  });

  ScopeTypeModel copyWith({String? name, String? unit}) {
    return ScopeTypeModel(
      id: id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
    );
  }
}

/// An organization-wide reusable email recipient group.
class DistributionListModel {
  final String id;
  final String name;
  final List<String> emails;

  const DistributionListModel({
    required this.id,
    required this.name,
    required this.emails,
  });
}
