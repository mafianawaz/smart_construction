/// The full Estimator → PM/QuickBooks handoff packet for a project.
/// Built from `JobInfoLogic`'s controllers at Save time (same pattern
/// as `BidDraftModel` in the Bids module) — organized into the same 7
/// sections shown in the reference.
class JobInfoModel {
  // Job Overview
  final String gcNameAndContact;
  final String gcContactPerson;
  final String gcPhone;
  final String gcEmail;
  final String accessDetails;
  final String scopeOfSummary;

  // Communication Protocol
  final String gcContactMethod;
  final String projectManager;
  final String superintendent;
  final String officeAdmin;
  final String safetyContact;

  // Estimate Snapshots
  final String contractValue;
  final String markupPercent;
  final String duration;
  final DateTime? bidDate;
  final DateTime? awardDate;
  final String manpower;
  final DateTime? startDate;
  final DateTime? completionDate;
  final String alternatives;

  // Materials & Supply Chain
  final String concreteSupplier;
  final String mixInfo;
  final String rebarVendor;
  final String submittalStatus;
  final String formingMaterialPlan;
  final String curingSpecs;
  final String specialItems;
  final String leadTimeRisks;

  // Contract & Documentation
  final bool subcontractExecuted;
  final bool bondRequired;
  final bool prevailingWage;
  final bool scheduleOfValuesReady;
  final DateTime? insuranceCertsDate;
  final String permits;
  final String retentionPercent;
  final String paymentTerms;
  final String drawSchedule;

  // Field Work Details
  final String layoutAndSurveyBy;
  final String benchmarkInfo;
  final String accessZones;
  final String workHours;
  final String safetyOrientation;
  final String inspectionNeeds;

  // Project Notes & Risk Items
  final String coordinationIssues;
  final String weatherRisks;
  final String soilCondition;
  final String estimatorsNotes;

  const JobInfoModel({
    this.gcNameAndContact = '',
    this.gcContactPerson = '',
    this.gcPhone = '',
    this.gcEmail = '',
    this.accessDetails = '',
    this.scopeOfSummary = '',
    this.gcContactMethod = '',
    this.projectManager = '',
    this.superintendent = '',
    this.officeAdmin = '',
    this.safetyContact = '',
    this.contractValue = '0.00',
    this.markupPercent = '25',
    this.duration = '',
    this.bidDate,
    this.awardDate,
    this.manpower = '',
    this.startDate,
    this.completionDate,
    this.alternatives = '',
    this.concreteSupplier = '',
    this.mixInfo = '',
    this.rebarVendor = '',
    this.submittalStatus = '',
    this.formingMaterialPlan = '',
    this.curingSpecs = '',
    this.specialItems = '',
    this.leadTimeRisks = '',
    this.subcontractExecuted = false,
    this.bondRequired = false,
    this.prevailingWage = false,
    this.scheduleOfValuesReady = false,
    this.insuranceCertsDate,
    this.permits = '',
    this.retentionPercent = '',
    this.paymentTerms = '',
    this.drawSchedule = '',
    this.layoutAndSurveyBy = '',
    this.benchmarkInfo = '',
    this.accessZones = '',
    this.workHours = '',
    this.safetyOrientation = '',
    this.inspectionNeeds = '',
    this.coordinationIssues = '',
    this.weatherRisks = '',
    this.soilCondition = '',
    this.estimatorsNotes = '',
  });
}
