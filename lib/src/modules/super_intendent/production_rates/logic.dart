import 'package:get/get.dart';

import 'data/company_settings_mock_data.dart';
import 'models/company_settings_models.dart';


/// Controller for the Company Settings screen.
///
/// Uses plain fields + `update()` (GetBuilder), matching `PricingLogic`.
class CompanySettingsLogic extends GetxController {
  // ── navigation state ────────────────────────────────────────────────────
  CompanySection section = CompanySection.financial;
  FinancialTab financialTab = FinancialTab.benchmarks;
  OperationsTab operationsTab = OperationsTab.reportLocks;

  // ── data ────────────────────────────────────────────────────────────────
  List<ProductionBenchmark> _benchmarks = [];
  List<LeaveTypeModel> leaveTypes = [];
  List<ReportLockModel> _locks = [];
  List<String> projectNames = [];

  // ── benchmark filters ───────────────────────────────────────────────────
  String sowSearch = '';
  String unitFilter = CompanySettingsFilters.allUnits;
  String timeFilter = CompanySettingsFilters.allTime;

  // ── report-lock filters ─────────────────────────────────────────────────
  String lockSearch = '';
  String lockStatusFilter = CompanySettingsFilters.allStatuses;
  String lockProjectFilter = CompanySettingsFilters.allProjects;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  void load() {
    _benchmarks = CompanySettingsMockData.benchmarks();
    leaveTypes = CompanySettingsMockData.leaveTypes();
    _locks = CompanySettingsMockData.reportLocks();
    projectNames = CompanySettingsMockData.projectNames();
    scopeTypes = CompanySettingsMockData.scopeTypes();
    distributionLists = CompanySettingsMockData.distributionLists();
    update();
  }

  // ── navigation ──────────────────────────────────────────────────────────
  void selectSection(s) {
    if (section == s) return;
    section = s;
    update();
  }

  void selectFinancialTab(FinancialTab t) {
    financialTab = t;
    update();
  }

  void selectOperationsTab(OperationsTab t) {
    operationsTab = t;
    update();
  }

  // ── benchmarks ──────────────────────────────────────────────────────────
  ProductionStats get stats => ProductionStats.from(_benchmarks);

  List<String> get unitOptions {
    final units = _benchmarks.map((b) => b.unit).toSet().toList()..sort();
    return [CompanySettingsFilters.allUnits, ...units];
  }

  List<String> get timeOptions => CompanySettingsFilters.timeOptions;

  void setSowSearch(String v) {
    sowSearch = v;
    update();
  }

  void setUnitFilter(String v) {
    unitFilter = v;
    update();
  }

  void setTimeFilter(String v) {
    timeFilter = v;
    update();
  }

  List<ProductionBenchmark> get filteredBenchmarks {
    final now = DateTime.now();
    final q = sowSearch.trim().toLowerCase();
    return _benchmarks.where((b) {
      if (q.isNotEmpty && !b.sow.toLowerCase().contains(q)) return false;
      if (unitFilter != CompanySettingsFilters.allUnits &&
          b.unit != unitFilter) {
        return false;
      }
      switch (timeFilter) {
        case 'Last 30 Days':
          return now.difference(b.lastEntry).inDays <= 30;
        case 'Last 90 Days':
          return now.difference(b.lastEntry).inDays <= 90;
        case 'This Year':
          return b.lastEntry.year == now.year;
        default:
          return true;
      }
    }).toList();
  }

  // ── leave types ─────────────────────────────────────────────────────────
  List<String> get leaveTypeNames =>
      leaveTypes.map((l) => l.name.toLowerCase()).toList();

  Future<void> addLeaveType(LeaveTypeModel draft) async {
    final saved = await CompanySettingsMockData.createLeaveType(draft);
    leaveTypes = [...leaveTypes, saved];
    update();
  }

  void toggleLeaveActive(String id, bool value) {
    leaveTypes = leaveTypes
        .map((l) => l.id == id ? l.copyWith(active: value) : l)
        .toList();
    update();
  }

  // ── report locks ────────────────────────────────────────────────────────
  int lockCount(ReportLockStatus s) =>
      _locks.where((l) => l.status == s).length;

  List<String> get lockStatusOptions => [
        CompanySettingsFilters.allStatuses,
        ...ReportLockStatus.values.map((s) => s.label),
      ];

  List<String> get lockProjectOptions =>
      [CompanySettingsFilters.allProjects, ...projectNames];

  void setLockSearch(String v) {
    lockSearch = v;
    update();
  }

  void setLockStatusFilter(String v) {
    lockStatusFilter = v;
    update();
  }

  void setLockProjectFilter(String v) {
    lockProjectFilter = v;
    update();
  }

  List<ReportLockModel> get filteredLocks {
    final q = lockSearch.trim().toLowerCase();
    return _locks.where((l) {
      if (q.isNotEmpty &&
          !l.projectName.toLowerCase().contains(q) &&
          !l.reason.toLowerCase().contains(q)) {
        return false;
      }
      if (lockStatusFilter != CompanySettingsFilters.allStatuses &&
          l.status.label != lockStatusFilter) {
        return false;
      }
      if (lockProjectFilter != CompanySettingsFilters.allProjects &&
          l.projectName != lockProjectFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  Future<void> addReportLock(ReportLockModel draft) async {
    final saved = await CompanySettingsMockData.createReportLock(draft);
    _locks = [saved, ..._locks];
    update();
  }

  // ── report-lock helpers ─────────────────────────────────────────────────
  /// True when [project] already has a lock for the same calendar day.
  bool isReportLocked(String project, DateTime day) {
    return _locks.any((l) =>
        l.projectName == project &&
        l.date.year == day.year &&
        l.date.month == day.month &&
        l.date.day == day.day);
  }

  // ── scope settings ──────────────────────────────────────────────────────
  List<ScopeTypeModel> scopeTypes = [];

  /// Lower-cased names, excluding [exceptId] so editing can keep its own name.
  List<String> scopeNames({String? exceptId}) => scopeTypes
      .where((s) => s.id != exceptId)
      .map((s) => s.name.toLowerCase())
      .toList();

  Future<void> addScopeType(ScopeTypeModel draft) async {
    final saved = await CompanySettingsMockData.createScopeType(draft);
    scopeTypes = [...scopeTypes, saved];
    update();
  }

  Future<void> updateScopeType(ScopeTypeModel item) async {
    final saved = await CompanySettingsMockData.updateScopeType(item);
    scopeTypes = scopeTypes.map((s) => s.id == saved.id ? saved : s).toList();
    update();
  }

  // ── distribution lists (read-only) ──────────────────────────────────────
  List<DistributionListModel> distributionLists = [];
}
