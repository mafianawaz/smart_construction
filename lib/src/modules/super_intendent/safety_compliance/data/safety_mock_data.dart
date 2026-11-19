import 'package:flutter/material.dart';

import '../models/safety_models.dart';

/// Mock-data seam for the Safety & Compliance hub.
///
/// Every method marks the REST call that replaces it. Nothing outside this
/// file should construct demo data.
class SafetyMockData {
  SafetyMockData._();

  static const int currentYear = 2026;

  /// TODO(auth): replace with the signed-in user (MockSession) once real auth lands.
  static const String currentObserverName = 'Test SUPERINTENDENT';

  /// Hazard categories offered by the New Observation form.
  /// GET /safety/observation-categories
  static const List<String> observationCategories = [
    'FALL PROTECTION',
    'PPE',
    'HOUSEKEEPING',
    'ELECTRICAL',
    'EXCAVATION & TRENCHING',
    'SCAFFOLDING',
    'FIRE PREVENTION',
    'OTHER',
  ];

  /// GET /safety/observations
  static List<SafetyObservation> observations() => [
        SafetyObservation(
          id: 'obs_1',
          date: DateTime(2026, 8, 4),
          title: 'FALL PROTECTION',
          description: 'gsg',
          observer: 'Test SUPERINTENDENT',
          type: ObservationType.atRisk,
          severity: ObservationSeverity.medium,
        ),
        SafetyObservation(
          id: 'obs_2',
          date: DateTime(2026, 6, 16),
          title: 'PPE',
          description: 'adsfads',
          observer: 'Test ADMIN',
          type: ObservationType.atRisk,
          severity: ObservationSeverity.low,
        ),
      ];

  /// GET /safety/osha/summary?year=
  static List<int> availableYears() => [2026, 2025, 2024];

  static OshaYearSummary summaryFor(int year) {
    switch (year) {
      case 2025:
        return const OshaYearSummary(
          year: 2025,
          hoursWorked: 385000,
          totalRecordable: 2,
          daysAwayCases: 1,
          restrictedCases: 1,
          daysAway: 6,
          restrictedDays: 12,
          nearMisses: 3,
        );
      case 2024:
        return const OshaYearSummary(year: 2024, hoursWorked: 340000);
      case 2026:
      default:
        return const OshaYearSummary(year: 2026, hoursWorked: 200000);
    }
  }

  /// GET /safety/osha/log-entries?year=
  static List<OshaLogEntry> logEntriesFor(int year) {
    if (year == 2025) {
      return [
        OshaLogEntry(
          caseNumber: '2025-01',
          date: DateTime(2025, 3, 11),
          employee: 'M. Khan',
          jobTitle: 'Laborer',
          description: 'Fall from ladder, sprained ankle',
          classification: OshaClassification.daysAway,
        ),
        OshaLogEntry(
          caseNumber: '2025-02',
          date: DateTime(2025, 7, 22),
          employee: 'A. Rivera',
          jobTitle: 'Carpenter',
          description: 'Laceration to hand from saw blade',
          classification: OshaClassification.restricted,
        ),
      ];
    }
    return const [];
  }

  /// GET /safety/dashboard/leading-indicators?year=
  static SafetyLeadingStats leadingStatsFor(int year) {
    if (year == 2026) {
      return const SafetyLeadingStats(
        inspections: 2,
        overdueInspections: 0,
        nearMissReports: 2,
        nearMissDeficiencies: 1,
        toolboxTalks: 0,
        toolboxAttendees: 0,
        trainingCompleted: 4,
        trainingPassed: 3,
        trainingFailed: 0,
      );
    }
    return const SafetyLeadingStats();
  }

  /// GET /safety/modules (chip counts come from each module's own summary endpoint)
  static List<SafetyModuleItem> modules() => const [
        SafetyModuleItem(
          id: 'training',
          title: 'Training & Certifications',
          description:
              'Manage required courses, assignments, and worker certification status.',
          icon: Icons.school_outlined,
          chips: [
            SafetyModuleChip('1 attention', SafetyTone.neutral),
            SafetyModuleChip('1 overdue', SafetyTone.danger,
                icon: Icons.warning_amber_rounded),
            SafetyModuleChip('130 days', SafetyTone.warning),
          ],
        ),
        SafetyModuleItem(
          id: 'compliance',
          title: 'Compliance & COIs',
          description: 'Track COIs, bonds, DBE certs, licenses, and expirations.',
          icon: Icons.shield_outlined,
        ),
        SafetyModuleItem(
          id: 'swppp',
          title: 'SWPPP Inspections',
          description: 'Stormwater inspections and corrective actions.',
          icon: Icons.description_outlined,
        ),
        SafetyModuleItem(
          id: 'daily_inspector',
          title: 'Daily Inspector Reports',
          description: 'Daily field inspection reports and signoffs.',
          icon: Icons.fact_check_outlined,
        ),
        SafetyModuleItem(
          id: 'material_certs',
          title: 'Material Certifications',
          description: 'Mill certs and material conformance records.',
          icon: Icons.workspace_premium_outlined,
        ),
      ];
}
