import 'package:flutter/material.dart';
import 'package:smart_construction/src/utils/app_color.dart';

/// Overall lifecycle stage — drives the pill on the project card and
/// the Project Detail header ("Planning", green "Active", etc).
enum ProjectStatus { planning, active, onHold, completed, delayed }

extension ProjectStatusX on ProjectStatus {
  String get label {
    switch (this) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.delayed:
        return 'Delayed';
    }
  }

  Color get color {
    switch (this) {
      case ProjectStatus.planning:
        return const Color(0xFF8B5CF6); // purple
      case ProjectStatus.active:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.grey;
      case ProjectStatus.completed:
        return Colors.blue;
      case ProjectStatus.delayed:
        return AppColors.redColor;
    }
  }
}

enum RiskLevel { low, medium, high }

extension RiskLevelX on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
    }
  }

  Color get color {
    switch (this) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.medium:
        return Colors.orange;
      case RiskLevel.high:
        return AppColors.redColor;
    }
  }

  /// How full the risk bar renders — visualizes severity, independent
  /// of the category's scoring [weight].
  double get barFraction {
    switch (this) {
      case RiskLevel.low:
        return 0.3;
      case RiskLevel.medium:
        return 0.62;
      case RiskLevel.high:
        return 0.9;
    }
  }
}

/// Thresholds are a guess (not in the reference) chosen so 81/100 and
/// 94/100 both land on green, matching the Figma health badges —
/// flagged in NOTES_PROJECTS.md.
Color healthScoreColor(int score) {
  if (score >= 80) return Colors.green;
  if (score >= 60) return Colors.orange;
  return AppColors.redColor;
}

enum ProjectDetailTab {
  overview,
  jobInfo,
  risks,
  schedule,
  delays,
  mobilization,
  plansTakeoff,
  fieldTakeoff,
  scopeProgress,
  materials,
  estimate,
  location,
  procurement,
  financials,
  dailyNotes,
  inspections,
  punchList,
  photosVideos,
  lidarScan,
  tmTracking,
  laborHours,
  subcontractors,
  equipment,
  brief,
  aiAnalysis,
  rfis,
  transmittals,
  submittals,
  closeoutPackage,
  warranty,
  maintenance,
  reports,
  projectVault,
  portalAccess,
}

extension ProjectDetailTabX on ProjectDetailTab {
  String get label {
    switch (this) {
      case ProjectDetailTab.overview:
        return 'Overview';
      case ProjectDetailTab.jobInfo:
        return 'Job Info';
      case ProjectDetailTab.risks:
        return 'Risks';
      case ProjectDetailTab.schedule:
        return 'Schedule';
      case ProjectDetailTab.delays:
        return 'Delays';
      case ProjectDetailTab.mobilization:
        return 'Mobilization';
      case ProjectDetailTab.plansTakeoff:
        return 'Plans & Takeoff';
      case ProjectDetailTab.fieldTakeoff:
        return 'Field Takeoff';
      case ProjectDetailTab.scopeProgress:
        return 'Scope & Progress';
      case ProjectDetailTab.materials:
        return 'Materials';
      case ProjectDetailTab.estimate:
        return 'Estimate';
      case ProjectDetailTab.location:
        return 'Location';
      case ProjectDetailTab.procurement:
        return 'Procurement';
      case ProjectDetailTab.financials:
        return 'Financials';
      case ProjectDetailTab.dailyNotes:
        return 'Daily Notes';
      case ProjectDetailTab.inspections:
        return 'Inspections';
      case ProjectDetailTab.punchList:
        return 'Punch List';
      case ProjectDetailTab.photosVideos:
        return 'Photos & Videos';
      case ProjectDetailTab.lidarScan:
        return 'LiDAR Scan';
      case ProjectDetailTab.tmTracking:
        return 'T&M Tracking';
      case ProjectDetailTab.laborHours:
        return 'Labor';
      case ProjectDetailTab.subcontractors:
        return 'Subcontractors';
      case ProjectDetailTab.equipment:
        return 'Equipment';
      case ProjectDetailTab.brief:
        return 'Brief';
      case ProjectDetailTab.aiAnalysis:
        return 'AI Jobs';
      case ProjectDetailTab.rfis:
        return 'RFIs';
      case ProjectDetailTab.transmittals:
        return 'Transmittals';
      case ProjectDetailTab.submittals:
        return 'Submittals';
      case ProjectDetailTab.closeoutPackage:
        return 'Closeout Package';
      case ProjectDetailTab.warranty:
        return 'Warranty';
      case ProjectDetailTab.maintenance:
        return 'Maintenance';
      case ProjectDetailTab.reports:
        return 'Reports';
      case ProjectDetailTab.projectVault:
        return 'Project Vault';
      case ProjectDetailTab.portalAccess:
        return 'Portal Access';
    }
  }

  /// Scaffold app bar title while this tab is selected — taken from each
  /// tab's own reference screen (Schedule -> "Project Schedule",
  /// Delays -> "Project Delay", Mobilization -> "Site Mobilization").
  String get detailTitle {
    switch (this) {
      case ProjectDetailTab.overview:
        return 'Project Detail';
      case ProjectDetailTab.jobInfo:
        return 'Job Information';
      case ProjectDetailTab.risks:
        return 'Risk Register';
      case ProjectDetailTab.schedule:
        return 'Project Schedule';
      case ProjectDetailTab.delays:
        return 'Project Delay';
      case ProjectDetailTab.mobilization:
        return 'Site Mobilization';
      case ProjectDetailTab.plansTakeoff:
        return 'Plans & Takeoff';
      case ProjectDetailTab.fieldTakeoff:
        return 'Field Takeoff';
      case ProjectDetailTab.scopeProgress:
        return 'Scope & Progress';
      case ProjectDetailTab.materials:
        return 'Materials';
      case ProjectDetailTab.estimate:
        return 'Project Estimate';
      case ProjectDetailTab.location:
        return 'Location Hierarchy';
      case ProjectDetailTab.procurement:
        return 'Procurement';
      case ProjectDetailTab.financials:
        return 'Financials';
      case ProjectDetailTab.dailyNotes:
        return 'Daily Notes';
      case ProjectDetailTab.inspections:
        return 'Inspection'; // singular, as in the reference's app bar
      case ProjectDetailTab.punchList:
        return 'Punch List';
      case ProjectDetailTab.photosVideos:
        return 'Photos & Videos';
      case ProjectDetailTab.lidarScan:
        return 'LiDAR Scan';
      case ProjectDetailTab.tmTracking:
        return 'T&M Tracking';
      case ProjectDetailTab.laborHours:
        return 'Labor Hours';
      case ProjectDetailTab.subcontractors:
        return 'Subcontractors & Contracts';
      case ProjectDetailTab.equipment:
        return 'Equipment';
      case ProjectDetailTab.brief:
        return 'Project Detail'; // the Brief reference reuses this title
      case ProjectDetailTab.aiAnalysis:
        return 'AI Jobs Analysis';
      case ProjectDetailTab.rfis:
        return 'RFIs';
      case ProjectDetailTab.transmittals:
        return 'Document Transmittals';
      case ProjectDetailTab.submittals:
        return 'Submittals';
      case ProjectDetailTab.closeoutPackage:
        return 'Project Closeout';
      case ProjectDetailTab.warranty:
        return 'Warranty';
      case ProjectDetailTab.maintenance:
        return 'Maintenance';
      case ProjectDetailTab.reports:
        return 'Progress Reports';
      case ProjectDetailTab.projectVault:
        return 'Project Vault';
      case ProjectDetailTab.portalAccess:
        // The reference titles this "Client Portal" or "Subcontractor
        // Portal" depending on the strip underneath; ProjectDetailView
        // swaps in PortalSubTab.detailTitle while this tab is selected.
        return 'Client Portal';
    }
  }

  /// Muted line shown under the title (above the tab bar). Only Job Info
  /// and Risks have one in their reference screens; every other tab
  /// either has none or puts its description inside the tab body.
  String? get detailSubtitle {
    switch (this) {
      case ProjectDetailTab.jobInfo:
        return 'Estimator handoff packet for QuickBooks setup';
      case ProjectDetailTab.risks:
        return 'Identify, assess, and track project risks';
      case ProjectDetailTab.overview:
      case ProjectDetailTab.schedule:
      case ProjectDetailTab.delays:
      case ProjectDetailTab.mobilization:
      case ProjectDetailTab.plansTakeoff:
      case ProjectDetailTab.fieldTakeoff:
      case ProjectDetailTab.scopeProgress:
      case ProjectDetailTab.materials:
      case ProjectDetailTab.estimate:
      case ProjectDetailTab.location:
      case ProjectDetailTab.procurement:
      case ProjectDetailTab.financials:
      case ProjectDetailTab.dailyNotes:
      case ProjectDetailTab.inspections:
      case ProjectDetailTab.punchList:
      case ProjectDetailTab.photosVideos:
      case ProjectDetailTab.lidarScan:
      case ProjectDetailTab.tmTracking:
      case ProjectDetailTab.laborHours:
      case ProjectDetailTab.subcontractors:
      case ProjectDetailTab.equipment:
      case ProjectDetailTab.brief:
      case ProjectDetailTab.aiAnalysis:
      case ProjectDetailTab.rfis:
      case ProjectDetailTab.transmittals:
      case ProjectDetailTab.submittals:
      case ProjectDetailTab.closeoutPackage:
      case ProjectDetailTab.warranty:
      case ProjectDetailTab.maintenance:
      case ProjectDetailTab.reports:
      case ProjectDetailTab.projectVault:
      case ProjectDetailTab.portalAccess:
        return null;
    }
  }
}

enum GeofenceEnforcementMode { off, warn, block }

extension GeofenceEnforcementModeX on GeofenceEnforcementMode {
  String get label {
    switch (this) {
      case GeofenceEnforcementMode.off:
        return 'OFF';
      case GeofenceEnforcementMode.warn:
        return 'Warn';
      case GeofenceEnforcementMode.block:
        return 'Block';
    }
  }
}

enum LogCadence { off, daily, weekly, monthly }

extension LogCadenceX on LogCadence {
  String get label {
    switch (this) {
      case LogCadence.off:
        return "Off - don't send";
      case LogCadence.daily:
        return 'Daily';
      case LogCadence.weekly:
        return 'Weekly';
      case LogCadence.monthly:
        return 'Monthly';
    }
  }
}

/// Guessed set — the reference only shows a category filter, not the
/// actual options, flagged in NOTES_PROJECTS.md.
enum RiskCategory { safety, schedule, cost, quality, weather, other }

extension RiskCategoryX on RiskCategory {
  String get label {
    switch (this) {
      case RiskCategory.safety:
        return 'Safety';
      case RiskCategory.schedule:
        return 'Schedule';
      case RiskCategory.cost:
        return 'Cost';
      case RiskCategory.quality:
        return 'Quality';
      case RiskCategory.weather:
        return 'Weather';
      case RiskCategory.other:
        return 'Other';
    }
  }
}

/// Guessed set — flagged in NOTES_PROJECTS.md.
enum RiskStatus { open, mitigated, closed }

extension RiskStatusX on RiskStatus {
  String get label {
    switch (this) {
      case RiskStatus.open:
        return 'Open';
      case RiskStatus.mitigated:
        return 'Mitigated';
      case RiskStatus.closed:
        return 'Closed';
    }
  }
}

/// Color band for a Probability × Impact score (1–25), per the Heat
/// Map's legend.
enum RiskSeverityBand { low, medium, high, veryHigh, critical }

extension RiskSeverityBandX on RiskSeverityBand {
  String get label {
    switch (this) {
      case RiskSeverityBand.low:
        return 'Low';
      case RiskSeverityBand.medium:
        return 'Medium';
      case RiskSeverityBand.high:
        return 'High';
      case RiskSeverityBand.veryHigh:
        return 'Very High';
      case RiskSeverityBand.critical:
        return 'Critical';
    }
  }

  String get rangeLabel {
    switch (this) {
      case RiskSeverityBand.low:
        return '1-4';
      case RiskSeverityBand.medium:
        return '5-9';
      case RiskSeverityBand.high:
        return '10-14';
      case RiskSeverityBand.veryHigh:
        return '15-19';
      case RiskSeverityBand.critical:
        return '20-25';
    }
  }

  Color get color {
    switch (this) {
      case RiskSeverityBand.low:
        return const Color(0xFF7DE7A2); // pale green
      case RiskSeverityBand.medium:
        return const Color(0xFF48D080); // medium green
      case RiskSeverityBand.high:
        return const Color(0xFFEEB316); // amber
      case RiskSeverityBand.veryHigh:
        return const Color(0xFFF27A24); // deep orange
      case RiskSeverityBand.critical:
        return const Color(0xFFE53E3E); // red
    }
  }

  static RiskSeverityBand fromScore(int score) {
    if (score <= 4) return RiskSeverityBand.low;
    if (score <= 9) return RiskSeverityBand.medium;
    if (score <= 14) return RiskSeverityBand.high;
    if (score <= 19) return RiskSeverityBand.veryHigh;
    return RiskSeverityBand.critical;
  }
}

/// Meaning of each 1–5 Probability/Impact rating, per the Heat Map's
/// rating-scale legend.
const List<String> riskRatingScaleLabels = [
  'Negligible',
  'Minor',
  'Moderate',
  'Major',
  'Catastrophic',
];

/// Meaning of each 1–5 Probability rating on the Add Risk form's
/// "Probability(1-5)" dropdown — a likelihood scale, distinct from
/// [riskRatingScaleLabels] which rates Impact/severity. Guessed set
/// (only "3 - Possible" is shown in the reference), flagged in
/// NOTES_PROJECTS.md.
const List<String> riskProbabilityScaleLabels = [
  'Rare',
  'Unlikely',
  'Possible',
  'Likely',
  'Almost Certain',
];

/// Guessed — no reference options were shown for "Owner" on the Add
/// Risk form, flagged in NOTES_PROJECTS.md.
const List<String> riskOwnerOptions = [
  'Project Manager',
  'Superintendent',
  'Estimator',
  'Office Admin',
  'Safety Contact',
  'Other',
];

enum ScheduleSubTab { ganttChart, forecast, resources, criticalPath }

extension ScheduleSubTabX on ScheduleSubTab {
  String get label {
    switch (this) {
      case ScheduleSubTab.ganttChart:
        return 'Gantt Chart';
      case ScheduleSubTab.forecast:
        return 'Forecast';
      case ScheduleSubTab.resources:
        return 'Resources';
      case ScheduleSubTab.criticalPath:
        return 'Critical Path';
    }
  }
}

/// Which category of bar a Gantt task renders as, per the legend dots
/// (● Critical ● Planned ● Float).
enum GanttBarKind { critical, planned, float }

extension GanttBarKindX on GanttBarKind {
  String get label {
    switch (this) {
      case GanttBarKind.critical:
        return 'Critical';
      case GanttBarKind.planned:
        return 'Planned';
      case GanttBarKind.float:
        return 'Float';
    }
  }

  Color get color {
    switch (this) {
      case GanttBarKind.critical:
        return const Color(0xFFFEE2E2); // pink/red bar fill
      case GanttBarKind.planned:
        return const Color(0xFFE29D6E); // orange bar fill
      case GanttBarKind.float:
        return const Color(0xFFAFCBEE); // light blue bar fill
    }
  }
}

/// Progress of one Gantt task, shown as the badge on the Critical Path
/// chain ("Not Started" in the reference).
enum GanttTaskStatus { notStarted, inProgress, complete }

extension GanttTaskStatusX on GanttTaskStatus {
  String get label {
    switch (this) {
      case GanttTaskStatus.notStarted:
        return 'Not Started';
      case GanttTaskStatus.inProgress:
        return 'In Progress';
      case GanttTaskStatus.complete:
        return 'Complete';
    }
  }

  Color get background {
    switch (this) {
      case GanttTaskStatus.notStarted:
        return const Color(0xFFFFF1CC);
      case GanttTaskStatus.inProgress:
        return const Color(0xFFDCEBFF);
      case GanttTaskStatus.complete:
        return const Color(0xFFD9F5E5);
    }
  }

  Color get foreground {
    switch (this) {
      case GanttTaskStatus.notStarted:
        return const Color(0xFFB7791F);
      case GanttTaskStatus.inProgress:
        return const Color(0xFF2B6CB0);
      case GanttTaskStatus.complete:
        return const Color(0xFF1F8A4C);
    }
  }
}

/// Delays tab filters. The reference only shows the "All Statuses" /
/// "All Reason" pills (the subtitle names weather, scheduling and
/// contractor delays), so the option sets are guessed — flagged in
/// NOTES_PROJECT_TABS.md.
enum DelayReason { weather, scheduling, contractor }

extension DelayReasonX on DelayReason {
  String get label {
    switch (this) {
      case DelayReason.weather:
        return 'Weather';
      case DelayReason.scheduling:
        return 'Scheduling';
      case DelayReason.contractor:
        return 'Contractor';
    }
  }
}

enum DelayStatus { open, resolved }

extension DelayStatusX on DelayStatus {
  String get label {
    switch (this) {
      case DelayStatus.open:
        return 'Open';
      case DelayStatus.resolved:
        return 'Resolved';
    }
  }

  Color get color {
    switch (this) {
      case DelayStatus.open:
        return const Color(0xFFE08A2B);
      case DelayStatus.resolved:
        return const Color(0xFF1FA463);
    }
  }
}

enum MobilizationSubTab { checklist, methodStatements }

extension MobilizationSubTabX on MobilizationSubTab {
  String get label {
    switch (this) {
      case MobilizationSubTab.checklist:
        return 'Checklist';
      case MobilizationSubTab.methodStatements:
        return 'Method Statements';
    }
  }
}

enum PlansSubTab { plans, addenda, drawingSets, reports }

extension PlansSubTabX on PlansSubTab {
  String get label {
    switch (this) {
      case PlansSubTab.plans:
        return 'Plans';
      case PlansSubTab.addenda:
        return 'Addenda';
      case PlansSubTab.drawingSets:
        return 'Drawing Sets';
      case PlansSubTab.reports:
        return 'Reports';
    }
  }
}

/// Report types on Plans & Takeoff -> Reports. The reference cuts the
/// fourth label off ("Items L…"), so "Items List" is a guess and further
/// report types may exist — flagged in NOTES_PROJECT_TABS.md.
enum ReportKind { takeoffQuantity, takeoffSummary, measurements, itemsList }

extension ReportKindX on ReportKind {
  String get label {
    switch (this) {
      case ReportKind.takeoffQuantity:
        return 'Takeoff Quantity';
      case ReportKind.takeoffSummary:
        return 'Takeoff Summary';
      case ReportKind.measurements:
        return 'Measurements';
      case ReportKind.itemsList:
        return 'Items List';
    }
  }
}

enum FieldTakeoffSubTab { fieldView, locationBreakdown }

extension FieldTakeoffSubTabX on FieldTakeoffSubTab {
  String get label {
    switch (this) {
      case FieldTakeoffSubTab.fieldView:
        return 'Field View';
      case FieldTakeoffSubTab.locationBreakdown:
        return 'Location Breakdown';
    }
  }
}


// ---- Scope & Progress / Materials / Estimate / Location / Procurement ----

/// Unit choices for the Scope & Progress "All Units" filter. Guessed from
/// the units named in the references (SF, CY, "etc.") — flagged in
/// NOTES_ESTIMATING_TABS.md. Also reused by the line-item Unit hint.
const List<String> projectUnitOptions = ['SF', 'SY', 'CY', 'LF', 'EA', 'LS', 'TON', 'HR'];

/// Derived from completed vs. total quantity — see `ScopeItemModel.status`.
enum ScopeItemStatus { notStarted, inProgress, complete }

extension ScopeItemStatusX on ScopeItemStatus {
  String get label {
    switch (this) {
      case ScopeItemStatus.notStarted:
        return 'Not Started';
      case ScopeItemStatus.inProgress:
        return 'In Progress';
      case ScopeItemStatus.complete:
        return 'Complete';
    }
  }

  Color get background {
    switch (this) {
      case ScopeItemStatus.notStarted:
        return const Color(0xFFFFF1CC);
      case ScopeItemStatus.inProgress:
        return const Color(0xFFDCEBFF);
      case ScopeItemStatus.complete:
        return const Color(0xFFD9F5E5);
    }
  }

  Color get foreground {
    switch (this) {
      case ScopeItemStatus.notStarted:
        return const Color(0xFFB7791F);
      case ScopeItemStatus.inProgress:
        return const Color(0xFF2B6CB0);
      case ScopeItemStatus.complete:
        return const Color(0xFF1F8A4C);
    }
  }
}

/// Draft / Approved badge on the Estimate tab. Only "Draft" appears in
/// the reference; "Approved" is the state "Approve & Sync to Budget"
/// moves it to.
enum EstimateStatus { draft, approved }

extension EstimateStatusX on EstimateStatus {
  String get label => this == EstimateStatus.draft ? 'Draft' : 'Approved';

  Color get background =>
      this == EstimateStatus.draft ? const Color(0xFFF1F1F1) : const Color(0xFFD9F5E5);

  Color get foreground =>
      this == EstimateStatus.draft ? const Color(0xFF6B7280) : const Color(0xFF1F8A4C);
}

/// The seven rows on the Markup Overrides screen, in the reference's order.
enum MarkupKind { laborBurden, smallTools, overhead, profit, bond, escalation, waste }

extension MarkupKindX on MarkupKind {
  String get label {
    switch (this) {
      case MarkupKind.laborBurden:
        return 'Labor Burden';
      case MarkupKind.smallTools:
        return 'Small Tools';
      case MarkupKind.overhead:
        return 'Overhead';
      case MarkupKind.profit:
        return 'Profit';
      case MarkupKind.bond:
        return 'Bond';
      case MarkupKind.escalation:
        return 'Escalation';
      case MarkupKind.waste:
        return 'Waste Factor';
    }
  }
}

/// Guessed — the Add Manual Line Items form shows a "Select a category"
/// dropdown with no options. Flagged in NOTES_ESTIMATING_TABS.md.
enum EstimateLineCategory { material, labor, equipment, subcontract, other }

extension EstimateLineCategoryX on EstimateLineCategory {
  String get label {
    switch (this) {
      case EstimateLineCategory.material:
        return 'Material';
      case EstimateLineCategory.labor:
        return 'Labor';
      case EstimateLineCategory.equipment:
        return 'Equipment';
      case EstimateLineCategory.subcontract:
        return 'Subcontract';
      case EstimateLineCategory.other:
        return 'Other';
    }
  }
}

/// Value of the "Labor Classification (from Cost Rates)" dropdown when no
/// rate is picked ("No classification (manual entry)" in the reference).
const String manualLaborClassification = 'No classification (manual entry)';

/// Location Hierarchy levels — the reference's Add Location form defaults
/// to BUILDING, and its hint/description name Building, Floor, Room and
/// Zone ("Organize Project Takeoff by Building, Floor, Rooms, and Zone").
enum LocationLevel { building, floor, room, zone }

extension LocationLevelX on LocationLevel {
  /// Upper-case, as the reference's dropdown shows it ("BUILDING").
  String get label => name.toUpperCase();

  String get title => '${name[0].toUpperCase()}${name.substring(1)}';
}

enum PurchaseRequestStatus { pending, approved, rejected, ordered }

extension PurchaseRequestStatusX on PurchaseRequestStatus {
  String get label {
    switch (this) {
      case PurchaseRequestStatus.pending:
        return 'Pending';
      case PurchaseRequestStatus.approved:
        return 'Approved';
      case PurchaseRequestStatus.rejected:
        return 'Rejected';
      case PurchaseRequestStatus.ordered:
        return 'Ordered';
    }
  }

  Color get background {
    switch (this) {
      case PurchaseRequestStatus.pending:
        return const Color(0xFFFFF1CC);
      case PurchaseRequestStatus.approved:
        return const Color(0xFFD9F5E5);
      case PurchaseRequestStatus.rejected:
        return const Color(0xFFFEE2E2);
      case PurchaseRequestStatus.ordered:
        return const Color(0xFFDCEBFF);
    }
  }

  Color get foreground {
    switch (this) {
      case PurchaseRequestStatus.pending:
        return const Color(0xFFB7791F);
      case PurchaseRequestStatus.approved:
        return const Color(0xFF1F8A4C);
      case PurchaseRequestStatus.rejected:
        return const Color(0xFFC53030);
      case PurchaseRequestStatus.ordered:
        return const Color(0xFF2B6CB0);
    }
  }
}

/// Requests / Orders / Receipts / Invoices / Delivery Schedule strip on the
/// Procurement tab. The strip is cut off at the right edge in every
/// reference frame, so "Delivery Schedule" is the only label beyond the
/// original four that could be read — flagged in NOTES_PROCUREMENT_FINANCIALS.md.
enum ProcurementSubTab { requests, orders, receipts, invoices, deliverySchedule }

extension ProcurementSubTabX on ProcurementSubTab {
  String get label {
    switch (this) {
      case ProcurementSubTab.requests:
        return 'Requests';
      case ProcurementSubTab.orders:
        return 'Orders';
      case ProcurementSubTab.receipts:
        return 'Receipts';
      case ProcurementSubTab.invoices:
        return 'Invoices';
      case ProcurementSubTab.deliverySchedule:
        return 'Delivery Schedule';
    }
  }
}

/// Status filter on the Orders list ("All Statuses"). The reference only
/// shows the pill, so the set is a guess.
enum PurchaseOrderStatus { draft, issued, partiallyReceived, received, closed }

extension PurchaseOrderStatusX on PurchaseOrderStatus {
  String get label {
    switch (this) {
      case PurchaseOrderStatus.draft:
        return 'Draft';
      case PurchaseOrderStatus.issued:
        return 'Issued';
      case PurchaseOrderStatus.partiallyReceived:
        return 'Partially Received';
      case PurchaseOrderStatus.received:
        return 'Received';
      case PurchaseOrderStatus.closed:
        return 'Closed';
    }
  }

  Color get background {
    switch (this) {
      case PurchaseOrderStatus.draft:
        return const Color(0xFFF1F1F1);
      case PurchaseOrderStatus.issued:
        return const Color(0xFFDCEBFF);
      case PurchaseOrderStatus.partiallyReceived:
        return const Color(0xFFFFF1CC);
      case PurchaseOrderStatus.received:
        return const Color(0xFFD9F5E5);
      case PurchaseOrderStatus.closed:
        return const Color(0xFFE5E7EB);
    }
  }

  Color get foreground {
    switch (this) {
      case PurchaseOrderStatus.draft:
        return const Color(0xFF6B7280);
      case PurchaseOrderStatus.issued:
        return const Color(0xFF2B6CB0);
      case PurchaseOrderStatus.partiallyReceived:
        return const Color(0xFFB7791F);
      case PurchaseOrderStatus.received:
        return const Color(0xFF1F8A4C);
      case PurchaseOrderStatus.closed:
        return const Color(0xFF4B5563);
    }
  }
}

/// "All Upcoming" filter on Delivery Schedule. Guessed option set.
enum DeliveryWindow { today, thisWeek, thisMonth }

extension DeliveryWindowX on DeliveryWindow {
  String get label {
    switch (this) {
      case DeliveryWindow.today:
        return 'Today';
      case DeliveryWindow.thisWeek:
        return 'This Week';
      case DeliveryWindow.thisMonth:
        return 'This Month';
    }
  }
}

// ---- Financials ----------------------------------------------------------

/// Sub-tab strip on the Financials tab. The reference shows the strip at
/// four different scroll positions with overlapping labels (Live
/// Financials / Budget / Cost Ledger / Cost Explorer, then Change Orders /
/// Schedule of Values / Billing / Receipts, then Production Rates), so
/// this order is stitched together — flagged in NOTES_PROCUREMENT_FINANCIALS.md.
enum FinancialsSubTab {
  liveFinancials,
  budget,
  costLedger,
  costExplorer,
  changeOrders,
  scheduleOfValues,
  billing,
  receipts,
  productionRates,
}

extension FinancialsSubTabX on FinancialsSubTab {
  String get label {
    switch (this) {
      case FinancialsSubTab.liveFinancials:
        return 'Live Financials';
      case FinancialsSubTab.budget:
        return 'Budget';
      case FinancialsSubTab.costLedger:
        return 'Cost Ledger';
      case FinancialsSubTab.costExplorer:
        return 'Cost Explorer';
      case FinancialsSubTab.changeOrders:
        return 'Change Orders';
      case FinancialsSubTab.scheduleOfValues:
        return 'Schedule of Values';
      case FinancialsSubTab.billing:
        return 'Billing';
      case FinancialsSubTab.receipts:
        return 'Receipts';
      case FinancialsSubTab.productionRates:
        return 'Production Rates';
    }
  }
}

/// Orange strip under "New SOV": Pay App / Payments / Lien Waivers / CO
/// Tie-Out (the fourth reads "Co Tie-Out" in the reference).
enum SovSubTab { payApp, payments, lienWaivers, coTieOut }

extension SovSubTabX on SovSubTab {
  String get label {
    switch (this) {
      case SovSubTab.payApp:
        return 'Pay App';
      case SovSubTab.payments:
        return 'Payments';
      case SovSubTab.lienWaivers:
        return 'Lien Waivers';
      case SovSubTab.coTieOut:
        return 'CO Tie-Out';
    }
  }
}

/// The six cost buckets on Live Financials, in the reference's order.
enum CostCategory { labor, materials, subcontractors, equipment, tmTickets, otherExpenses }

extension CostCategoryX on CostCategory {
  String get label {
    switch (this) {
      case CostCategory.labor:
        return 'Labor';
      case CostCategory.materials:
        return 'Materials';
      case CostCategory.subcontractors:
        return 'Subcontractors';
      case CostCategory.equipment:
        return 'Equipment';
      case CostCategory.tmTickets:
        return 'T&M Tickets';
      case CostCategory.otherExpenses:
        return 'Other Expenses';
    }
  }

  IconData get icon {
    switch (this) {
      case CostCategory.labor:
        return Icons.groups_outlined;
      case CostCategory.materials:
        return Icons.inventory_2_outlined;
      case CostCategory.subcontractors:
        return Icons.engineering_outlined;
      case CostCategory.equipment:
        return Icons.construction;
      case CostCategory.tmTickets:
        return Icons.receipt_long_outlined;
      case CostCategory.otherExpenses:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case CostCategory.labor:
        return const Color(0xFF3B82F6);
      case CostCategory.materials:
        return const Color(0xFF10B981);
      case CostCategory.subcontractors:
        return const Color(0xFFF59E0B);
      case CostCategory.equipment:
        return const Color(0xFFEF4444);
      case CostCategory.tmTickets:
        return const Color(0xFF8B5CF6);
      case CostCategory.otherExpenses:
        return const Color(0xFF6B7280);
    }
  }
}

/// Cost Explorer "All Modules" filter — which part of the app produced the
/// cost event. Guessed from the empty-state copy (PO receipts, payroll
/// runs, T&M tickets).
enum CostModule { procurement, payroll, tmTickets, expenses }

extension CostModuleX on CostModule {
  String get label {
    switch (this) {
      case CostModule.procurement:
        return 'Procurement';
      case CostModule.payroll:
        return 'Payroll';
      case CostModule.tmTickets:
        return 'T&M Tickets';
      case CostModule.expenses:
        return 'Expenses';
    }
  }
}

/// Cost Explorer grouping dropdown ("By Cost Code" in the reference).
enum CostGrouping { costCode, category, module }

extension CostGroupingX on CostGrouping {
  String get label {
    switch (this) {
      case CostGrouping.costCode:
        return 'By Cost Code';
      case CostGrouping.category:
        return 'By Category';
      case CostGrouping.module:
        return 'By Module';
    }
  }

  String get summaryTitle {
    switch (this) {
      case CostGrouping.costCode:
        return 'Summary - Grouped by Cost Code';
      case CostGrouping.category:
        return 'Summary - Grouped by Category';
      case CostGrouping.module:
        return 'Summary - Grouped by Module';
    }
  }
}

enum ChangeOrderRecordStatus { pending, approved, rejected }

extension ChangeOrderRecordStatusX on ChangeOrderRecordStatus {
  String get label {
    switch (this) {
      case ChangeOrderRecordStatus.pending:
        return 'Pending';
      case ChangeOrderRecordStatus.approved:
        return 'Approved';
      case ChangeOrderRecordStatus.rejected:
        return 'Rejected';
    }
  }

  Color get background {
    switch (this) {
      case ChangeOrderRecordStatus.pending:
        return const Color(0xFFFFF1CC);
      case ChangeOrderRecordStatus.approved:
        return const Color(0xFFD9F5E5);
      case ChangeOrderRecordStatus.rejected:
        return const Color(0xFFFEE2E2);
    }
  }

  Color get foreground {
    switch (this) {
      case ChangeOrderRecordStatus.pending:
        return const Color(0xFFB7791F);
      case ChangeOrderRecordStatus.approved:
        return const Color(0xFF1F8A4C);
      case ChangeOrderRecordStatus.rejected:
        return const Color(0xFFC53030);
    }
  }
}

/// Payment Method dropdown on Record Payment ("Check" is the default shown
/// in the reference; the rest are guessed).
enum PaymentMethod { check, ach, wire, creditCard, cash }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.check:
        return 'Check';
      case PaymentMethod.ach:
        return 'ACH';
      case PaymentMethod.wire:
        return 'Wire';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.cash:
        return 'Cash';
    }
  }
}

/// Waiver Type dropdown on Create Lien Waiver ("Conditional Partial" is the
/// default shown; the other three are the standard lien-waiver forms).
enum LienWaiverType {
  conditionalPartial,
  unconditionalPartial,
  conditionalFinal,
  unconditionalFinal,
}

extension LienWaiverTypeX on LienWaiverType {
  String get label {
    switch (this) {
      case LienWaiverType.conditionalPartial:
        return 'Conditional Partial';
      case LienWaiverType.unconditionalPartial:
        return 'Unconditional Partial';
      case LienWaiverType.conditionalFinal:
        return 'Conditional Final';
      case LienWaiverType.unconditionalFinal:
        return 'Unconditional Final';
    }
  }
}


// ---- Billing / Production Rates / Daily Notes / Inspections ----------------

/// Benchmarks / Cost Analytics underline tabs on Production Rates.
enum ProductionRatesTab { benchmarks, costAnalytics }

extension ProductionRatesTabX on ProductionRatesTab {
  String get label =>
      this == ProductionRatesTab.benchmarks ? 'Benchmarks' : 'Cost Analytics';

  IconData get icon =>
      this == ProductionRatesTab.benchmarks ? Icons.bar_chart : Icons.attach_money;
}

/// Filters on the Daily Notes list. The reference shows only a "Filters"
/// button, so the options are guessed — flagged in NOTES_BILLING_NOTES_INSPECTIONS.md.
enum DailyNoteFilter { all, today, thisWeek, withMaterials }

extension DailyNoteFilterX on DailyNoteFilter {
  String get label {
    switch (this) {
      case DailyNoteFilter.all:
        return 'All notes';
      case DailyNoteFilter.today:
        return 'Today';
      case DailyNoteFilter.thisWeek:
        return 'This week';
      case DailyNoteFilter.withMaterials:
        return 'With material usage';
    }
  }
}

/// Inspections stat row is Pending / Passed / Failed.
enum InspectionStatus { pending, passed, failed }

extension InspectionStatusX on InspectionStatus {
  String get label {
    switch (this) {
      case InspectionStatus.pending:
        return 'Pending';
      case InspectionStatus.passed:
        return 'Passed';
      case InspectionStatus.failed:
        return 'Failed';
    }
  }

  Color get color {
    switch (this) {
      case InspectionStatus.pending:
        return const Color(0xFFD97706);
      case InspectionStatus.passed:
        return const Color(0xFF16A34A);
      case InspectionStatus.failed:
        return const Color(0xFFDC2626);
    }
  }
}

/// Guessed — the "All Types" pill shows no options.
enum InspectionType { foundation, framing, electrical, plumbing, safety, finalInspection }

extension InspectionTypeX on InspectionType {
  String get label {
    switch (this) {
      case InspectionType.foundation:
        return 'Foundation';
      case InspectionType.framing:
        return 'Framing';
      case InspectionType.electrical:
        return 'Electrical';
      case InspectionType.plumbing:
        return 'Plumbing';
      case InspectionType.safety:
        return 'Safety';
      case InspectionType.finalInspection:
        return 'Final';
    }
  }
}

/// Material Testing stat row is Pending / In Progress / Passed / Failed.
enum MaterialTestStatus { pending, inProgress, passed, failed }

extension MaterialTestStatusX on MaterialTestStatus {
  String get label {
    switch (this) {
      case MaterialTestStatus.pending:
        return 'Pending';
      case MaterialTestStatus.inProgress:
        return 'In Progress';
      case MaterialTestStatus.passed:
        return 'Passed';
      case MaterialTestStatus.failed:
        return 'Failed';
    }
  }

  /// Tile fill in the stat row (yellow / blue / green / red).
  Color get background {
    switch (this) {
      case MaterialTestStatus.pending:
        return const Color(0xFFFEF3C7);
      case MaterialTestStatus.inProgress:
        return const Color(0xFFDBEAFE);
      case MaterialTestStatus.passed:
        return const Color(0xFFD1FAE5);
      case MaterialTestStatus.failed:
        return const Color(0xFFFEE2E2);
    }
  }

  Color get foreground {
    switch (this) {
      case MaterialTestStatus.pending:
        return const Color(0xFFD97706);
      case MaterialTestStatus.inProgress:
        return const Color(0xFF2563EB);
      case MaterialTestStatus.passed:
        return const Color(0xFF16A34A);
      case MaterialTestStatus.failed:
        return const Color(0xFFDC2626);
    }
  }
}

/// The empty state names concrete, soil and steel; the rest is guessed.
enum MaterialTestType { concrete, soil, steel, asphalt, masonry }

extension MaterialTestTypeX on MaterialTestType {
  String get label {
    switch (this) {
      case MaterialTestType.concrete:
        return 'Concrete';
      case MaterialTestType.soil:
        return 'Soil';
      case MaterialTestType.steel:
        return 'Steel';
      case MaterialTestType.asphalt:
        return 'Asphalt';
      case MaterialTestType.masonry:
        return 'Masonry';
    }
  }
}


// ---------------------------------------------------------------------------
// Punch List / T&M / Labor / AI Jobs Analysis
// ---------------------------------------------------------------------------

/// Guessed list — the Trade dropdowns in the references show no options.
enum ProjectTrade {
  general,
  electrical,
  plumbing,
  hvac,
  carpentry,
  masonry,
  concrete,
  drywall,
  painting,
  roofing,
}

extension ProjectTradeX on ProjectTrade {
  String get label {
    switch (this) {
      case ProjectTrade.general:
        return 'General';
      case ProjectTrade.electrical:
        return 'Electrical';
      case ProjectTrade.plumbing:
        return 'Plumbing';
      case ProjectTrade.hvac:
        return 'HVAC';
      case ProjectTrade.carpentry:
        return 'Carpentry';
      case ProjectTrade.masonry:
        return 'Masonry';
      case ProjectTrade.concrete:
        return 'Concrete';
      case ProjectTrade.drywall:
        return 'Drywall';
      case ProjectTrade.painting:
        return 'Painting';
      case ProjectTrade.roofing:
        return 'Roofing';
    }
  }
}

enum PunchPriority { low, medium, high, critical }

extension PunchPriorityX on PunchPriority {
  String get label {
    switch (this) {
      case PunchPriority.low:
        return 'Low';
      case PunchPriority.medium:
        return 'Medium';
      case PunchPriority.high:
        return 'High';
      case PunchPriority.critical:
        return 'Critical';
    }
  }

  Color get foreground {
    switch (this) {
      case PunchPriority.low:
        return const Color(0xFF2563EB);
      case PunchPriority.medium:
        return const Color(0xFFD97706);
      case PunchPriority.high:
        return const Color(0xFFEA580C);
      case PunchPriority.critical:
        return const Color(0xFFDC2626);
    }
  }

  Color get background => foreground.withAlpha(28);
}

enum PunchStatus { open, inProgress, complete }

extension PunchStatusX on PunchStatus {
  String get label {
    switch (this) {
      case PunchStatus.open:
        return 'Open';
      case PunchStatus.inProgress:
        return 'In Progress';
      case PunchStatus.complete:
        return 'Complete';
    }
  }

  Color get foreground {
    switch (this) {
      case PunchStatus.open:
        return const Color(0xFFDC2626);
      case PunchStatus.inProgress:
        return const Color(0xFFD97706);
      case PunchStatus.complete:
        return const Color(0xFF16A34A);
    }
  }

  Color get background => foreground.withAlpha(28);
}

/// Time-entry / labor-hour approval state. The reference only shows
/// "Approved"; Pending and Rejected are the obvious companions.
enum TimeApprovalStatus { pending, approved, rejected }

extension TimeApprovalStatusX on TimeApprovalStatus {
  String get label {
    switch (this) {
      case TimeApprovalStatus.pending:
        return 'Pending';
      case TimeApprovalStatus.approved:
        return 'Approved';
      case TimeApprovalStatus.rejected:
        return 'Rejected';
    }
  }

  /// Approved is the orange-tinted tag in the T&M reference.
  Color get foreground {
    switch (this) {
      case TimeApprovalStatus.pending:
        return const Color(0xFFD97706);
      case TimeApprovalStatus.approved:
        return AppColors.primaryOrange;
      case TimeApprovalStatus.rejected:
        return const Color(0xFFDC2626);
    }
  }

  Color get background => foreground.withAlpha(28);
}

enum LaborSort { dateNewest, dateOldest, hoursHighest, employee }

extension LaborSortX on LaborSort {
  String get label {
    switch (this) {
      case LaborSort.dateNewest:
        return 'Date (Newest)';
      case LaborSort.dateOldest:
        return 'Date (Oldest)';
      case LaborSort.hoursHighest:
        return 'Hours (Highest)';
      case LaborSort.employee:
        return 'Employee';
    }
  }
}

/// Segmented strip under the AI Jobs Analysis stat cards.
enum AiAnalysisSection { overview, safety, photos, history }

extension AiAnalysisSectionX on AiAnalysisSection {
  String get label {
    switch (this) {
      case AiAnalysisSection.overview:
        return 'Overview';
      case AiAnalysisSection.safety:
        return 'Safety Issues';
      case AiAnalysisSection.photos:
        return 'AI Photos';
      case AiAnalysisSection.history:
        return 'History';
    }
  }
}


// ---------------------------------------------------------------------------
// RFIs / Transmittals / Submittals / Closeout / Warranty / Maintenance
// ---------------------------------------------------------------------------

/// Status colour helper shared by the enums below.
Color _tint(Color c) => c.withAlpha(28);

enum RfiStatus { open, answered, closed }

extension RfiStatusX on RfiStatus {
  String get label => const ['Open', 'Answered', 'Closed'][index];
  Color get foreground => const [Color(0xFFD97706), Color(0xFF2563EB), Color(0xFF16A34A)][index];
  Color get background => _tint(foreground);
}

/// Guessed — the Category dropdown only shows "None".
enum RfiCategory { none, design, structural, mep, architectural, other }

extension RfiCategoryX on RfiCategory {
  String get label =>
      const ['None', 'Design', 'Structural', 'MEP', 'Architectural', 'Other'][index];
}

enum TransmittalStatus { draft, sent, acknowledged }

extension TransmittalStatusX on TransmittalStatus {
  String get label => const ['Draft', 'Sent', 'Acknowledged'][index];
  Color get foreground => const [Color(0xFF6B7280), Color(0xFF2563EB), Color(0xFF16A34A)][index];
  Color get background => _tint(foreground);
}

/// Guessed — the Document Type select shows no options.
enum TransmittalDocType { drawings, specifications, shopDrawings, submittal, rfiResponse, other }

extension TransmittalDocTypeX on TransmittalDocType {
  String get label => const [
        'Drawings',
        'Specifications',
        'Shop Drawings',
        'Submittal',
        'RFI Response',
        'Other',
      ][index];
}

enum SubmittalType { contractor, subcontractor, supplier }

extension SubmittalTypeX on SubmittalType {
  String get label => const ['Contractor', 'Subcontractor', 'Supplier'][index];
}

enum SubmittalPhase { preConstruction, construction, closeout }

extension SubmittalPhaseX on SubmittalPhase {
  String get label => const ['Pre-Construction', 'Construction', 'Closeout'][index];
}

enum SubmittalStatus { pending, underReview, approved, rejected }

extension SubmittalStatusX on SubmittalStatus {
  String get label => const ['Pending', 'Under Review', 'Approved', 'Rejected'][index];
  Color get foreground => const [
        Color(0xFFD97706),
        Color(0xFF2563EB),
        Color(0xFF16A34A),
        Color(0xFFDC2626),
      ][index];
  Color get background => _tint(foreground);
}

/// Guessed — the Document Category select shows no options.
const List<String> submittalDocumentCategories = [
  'Shop Drawings',
  'Product Data',
  'Samples',
  'Calculations',
  'Certificates',
  'O&M Manuals',
];

/// The three-way segmented strip on the Submittals tab.
enum SubmittalView { all, pending, overdue }

extension SubmittalViewX on SubmittalView {
  String get label => const ['All', 'Pending', 'Overdue'][index];
}

enum CloseoutSection { checklistItems, closeoutPackage }

extension CloseoutSectionX on CloseoutSection {
  String get label => const ['Checklist Items', 'Closeout Package'][index];
}

enum CloseoutItemStatus { pending, complete }

extension CloseoutItemStatusX on CloseoutItemStatus {
  String get label => const ['Pending', 'Complete'][index];
  Color get foreground => [AppColors.primaryOrange, const Color(0xFF16A34A)][index];
  Color get background => _tint(foreground);
}

enum WarrantyType { defect, warrantyClaim, callback }

extension WarrantyTypeX on WarrantyType {
  String get label => const ['Defect', 'Warranty Claim', 'Callback'][index];
}

enum WarrantyStatus { open, inProgress, resolved }

extension WarrantyStatusX on WarrantyStatus {
  String get label => const ['Open', 'In Progress', 'Resolved'][index];
  Color get foreground => const [Color(0xFFDC2626), Color(0xFFD97706), Color(0xFF16A34A)][index];
  Color get background => _tint(foreground);
}

enum MaintenanceSection { log, schedule, costSummary }

extension MaintenanceSectionX on MaintenanceSection {
  String get label => const ['Log', 'Schedule', 'Cost Summary'][index];
}

enum MaintenanceType { preventive, corrective, inspection }

extension MaintenanceTypeX on MaintenanceType {
  String get label => const ['Preventive', 'Corrective', 'Inspection'][index];
}

/// Colour family of the handover banner on Warranty / Maintenance.
enum HandoverTone { info, warning }


// ---------------------------------------------------------------------------
// Reports / Project Vault / Portal Access
// ---------------------------------------------------------------------------

/// Report Type dropdown on Generate Report ("Weekly Report" is the default
/// shown). Monthly is implied by the Reports Settings screen's Weekly /
/// Monthly counters and auto-generate toggles.
enum ReportType { weekly, monthly }

extension ReportTypeX on ReportType {
  String get label => const ['Weekly Report', 'Monthly Report'][index];
  String get shortLabel => const ['Weekly', 'Monthly'][index];
  Color get foreground => const [Color(0xFF2563EB), Color(0xFFEA580C)][index];
  Color get background => foreground.withAlpha(28);
}

/// The "Report will include:" bullets on Generate Report, in the
/// reference's order.
const List<String> reportIncludes = [
  'Daily notes & field reports',
  'Labor hours & workforce summary',
  'Safety incidents & PPE compliance',
  'Schedule progress & task status',
  'Change orders created in period',
];

/// Guessed — the Project Vault "All Categories" select shows no options.
/// Chosen to match the document-producing tabs of the project.
const List<String> vaultCategories = [
  'Plans & Drawings',
  'Contracts',
  'Permits',
  'Photos & Videos',
  'Reports',
  'RFIs',
  'Submittals',
  'Transmittals',
  'Change Orders',
  'Invoices',
  'Other',
];

/// Client Portal / Subcontractor Portal strip on the Portal Access tab.
enum PortalSubTab { client, subcontractor }

extension PortalSubTabX on PortalSubTab {
  String get label => const ['Client Portal', 'Subcontractor Portal'][index];

  /// App bar title while this strip is selected (the reference shows
  /// "Client Portal" / "Subcontractor Portal").
  String get detailTitle => label;
}

/// Access Type tiles on Invite to Client Portal, in the reference's 2 x 2
/// order.
enum PortalAccessType { ownerRep, gcRep, stakeholder, viewer }

extension PortalAccessTypeX on PortalAccessType {
  String get label => const ['Owner Rep', 'GC Rep', 'Stakeholder', 'Viewer'][index];

  IconData get icon => const [
        Icons.shield_outlined,
        Icons.people_outline,
        Icons.visibility_outlined,
        Icons.public,
      ][index];
}

/// The seven permission switches on Invite to Client Portal, in the
/// reference's order. The first three are on by default.
enum ClientPortalPermission {
  viewProgressUpdates,
  viewPhotosMedia,
  viewSchedule,
  viewDocuments,
  viewChangeOrders,
  viewInvoicesPayments,
  submitRequests,
}

extension ClientPortalPermissionX on ClientPortalPermission {
  String get label => const [
        'View Progress Updates',
        'View Photos & Media',
        'View Schedule',
        'View Documents',
        'View Change Orders',
        'View Invoices & Payments',
        'Submit Requests',
      ][index];

  bool get onByDefault => index < 3;
}

/// The four checkboxes on Invite Subcontractor (all ticked by default).
enum SubcontractorPermission { view, comment, acknowledge, upload }

extension SubcontractorPermissionX on SubcontractorPermission {
  String get label => const ['View', 'Comment', 'Acknowledge', 'Upload'][index];
}

/// Expiration dropdown on Invite Subcontractor ("90 days" is the default
/// shown). The other options are guessed.
enum PortalExpiry { days30, days60, days90, days180, days365 }

extension PortalExpiryX on PortalExpiry {
  int get days => const [30, 60, 90, 180, 365][index];
  String get label => '$days days';
}

/// Lifecycle of a client's portal invitation. Drives the Total Access /
/// Active Users / Pending Invites counters.
enum PortalInviteStatus { pending, active }

extension PortalInviteStatusX on PortalInviteStatus {
  String get label => const ['Invited', 'Active'][index];
  Color get foreground => const [Color(0xFFD97706), Color(0xFF16A34A)][index];
  Color get background => foreground.withAlpha(28);
}

/// Load state of a card that fetches on its own (Reports Settings ->
/// "Scheduled log emails").
enum CardLoadState { loading, error, loaded }
