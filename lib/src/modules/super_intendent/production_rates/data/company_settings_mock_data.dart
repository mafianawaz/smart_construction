import '../models/company_settings_models.dart';

/// Mock-data seam for Company Settings.
///
/// Every method below marks the HTTP call that replaces it.
/// [seedDemo] is false so the screens open on the empty states shown in the
/// reference design. Flip it to true to see populated lists while styling.
class CompanySettingsMockData {
  static const bool seedDemo = false;

  // GET /company/settings/production-benchmarks
  static List<ProductionBenchmark> benchmarks() {
    if (!seedDemo) return [];
    final now = DateTime.now();
    return [
      ProductionBenchmark(
        sow: 'Framing',
        unit: 'SF',
        avgPerDay: 420,
        minPerDay: 300,
        maxPerDay: 560,
        workDays: 18,
        projects: 3,
        entries: 42,
        lastEntry: now.subtract(const Duration(days: 4)),
      ),
      ProductionBenchmark(
        sow: 'Drywall',
        unit: 'SF',
        avgPerDay: 650,
        minPerDay: 480,
        maxPerDay: 800,
        workDays: 14,
        projects: 2,
        entries: 31,
        lastEntry: now.subtract(const Duration(days: 20)),
      ),
      ProductionBenchmark(
        sow: 'Conduit Run',
        unit: 'LF',
        avgPerDay: 180,
        minPerDay: 120,
        maxPerDay: 240,
        workDays: 9,
        projects: 2,
        entries: 17,
        lastEntry: now.subtract(const Duration(days: 75)),
      ),
    ];
  }

  // GET /company/settings/leave-types
  static List<LeaveTypeModel> leaveTypes() {
    if (!seedDemo) return [];
    return const [
      LeaveTypeModel(id: 'lt1', name: 'Vacation', annualAllowanceDays: 15),
      LeaveTypeModel(id: 'lt2', name: 'Sick', annualAllowanceDays: 10),
      LeaveTypeModel(
        id: 'lt3',
        name: 'Personal',
        annualAllowanceDays: 3,
        active: false,
      ),
    ];
  }

  // GET /company/settings/report-locks
  static List<ReportLockModel> reportLocks() {
    if (!seedDemo) return [];
    final now = DateTime.now();
    return [
      ReportLockModel(
        id: 'rl1',
        projectName: 'Harbor Point Tower',
        reason: 'Weekly evidence freeze',
        status: ReportLockStatus.locked,
        date: now.subtract(const Duration(days: 1)),
      ),
      ReportLockModel(
        id: 'rl2',
        projectName: 'Riverside Lofts',
        reason: 'Awaiting supervisor sign-off',
        status: ReportLockStatus.supervisor,
        date: now.subtract(const Duration(days: 3)),
      ),
      ReportLockModel(
        id: 'rl3',
        projectName: 'Harbor Point Tower',
        reason: 'Reopened for correction',
        status: ReportLockStatus.unlocked,
        date: now.subtract(const Duration(days: 6)),
      ),
    ];
  }

  // GET /projects?fields=id,name   (used by the lock filter + Lock Report sheet)
  static List<String> projectNames() {
    return const ['Harbor Point Tower', 'Riverside Lofts', 'Westgate Plaza'];
  }

  // POST /company/settings/leave-types
  static Future<LeaveTypeModel> createLeaveType(LeaveTypeModel draft) async {
    return draft;
  }

  // POST /company/settings/report-locks
  static Future<ReportLockModel> createReportLock(ReportLockModel draft) async {
    return draft;
  }

  /// The reference design shows Scope Settings already populated, so scope
  /// types seed independently of [seedDemo].
  static const bool seedScopeTypes = true;

  // GET /company/settings/scope-types
  static List<ScopeTypeModel> scopeTypes() {
    if (!seedScopeTypes) return [];
    return const [
      ScopeTypeModel(id: 'sc1', name: 'Casing Removal', unit: 'LF'),
      ScopeTypeModel(id: 'sc2', name: 'Grout Fill', unit: 'CY'),
      ScopeTypeModel(id: 'sc3', name: 'Documentation & Reporting', unit: 'EA'),
      ScopeTypeModel(id: 'sc4', name: 'Concrete Finishing', unit: 'SF'),
      ScopeTypeModel(id: 'sc5', name: 'Excavation', unit: 'CY'),
      ScopeTypeModel(id: 'sc6', name: 'Steel Fabrication', unit: 'LF'),
      ScopeTypeModel(id: 'sc7', name: 'Electrical Wiring', unit: 'HR'),
      ScopeTypeModel(id: 'sc8', name: 'Plumbing Install', unit: 'LF'),
    ];
  }

  // POST /company/settings/scope-types
  static Future<ScopeTypeModel> createScopeType(ScopeTypeModel draft) async {
    return draft;
  }

  // PUT /company/settings/scope-types/{id}
  static Future<ScopeTypeModel> updateScopeType(ScopeTypeModel item) async {
    return item;
  }

  // GET /company/settings/distribution-lists   (read-only; admins create them)
  static List<DistributionListModel> distributionLists() {
    if (!seedDemo) return [];
    return const [
      DistributionListModel(
        id: 'dl1',
        name: 'Project Managers',
        emails: ['pm.one@example.com', 'pm.two@example.com'],
      ),
      DistributionListModel(
        id: 'dl2',
        name: 'Client Stakeholders',
        emails: ['client@example.com'],
      ),
    ];
  }
}
