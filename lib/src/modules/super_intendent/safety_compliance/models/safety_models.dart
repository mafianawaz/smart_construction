import 'package:flutter/material.dart';

/// Tabs in the Safety & Compliance hub. The reference shows a horizontally
/// scrolling pill row: Dashboard / Observations / OSHA Logs / Mob… (read as
/// "Modules", see NOTES) / Training.
enum SafetyTab { dashboard, observations, oshaLogs, modules, training }

extension SafetyTabX on SafetyTab {
  String get label {
    switch (this) {
      case SafetyTab.dashboard:
        return 'Dashboard';
      case SafetyTab.observations:
        return 'Observations';
      case SafetyTab.oshaLogs:
        return 'OSHA Logs';
      case SafetyTab.modules:
        return 'Modules';
      case SafetyTab.training:
        return 'Training';
    }
  }
}

/// Semantic colour tone used for sub-labels and chips.
enum SafetyTone { good, warning, danger, neutral }

// ───────────────────────── Observations ─────────────────────────

enum ObservationType { atRisk, safe }

extension ObservationTypeX on ObservationType {
  String get label => this == ObservationType.atRisk ? 'AT_RISK' : 'SAFE';
  String get displayName => this == ObservationType.atRisk ? 'At Risk' : 'Safe';
}

enum ObservationSeverity { low, medium, high }

extension ObservationSeverityX on ObservationSeverity {
  String get label {
    switch (this) {
      case ObservationSeverity.low:
        return 'LOW';
      case ObservationSeverity.medium:
        return 'MEDIUM';
      case ObservationSeverity.high:
        return 'HIGH';
    }
  }

  String get displayName {
    switch (this) {
      case ObservationSeverity.low:
        return 'Low';
      case ObservationSeverity.medium:
        return 'Medium';
      case ObservationSeverity.high:
        return 'High';
    }
  }
}

enum ObservationStatus { open, closed }

extension ObservationStatusX on ObservationStatus {
  String get label => this == ObservationStatus.open ? 'OPEN' : 'CLOSED';
}

class SafetyObservation {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final String observer;
  final ObservationType type;
  final ObservationSeverity severity;
  final ObservationStatus status;

  const SafetyObservation({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.observer,
    required this.type,
    required this.severity,
    this.status = ObservationStatus.open,
  });

  bool get isOpen => status == ObservationStatus.open;

  SafetyObservation copyWith({
    String? title,
    String? description,
    ObservationType? type,
    ObservationSeverity? severity,
    ObservationStatus? status,
  }) {
    return SafetyObservation(
      id: id,
      date: date,
      title: title ?? this.title,
      description: description ?? this.description,
      observer: observer,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      status: status ?? this.status,
    );
  }
}

// ───────────────────────── OSHA ─────────────────────────

enum OshaClassification { death, daysAway, restricted, transfer, otherRecordable }

extension OshaClassificationX on OshaClassification {
  String get label {
    switch (this) {
      case OshaClassification.death:
        return 'Death';
      case OshaClassification.daysAway:
        return 'Days away';
      case OshaClassification.restricted:
        return 'Job restriction';
      case OshaClassification.transfer:
        return 'Job transfer';
      case OshaClassification.otherRecordable:
        return 'Other recordable';
    }
  }

  SafetyTone get tone {
    switch (this) {
      case OshaClassification.death:
        return SafetyTone.danger;
      case OshaClassification.daysAway:
        return SafetyTone.danger;
      case OshaClassification.restricted:
        return SafetyTone.warning;
      case OshaClassification.transfer:
        return SafetyTone.warning;
      case OshaClassification.otherRecordable:
        return SafetyTone.neutral;
    }
  }
}

/// One row of the OSHA 300 log.
class OshaLogEntry {
  final String caseNumber;
  final DateTime date;
  final String employee;
  final String jobTitle;
  final String description;
  final OshaClassification classification;

  const OshaLogEntry({
    required this.caseNumber,
    required this.date,
    required this.employee,
    required this.jobTitle,
    required this.description,
    required this.classification,
  });
}

/// Annual OSHA numbers. Rates use the standard 200,000-hour base.
class OshaYearSummary {
  final int year;
  final int hoursWorked;
  final int totalRecordable;
  final int deaths;
  final int daysAwayCases;
  final int restrictedCases;
  final int transferCases;
  final int daysAway; // days
  final int restrictedDays; // days
  final int nearMisses;

  const OshaYearSummary({
    required this.year,
    required this.hoursWorked,
    this.totalRecordable = 0,
    this.deaths = 0,
    this.daysAwayCases = 0,
    this.restrictedCases = 0,
    this.transferCases = 0,
    this.daysAway = 0,
    this.restrictedDays = 0,
    this.nearMisses = 0,
  });

  int get dartCases => daysAwayCases + restrictedCases + transferCases;

  double _rate(int cases) =>
      hoursWorked <= 0 ? 0 : cases * 200000 / hoursWorked;

  /// Total Recordable Incident Rate.
  double get trir => _rate(totalRecordable);

  /// Days Away, Restricted or Transferred rate.
  double get dartRate => _rate(dartCases);

  /// Lost Time (days-away) rate.
  double get lostTimeRate => _rate(daysAwayCases);
}

// ───────────────────────── Dashboard ─────────────────────────

class SafetyLeadingStats {
  final int inspections;
  final int overdueInspections;
  final int nearMissReports;
  final int nearMissDeficiencies;
  final int toolboxTalks;
  final int toolboxAttendees;
  final int trainingCompleted;
  final int trainingPassed;
  final int trainingFailed;

  const SafetyLeadingStats({
    this.inspections = 0,
    this.overdueInspections = 0,
    this.nearMissReports = 0,
    this.nearMissDeficiencies = 0,
    this.toolboxTalks = 0,
    this.toolboxAttendees = 0,
    this.trainingCompleted = 0,
    this.trainingPassed = 0,
    this.trainingFailed = 0,
  });
}

/// Display data for one dashboard stat card.
class SafetyIndicatorData {
  final String label;
  final String value;
  final String icon;
  final String? subLabel;
  final SafetyTone subTone;

  const SafetyIndicatorData({
    required this.label,
    required this.value,
    required this.icon,
    this.subLabel,
    this.subTone = SafetyTone.neutral,
  });
}

// ───────────────────────── Modules ─────────────────────────

class SafetyModuleChip {
  final String label;
  final SafetyTone tone;
  final IconData? icon;

  const SafetyModuleChip(this.label, this.tone, {this.icon});
}

class SafetyModuleItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<SafetyModuleChip> chips;

  const SafetyModuleItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.chips = const [],
  });
}
