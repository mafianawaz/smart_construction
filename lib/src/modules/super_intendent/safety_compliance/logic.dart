import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'data/safety_format.dart';
import 'data/safety_mock_data.dart';
import 'models/safety_models.dart';


/// Controller for the Safety & Compliance hub.
///
/// Uses plain fields + `update()` (GetBuilder), matching PricingLogic.
class SafetyLogic extends GetxController {
  SafetyTab activeTab = SafetyTab.dashboard;

  int dashboardYear = SafetyMockData.currentYear;
  int oshaYear = SafetyMockData.currentYear;

  List<SafetyObservation> observations = [];
  List<SafetyModuleItem> modules = [];

  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// Loads everything from the mock seam.
  void load() {
    // TODO(api): GET /safety/observations, /safety/modules (+ per-year endpoints below)
    observations = SafetyMockData.observations();
    modules = SafetyMockData.modules();
    update();
  }

  // ───────────── tabs ─────────────

  void selectTab(SafetyTab tab) {
    if (tab == activeTab) return;
    activeTab = tab;
    update();
  }

  // ───────────── dashboard ─────────────

  OshaYearSummary get dashboardSummary =>
      SafetyMockData.summaryFor(dashboardYear);

  SafetyLeadingStats get leadingStats =>
      SafetyMockData.leadingStatsFor(dashboardYear);

  String get hoursWorkedLabel =>
      'Hours Worked YTD: ${SafetyFormat.count(dashboardSummary.hoursWorked)}';

  List<SafetyIndicatorData> get laggingIndicators {
    final s = dashboardSummary;
    return [
      SafetyIndicatorData(
        label: 'Total Recordable Incident Rate',
        value: SafetyFormat.rate(s.trir),
        icon: AppIcons.alertCircle,
      ),
      SafetyIndicatorData(
        label: 'Days Away/Restricted/ Transfer',
        value: '${s.dartCases}',
        icon: AppIcons.activity,
      ),
      SafetyIndicatorData(
        label: 'DART',
        value: SafetyFormat.rate(s.dartRate),
        icon: AppIcons.target,
      ),
      SafetyIndicatorData(
        label: 'Lost Time Rate',
        value: SafetyFormat.rate(s.lostTimeRate),
        icon: AppIcons.progress,
      ),
      SafetyIndicatorData(
        label: 'Fatalities',
        value: '${s.deaths}',
        icon: AppIcons.skull,
      ),
      SafetyIndicatorData(
        label: 'Near Misses',
        value: '${s.nearMisses}',
        icon: AppIcons.visibility,
      ),
    ];
  }

  List<SafetyIndicatorData> get leadingIndicators {
    final l = leadingStats;
    final deficiencyWord =
        l.nearMissDeficiencies == 1 ? 'deficiency' : 'deficiencies';
    return [
      SafetyIndicatorData(
        label: 'Safety Inspections',
        value: '${l.inspections}',
        icon: AppIcons.clipboardCheck,
        subLabel:
            '${l.overdueInspections} overdue / ${l.inspections - l.overdueInspections} ok',
        subTone:
            l.overdueInspections > 0 ? SafetyTone.danger : SafetyTone.good,
      ),
      SafetyIndicatorData(
        label: 'Near Miss Reports',
        value: '${l.nearMissReports}',
        icon: AppIcons.docs,
        subLabel: '${l.nearMissDeficiencies} $deficiencyWord',
        subTone: l.nearMissDeficiencies > 0
            ? SafetyTone.warning
            : SafetyTone.good,
      ),
      SafetyIndicatorData(
        label: 'Toolbox Talks',
        value: '${l.toolboxTalks}',
        icon: AppIcons.workforce,
        subLabel: '${l.toolboxAttendees} attendees',
        subTone: SafetyTone.neutral,
      ),
      SafetyIndicatorData(
        label: 'Training Completed',
        value: '${l.trainingCompleted}',
        icon: AppIcons.cap,
        subLabel: '${l.trainingPassed} passed / ${l.trainingFailed} failed',
        subTone: l.trainingFailed > 0 ? SafetyTone.danger : SafetyTone.good,
      ),
    ];
  }

  // ───────────── observations ─────────────

  int get openObservationCount => observations.where((o) => o.isOpen).length;

  void addObservation(SafetyObservation observation) {
    // TODO(api): POST /safety/observations
    observations = [observation, ...observations];
    update();
  }

  void closeObservation(String id) {
    // TODO(api): PATCH /safety/observations/{id} { status: "closed" }
    observations = [
      for (final o in observations)
        if (o.id == id) o.copyWith(status: ObservationStatus.closed) else o,
    ];
    update();
  }

  // ───────────── OSHA logs ─────────────

  List<int> get availableYears => SafetyMockData.availableYears();

  OshaYearSummary get oshaSummary => SafetyMockData.summaryFor(oshaYear);

  List<OshaLogEntry> get oshaEntries => SafetyMockData.logEntriesFor(oshaYear);

  void selectOshaYear(int year) {
    if (year == oshaYear) return;
    oshaYear = year;
    update();
  }

  void downloadOsha300A() {
    // TODO(api): GET /safety/osha/300a.pdf?year=  -> save/open with the app's file package.
    Get.snackbar(
      'OSHA 300A',
      'PDF download for $oshaYear is not connected yet.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  // ───────────── modules ─────────────

  void openModule(SafetyModuleItem module) {
    // TODO(nav): replace with Get.toNamed(<module route>) once those screens exist.
    Get.snackbar(
      module.title,
      'This module is not wired yet.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
