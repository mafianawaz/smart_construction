import '../models/estimate_models.dart';
import '../models/location_models.dart';
import '../models/materials_models.dart';
import '../models/procurement_models.dart';
import '../models/scope_models.dart';
import '../models/change_order_model.dart';
import '../models/closeout_readiness_model.dart';
import '../models/delay_model.dart';
import '../models/geofence_models.dart';
import '../models/job_info_model.dart';
import '../models/mobilization_model.dart';
import '../models/project_enums.dart';
import '../models/project_model.dart';
import '../models/risk_model.dart';
import '../models/schedule_model.dart';
import '../models/scheduled_log_model.dart';
import '../models/takeoff_models.dart';

/// Mock seam for the Projects list and Project Detail.
///
///   API: GET /projects                       -> [allProjects]
///   API: GET /projects/{id}/change-orders     -> changeOrders(id)
///   API: GET /projects/{id}/closeout-readiness -> closeoutReadiness(id)
///   API: GET /projects/{id}/geofence-settings  -> geofenceSettings(id)
///   API: GET /projects/{id}/scheduled-logs     -> scheduledLogSettings(id)
///   API: GET /projects/{id}/geofence-compliance?start&end -> shiftStatuses(...)
class ProjectsMockData {
  ProjectsMockData._();

  static List<ProjectModel> allProjects() {
    return [
      ProjectModel(
        id: 'proj_260760',
        number: '260760',
        title: "ODNR Boat Ramp To be Demo'd and Rebuilt at Berlin Lake",
        status: ProjectStatus.planning,
        clientName: 'Stump and Dailey',
        superintendent: 'Site Superintendent',
        estimator: 'Organization Admin',
        completionProgress: 0.62,
        healthScore: 81,
        isRecordActive: true,
        contactName: 'James Wilson',
        contactEmail: null,
        contactPhone: null,
        location: null,
        riskBreakdown: const [
          RiskBreakdownItem(label: 'Safety Risk', weight: 0.25, level: RiskLevel.low),
          RiskBreakdownItem(label: 'Schedule Risk', weight: 0.35, level: RiskLevel.medium),
          RiskBreakdownItem(label: 'Cost Risk', weight: 0.40, level: RiskLevel.high),
        ],
        budget: 0,
        contractAmount: 0,
        marginPercent: 0,
        description: 'Demolition and reconstruction of an ODNR boat ramp at '
            'Berlin Lake.',
        dataQualityScore: 10,
      ),
      const ProjectModel(
        id: 'proj_200902',
        number: '200902',
        title: 'County Route 4 Bridge Deck Replacement & Paving',
        status: ProjectStatus.active,
        clientName: 'Ohio Dept of Transportation',
        superintendent: 'Mark Robinson',
        estimator: 'Sarah Jenkins',
        completionProgress: 0.88,
        healthScore: 94,
        contractAmount: 0,
        description: 'Replacement of the County Route 4 bridge deck and '
            'approach paving.',
      ),
    ];
  }

  static List<ChangeOrderModel> changeOrders(String projectId) => const [];

  static CloseoutReadinessModel closeoutReadiness(String projectId) =>
      const CloseoutReadinessModel();

  static GeofenceSettings geofenceSettings(String projectId) =>
      const GeofenceSettings();

  static const List<String> payrollFormVariants = [
    'Federal WH-347',
    'California DIR PWR',
    'New York LS 25',
    'Texas DOT',
  ];

  static List<ScheduledLogSettings> scheduledLogSettings(String projectId) => [
        const ScheduledLogSettings(type: ScheduledLogType.rfi),
        const ScheduledLogSettings(type: ScheduledLogType.submittal),
      ];

  static Future<List<ShiftGeofenceStatus>> shiftStatuses(
    String projectId, {
    required DateTime start,
    required DateTime end,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const [];
  }

  // API: GET /projects/{id}/job-info
  static JobInfoModel jobInfo(String projectId) => const JobInfoModel();

  // API: PUT /projects/{id}/job-info
  static Future<void> saveJobInfo(String projectId, JobInfoModel info) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  // API: GET /projects/{id}/risks
  static List<RiskModel> risks(String projectId) => const [];

  /// Flip to `false` to see the "No schedule events yet" empty state and
  /// the Generate Schedule button instead of the seeded Gantt chart.
  static const bool seedSchedulePreview = true;

  /// Day 0 of the Gantt timeline (matches the first date in the Critical
  /// Path reference). API: part of GET /projects/{id}/schedule.
  static DateTime scheduleStart(String projectId) => DateTime(2026, 7, 31);

  // API: GET /projects/{id}/schedule
  static List<GanttTaskModel> ganttTasks(String projectId) =>
      seedSchedulePreview ? _sampleGanttTasks : const [];

  // API: POST /projects/{id}/schedule/generate
  static Future<List<GanttTaskModel>> generateSchedule(String projectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _sampleGanttTasks;
  }

  // API: GET /projects/{id}/schedule/forecast — values copied from the
  // reference (no SPI yet, zero variance), not derived from the tasks.
  static ScheduleForecastModel scheduleForecast(String projectId) =>
      ScheduleForecastModel(
        projectedCompletion: DateTime(2026, 10, 14),
        baselineCompletion: DateTime(2026, 10, 14),
        schedulePerformanceIndex: null,
        baselineVarianceDays: 0,
        criticalPathRemainingDays: 91,
      );

  // API: GET /projects/{id}/schedule/crews
  static List<CrewAssignmentModel> crewAssignments(String projectId) => const [];

  // API: POST /projects/{id}/schedule/send
  static Future<void> sendScheduleEmail(
    String projectId, {
    required List<String> recipients,
    required String subject,
    required String notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
  }

  // ---- Delays -------------------------------------------------------------

  // API: GET /projects/{id}/delays
  static List<DelayModel> delays(String projectId) => const [];

  // ---- Site Mobilization --------------------------------------------------

  // API: GET /projects/{id}/mobilization/checklist
  static List<MobilizationChecklistItem> mobilizationChecklist(String projectId) =>
      const [];

  // API: GET /projects/{id}/mobilization/method-statements
  static List<MethodStatementModel> methodStatements(String projectId) => const [];

  // ---- Plans & Takeoff ----------------------------------------------------

  // API: GET /projects/{id}/documents
  static List<DocumentFolderModel> documentFolders(String projectId) => const [
        DocumentFolderModel(id: 'plans', name: 'Plans'),
        DocumentFolderModel(id: 'specifications', name: 'Specifications'),
        DocumentFolderModel(id: 'takeoff', name: 'Takeoff'),
        DocumentFolderModel(id: 'supporting', name: 'Supporting Documents'),
        DocumentFolderModel(
            id: 'libraries', name: 'Libraries', kind: DocumentFolderKind.library),
      ];

  // API: GET /projects/{id}/addenda
  static List<AddendumModel> addenda(String projectId) => const [];

  // API: GET /projects/{id}/drawing-sets
  static List<DrawingSetModel> drawingSets(String projectId) => const [];

  // API: GET /projects/{id}/takeoff/reports/{kind}/quantities
  static List<String> reportQuantityOptions(String projectId, ReportKind kind) =>
      const [];

  // API: GET /projects/{id}/takeoff/reports/{kind}
  static List<TakeoffItemModel> reportItems(String projectId, ReportKind kind) =>
      const [];

  // API: GET /projects/{id}/takeoff/field-items
  static List<TakeoffItemModel> fieldTakeoffItems(String projectId) => const [];

  // ---- Scope & Progress / Materials ---------------------------------------

  // API: GET /projects/{id}/scope-items
  static List<ScopeItemModel> scopeItems(String projectId) => const [];

  // API: GET /projects/{id}/material-usage
  static List<MaterialUsageModel> materialUsages(String projectId) => const [];

  // ---- Estimate -------------------------------------------------------------

  // API: GET /projects/{id}/estimate/line-items
  static List<EstimateLineItemModel> estimateLineItems(String projectId) => const [];

  /// Org-wide estimating defaults (the "Org default: 0%" hints). All zero
  /// in the reference. API: GET /org/estimating-defaults
  static const Map<MarkupKind, double> orgMarkupDefaults = {
    MarkupKind.laborBurden: 0,
    MarkupKind.smallTools: 0,
    MarkupKind.overhead: 0,
    MarkupKind.profit: 0,
    MarkupKind.bond: 0,
    MarkupKind.escalation: 0,
    MarkupKind.waste: 0,
  };

  /// Options for "Labor Classification (from Cost Rates)" — guessed, the
  /// reference only shows the manual-entry default.
  /// API: GET /org/cost-rates/labor
  static const List<String> laborClassifications = [
    manualLaborClassification,
    'Laborer',
    'Carpenter',
    'Mason',
    'Electrician',
    'Operator',
    'Foreman',
  ];

  /// Takeoff categories offered by "Import Takeoff Quantities". The
  /// reference only shows the empty state ("Import 0 Categories"), so this
  /// is empty until the takeoff API exists.
  /// API: GET /projects/{id}/takeoff/categories
  static List<TakeoffCategoryModel> takeoffCategories(String projectId) => const [];

  // ---- Location Hierarchy ------------------------------------------------------

  // API: GET /projects/{id}/locations
  static List<LocationModel> locations(String projectId) => const [];

  // ---- Procurement --------------------------------------------------------------

  // API: GET /projects/{id}/purchase-requests
  static List<PurchaseRequestModel> purchaseRequests(String projectId) => const [];

  /// Guessed — the "Cost Code" field is a search-or-type box in the
  /// reference with no list shown. API: GET /org/cost-codes
  static const List<String> costCodes = [
    '01-1000 General Requirements',
    '03-3000 Cast-in-Place Concrete',
    '04-2000 Unit Masonry',
    '06-1000 Rough Carpentry',
    '09-3000 Tiling',
    '26-0500 Electrical',
  ];

  static const List<GanttTaskModel> _sampleGanttTasks = [
    GanttTaskModel(
        id: 't1',
        name: 'Project Mobilization & Site Setup',
        durationDays: 3,
        startOffsetDays: 0,
        floatDays: 6,
        barKind: GanttBarKind.float),
    GanttTaskModel(
        id: 't2',
        name: 'Environmental Permits & Licensing',
        durationDays: 5,
        startOffsetDays: 3,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't3',
        name: 'Existing Boat Ramp Demolition',
        durationDays: 7,
        startOffsetDays: 8,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't4',
        name: 'Site Excavation & Grading',
        durationDays: 5,
        startOffsetDays: 15,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't5',
        name: 'Subbase & Aggregate Installation',
        durationDays: 4,
        startOffsetDays: 20,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't6',
        name: 'Ramp Foundation & Formwork',
        durationDays: 6,
        startOffsetDays: 24,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't7',
        name: 'Concrete Ramp Pour & Finishing',
        durationDays: 2,
        startOffsetDays: 30,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't8',
        name: 'Concrete Curing Period',
        durationDays: 14,
        startOffsetDays: 32,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't9',
        name: 'Parking Area & Access Drive Work',
        durationDays: 6,
        startOffsetDays: 24,
        floatDays: 8,
        barKind: GanttBarKind.planned),
    GanttTaskModel(
        id: 't10',
        name: 'Drainage & Stormwater Management',
        durationDays: 5,
        startOffsetDays: 30,
        floatDays: 9,
        barKind: GanttBarKind.planned),
    GanttTaskModel(
        id: 't11',
        name: 'Courtesy Dock & Boarding Float',
        durationDays: 6,
        startOffsetDays: 46,
        isCriticalPath: true,
        barKind: GanttBarKind.critical),
    GanttTaskModel(
        id: 't12',
        name: 'Signage, Striping & Amenities',
        durationDays: 3,
        startOffsetDays: 52,
        floatDays: 7,
        barKind: GanttBarKind.planned),
  ];

  static List<OptimizationRecommendationModel> optimizationRecommendations(String projectId) => const [
        OptimizationRecommendationModel(
          id: 'rec1',
          title: 'Tasks with Excessive Float',
          description: '4 task(s) have more than 5 days of float: Parking Area & '
              'Access Drive Work, Drainage & Stormwater Management, Signage, '
              'Striping & Amenities... Consider reallocating resources from '
              'these tasks to critical path items.',
          daysSaved: 3,
        ),
        OptimizationRecommendationModel(
          id: 'rec2',
          title: 'Resource Leveling Suggestion',
          description: 'The critical path has 10 tasks. Consider adding resources '
              'to "Concrete Curing Period" (14 days) to reduce its duration and '
              'compress the overall schedule.',
          daysSaved: 3,
        ),
      ];

  static List<ScheduleSendRecord> recentScheduleSends(String projectId) => const [];
}
