import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'create_kpi/view.dart';
import 'data/workforce_mock_data.dart';
import 'models/kpi_model.dart';
import 'models/reward_model.dart';
import 'models/worker_model.dart';
import 'widgets/assign_kpi_sheet.dart';


enum WorkforceTab { workers, performance, rewards }

enum PerformanceSubTab { rateEmployee, kpiLibrary, analytics, ratingHistory }

enum KpiLibrarySection { library, assignments, performance }

/// Sentinel used by the three Workers filter dropdowns.
const String kWorkforceAll = 'All';

/// Controller for the whole Workforce Management screen (all three tabs).
/// Uses the GetBuilder / update() pattern, same as PricingLogic.
class WorkforceLogic extends GetxController {
  // ── Navigation state ──────────────────────────────────────────────
  WorkforceTab tab = WorkforceTab.workers;
  PerformanceSubTab performanceTab = PerformanceSubTab.rateEmployee;
  final kpiTab = 0.obs;

  /// "0 Proj" badge beside the screen title.
  int projectCount = 0;

  // ── Workers ───────────────────────────────────────────────────────
  List<WorkerModel> workers = [];
  TextEditingController workerSearch = TextEditingController();
  String tradeFilter = kWorkforceAll;
  String roleFilter = kWorkforceAll;
  String typeFilter = kWorkforceAll;

  // ── KPIs / ratings ────────────────────────────────────────────────
  List<KpiTemplate> templates = [];
  List<KpiRating> ratings = [];
  TextEditingController templateSearch = TextEditingController();

  // ── KPI assignments / results ─────────────────────────────────────
  static const String kAllEmployees = 'All Employees';
  static const String kAllKpis = 'All KPIs';

  List<KpiEmployee> employees = [];
  List<KpiAssignment> assignments = [];
  List<KpiResult> results = [];
  List<String> periods = [];
  String assignmentEmployeeFilter = kAllEmployees;
  String assignmentKpiFilter = kAllKpis;
  KpiEmployee? perfEmployee;
  String perfPeriod = '';

  /// Stand-in for the signed-in user (swap for the real session).
  String currentEmployeeId = 'me';

  // ── Rewards ───────────────────────────────────────────────────────
  List<RewardModel> rewards = [];

  final List<RatingRole> roles = WorkforceMockData.ratingRoles;
  late RatingRole selectedRole = roles.first;

  /// KPI id → score (0..10) for the Rate Employee form.
  final Map<String, double> scores = {};
  final TextEditingController periodController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  /// Replace with real calls (see WorkforceMockData for endpoints).
  void load() {
    workers = WorkforceMockData.workers();
    templates = WorkforceMockData.kpiTemplates();
    ratings = WorkforceMockData.ratings();
    employees = WorkforceMockData.employees;
    assignments = WorkforceMockData.assignments();
    results = WorkforceMockData.results();
    periods = WorkforceMockData.periods;
    perfEmployee = employees.first;
    perfPeriod = periods.first;
    rewards = WorkforceMockData.rewards();
    update();
  }

  @override
  void onClose() {
    periodController.dispose();
    feedbackController.dispose();
    super.onClose();
  }

  // ── Tab setters ───────────────────────────────────────────────────
  void setTab(WorkforceTab t) {
    tab = t;
    update();
  }

  void setPerformanceTab(PerformanceSubTab t) {
    performanceTab = t;
    update();
  }

  void setKpiTab(t) {
    kpiTab.value = t;
    update();
  }

  // ── Workers: filtering ────────────────────────────────────────────
  List<String> _distinctSorted(Iterable<String> values) {
    final list = values.toSet().toList();
    list.sort();
    return list;
  }

  List<String> get tradeOptions =>
      [kWorkforceAll, ..._distinctSorted(workers.map((w) => w.trade))];

  List<String> get roleOptions =>
      [kWorkforceAll, ..._distinctSorted(workers.map((w) => w.roleLabel))];

  List<String> get typeOptions =>
      [kWorkforceAll, ...EmploymentType.values.map((e) => e.label)];

  String get tradeDisplay => 'Trade: $tradeFilter';
  String get roleDisplay => roleFilter == kWorkforceAll ? 'All Roles' : roleFilter;
  String get typeDisplay => typeFilter == kWorkforceAll ? 'All Types' : typeFilter;

  List<WorkerModel> get filteredWorkers {
    return workers.where((w) {
      if (!w.matches(workerSearch.text)) return false;
      if (tradeFilter != kWorkforceAll && w.trade != tradeFilter) return false;
      if (roleFilter != kWorkforceAll && w.roleLabel != roleFilter) return false;
      if (typeFilter != kWorkforceAll && w.employmentType.label != typeFilter) {
        return false;
      }
      return true;
    }).toList();
  }

  bool get hasActiveWorkerFilters =>
      workerSearch.text.trim().isNotEmpty ||
      tradeFilter != kWorkforceAll ||
      roleFilter != kWorkforceAll ||
      typeFilter != kWorkforceAll;

  void setWorkerSearch(v) {
    workerSearch = v;
    update();
  }

  void setTradeFilter(String v) {
    tradeFilter = v;
    update();
  }

  void setRoleFilter(String v) {
    roleFilter = v;
    update();
  }

  void setTypeFilter(String v) {
    typeFilter = v;
    update();
  }

  // ── KPI library ───────────────────────────────────────────────────
  List<KpiTemplate> get filteredTemplates =>
      templates.where((t) => t.matches(templateSearch.text)).toList();

  int get activeKpiCount => templates.where((t) => t.isActive).length;
  int get kpisWithTargets => templates.where((t) => t.target != null).length;

  void setTemplateSearch(v) {
    templateSearch = v;
    update();
  }

  Future<void> openCreateKpi() async {
    final created = await Get.to<KpiTemplate>(() => const CreateKpiView());
    if (created == null) return;
    // POST /workforce/kpi-templates
    // No Assignments UI in the reference yet, so new KPIs are assigned to
    // every role; otherwise they'd never show up under Rate Employee.
    templates = [
      ...templates,
      created.copyWith(assignedRoleCodes: roles.map((r) => r.code).toList()),
    ];
    update();
  }

  Future<void> openEditKpi(KpiTemplate t) async {
    final edited = await Get.to<KpiTemplate>(() => CreateKpiView(existing: t));
    if (edited == null) return;
    // PUT /workforce/kpi-templates/:id
    templates = [for (final x in templates) x.id == edited.id ? edited : x];
    update();
  }

  Future<void> confirmDeleteKpi(KpiTemplate t) async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete KPI?'),
        content: Text('"${t.name}" will be removed from the library.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    // DELETE /workforce/kpi-templates/:id
    templates = templates.where((x) => x.id != t.id).toList();
    scores.remove(t.id);
    update();
  }

  // ── KPI Assignments ───────────────────────────────────────────────
  List<String> get assignmentEmployeeOptions =>
      [kAllEmployees, ..._distinctSorted(employees.map((e) => e.name))];

  List<String> get assignmentKpiOptions =>
      [kAllKpis, ..._distinctSorted(templates.map((t) => t.name))];

  List<KpiAssignment> get filteredAssignments => assignments.where((a) {
        if (assignmentEmployeeFilter != kAllEmployees &&
            a.employeeName != assignmentEmployeeFilter) {
          return false;
        }
        if (assignmentKpiFilter != kAllKpis && a.kpiName != assignmentKpiFilter) {
          return false;
        }
        return true;
      }).toList();

  void setAssignmentEmployeeFilter(String v) {
    assignmentEmployeeFilter = v;
    update();
  }

  void setAssignmentKpiFilter(String v) {
    assignmentKpiFilter = v;
    update();
  }

  Future<void> openAssignKpi() async {
    final active = templates.where((t) => t.isActive).toList();
    if (active.isEmpty || employees.isEmpty) {
      _toast('Nothing to assign', 'Create an active KPI first.');
      return;
    }
    final created = await Get.bottomSheet<KpiAssignment>(
      AssignKpiSheet(employees: employees, templates: active, periods: periods),
      isScrollControlled: true,
    );
    if (created == null) return;
    // POST /workforce/kpi-assignments
    assignments = [created, ...assignments];
    // A pending result row so it shows up under Performance.
    results = [
      ...results,
      KpiResult(
        id: 'res-${created.id}',
        employeeId: created.employeeId,
        kpiId: created.kpiId,
        kpiName: created.kpiName,
        category: created.category,
        unit: created.unit,
        direction: templates
            .firstWhere((t) => t.id == created.kpiId,
                orElse: () => active.first)
            .direction,
        target: created.target ?? 0,
        period: created.period,
      ),
    ];
    update();
  }

  // ── KPI Performance (per employee) ────────────────────────────────
  List<KpiResult> get perfResults => results
      .where((r) => r.employeeId == perfEmployee?.id && r.period == perfPeriod)
      .toList();

  int get perfCompleted => perfResults.where((r) => r.isCompleted).length;
  int get perfPending => perfResults.length - perfCompleted;

  int get perfOverallPercent => _averagePercent(perfResults);

  int _averagePercent(List<KpiResult> list) {
    final done = list.where((r) => r.isCompleted).toList();
    if (done.isEmpty) return 0;
    final sum = done.fold<double>(0, (a, r) => a + r.scorePercent);
    return (sum / done.length).round();
  }

  void setPerfEmployee(KpiEmployee e) {
    perfEmployee = e;
    update();
  }

  void setPerfPeriod(String p) {
    perfPeriod = p;
    update();
  }

  // ── Analytics (my own numbers) ────────────────────────────────────
  List<KpiResult> get myResults =>
      results.where((r) => r.employeeId == currentEmployeeId).toList();

  int get totalRatings => ratings.length;

  /// Mean of every submitted 0..10 score; 0.0 when nothing is rated.
  double get averageScore {
    final all = ratings.expand((r) => r.scores).toList();
    if (all.isEmpty) return 0;
    return all.fold<double>(0, (a, s) => a + s.score) / all.length;
  }

  int get myActiveKpis => myResults.length;
  int get myAchievementPercent => _averagePercent(myResults);

  // ── Rewards ───────────────────────────────────────────────────────
  int get totalRewards => rewards.length;
  int get pointsEarned => rewards.fold<int>(0, (a, r) => a + r.points);

  // ── Rate Employee ─────────────────────────────────────────────────
  List<KpiTemplate> get ratableKpis => templates
      .where((t) => t.isActive && t.assignedRoleCodes.contains(selectedRole.code))
      .toList();

  void setRole(r) {
    selectedRole = r;
    scores.clear();
    update();
  }

  double scoreFor(KpiTemplate t) => scores[t.id] ?? 0;

  void setScore(KpiTemplate t, double v) {
    scores[t.id] = v;
    update();
  }

  void submitRating() {
    final kpis = ratableKpis;
    if (kpis.isEmpty) {
      _toast('Nothing to rate', 'No active KPIs are assigned to this role.');
      return;
    }
    if (periodController.text.trim().isEmpty) {
      _toast('Period required', 'Enter a rating period, e.g. Q1 2026.');
      return;
    }
    // POST /workforce/kpi-ratings
    ratings = [
      KpiRating(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        roleDisplay: selectedRole.display,
        period: periodController.text.trim(),
        feedback: feedbackController.text.trim(),
        scores: [for (final k in kpis) KpiScore(k.name, scoreFor(k))],
        createdAt: DateTime.now(),
      ),
      ...ratings,
    ];
    scores.clear();
    periodController.clear();
    feedbackController.clear();
    update();
    _toast('Rating submitted', 'It now appears under Rating History.');
  }

  void showKpiHelp() {
    Get.dialog(
      AlertDialog(
        title: const Text('KPI Management'),
        content: const Text(
          'KPI templates define what you measure. Create them in the library, '
          'assign them to roles, then score employees against them under '
          'Rate Employee.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Got it')),
        ],
      ),
    );
  }

  void _toast(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }
}
