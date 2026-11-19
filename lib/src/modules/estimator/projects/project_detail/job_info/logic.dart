import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/job_info_model.dart';

/// Owns the Job Information handoff form for one project. Put with
/// `tag: project.id` alongside `ProjectDetailLogic` so it survives tab
/// switches within the same Project Detail screen but not across
/// projects.
///
/// Fields aren't kept on a mutable model while editing — like
/// `CreateBidLogic`, each field is its own controller and a
/// [JobInfoModel] is only assembled at [saveChanges] time.
class JobInfoLogic extends GetxController {
  final String projectId;
  JobInfoLogic(this.projectId);

  final isSaving = false.obs;

  // Job Overview
  final gcNameAndContactCtrl = TextEditingController();
  final gcContactPersonCtrl = TextEditingController();
  final gcPhoneCtrl = TextEditingController();
  final gcEmailCtrl = TextEditingController();
  final accessDetailsCtrl = TextEditingController();
  final scopeOfSummaryCtrl = TextEditingController();

  // Communication Protocol
  final gcContactMethodCtrl = TextEditingController();
  final projectManagerCtrl = TextEditingController();
  final superintendentCtrl = TextEditingController();
  final officeAdminCtrl = TextEditingController();
  final safetyContactCtrl = TextEditingController();

  // Estimate Snapshots
  final contractValueCtrl = TextEditingController();
  final markupPercentCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final Rx<DateTime?> bidDate = Rx<DateTime?>(null);
  final Rx<DateTime?> awardDate = Rx<DateTime?>(null);
  final manpowerCtrl = TextEditingController();
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> completionDate = Rx<DateTime?>(null);
  final alternativesCtrl = TextEditingController();

  // Materials & Supply Chain
  final concreteSupplierCtrl = TextEditingController();
  final mixInfoCtrl = TextEditingController();
  final rebarVendorCtrl = TextEditingController();
  final submittalStatusCtrl = TextEditingController();
  final formingMaterialPlanCtrl = TextEditingController();
  final curingSpecsCtrl = TextEditingController();
  final specialItemsCtrl = TextEditingController();
  final leadTimeRisksCtrl = TextEditingController();

  // Contract & Documentation
  final subcontractExecuted = false.obs;
  final bondRequired = false.obs;
  final prevailingWage = false.obs;
  final scheduleOfValuesReady = false.obs;
  final Rx<DateTime?> insuranceCertsDate = Rx<DateTime?>(null);
  final permitsCtrl = TextEditingController();
  final retentionPercentCtrl = TextEditingController();
  final paymentTermsCtrl = TextEditingController();
  final drawScheduleCtrl = TextEditingController();

  // Field Work Details
  final layoutAndSurveyByCtrl = TextEditingController();
  final benchmarkInfoCtrl = TextEditingController();
  final accessZonesCtrl = TextEditingController();
  final workHoursCtrl = TextEditingController();
  final safetyOrientationCtrl = TextEditingController();
  final inspectionNeedsCtrl = TextEditingController();

  // Project Notes & Risk Items
  final coordinationIssuesCtrl = TextEditingController();
  final weatherRisksCtrl = TextEditingController();
  final soilConditionCtrl = TextEditingController();
  final estimatorsNotesCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/job-info
    final info = ProjectsMockData.jobInfo(projectId);
    gcNameAndContactCtrl.text = info.gcNameAndContact;
    gcContactPersonCtrl.text = info.gcContactPerson;
    gcPhoneCtrl.text = info.gcPhone;
    gcEmailCtrl.text = info.gcEmail;
    accessDetailsCtrl.text = info.accessDetails;
    scopeOfSummaryCtrl.text = info.scopeOfSummary;
    gcContactMethodCtrl.text = info.gcContactMethod;
    projectManagerCtrl.text = info.projectManager;
    superintendentCtrl.text = info.superintendent;
    officeAdminCtrl.text = info.officeAdmin;
    safetyContactCtrl.text = info.safetyContact;
    contractValueCtrl.text = info.contractValue;
    markupPercentCtrl.text = info.markupPercent;
    durationCtrl.text = info.duration;
    bidDate.value = info.bidDate;
    awardDate.value = info.awardDate;
    manpowerCtrl.text = info.manpower;
    startDate.value = info.startDate;
    completionDate.value = info.completionDate;
    alternativesCtrl.text = info.alternatives;
    concreteSupplierCtrl.text = info.concreteSupplier;
    mixInfoCtrl.text = info.mixInfo;
    rebarVendorCtrl.text = info.rebarVendor;
    submittalStatusCtrl.text = info.submittalStatus;
    formingMaterialPlanCtrl.text = info.formingMaterialPlan;
    curingSpecsCtrl.text = info.curingSpecs;
    specialItemsCtrl.text = info.specialItems;
    leadTimeRisksCtrl.text = info.leadTimeRisks;
    subcontractExecuted.value = info.subcontractExecuted;
    bondRequired.value = info.bondRequired;
    prevailingWage.value = info.prevailingWage;
    scheduleOfValuesReady.value = info.scheduleOfValuesReady;
    insuranceCertsDate.value = info.insuranceCertsDate;
    permitsCtrl.text = info.permits;
    retentionPercentCtrl.text = info.retentionPercent;
    paymentTermsCtrl.text = info.paymentTerms;
    drawScheduleCtrl.text = info.drawSchedule;
    layoutAndSurveyByCtrl.text = info.layoutAndSurveyBy;
    benchmarkInfoCtrl.text = info.benchmarkInfo;
    accessZonesCtrl.text = info.accessZones;
    workHoursCtrl.text = info.workHours;
    safetyOrientationCtrl.text = info.safetyOrientation;
    inspectionNeedsCtrl.text = info.inspectionNeeds;
    coordinationIssuesCtrl.text = info.coordinationIssues;
    weatherRisksCtrl.text = info.weatherRisks;
    soilConditionCtrl.text = info.soilCondition;
    estimatorsNotesCtrl.text = info.estimatorsNotes;
  }

  JobInfoModel _buildModel() => JobInfoModel(
        gcNameAndContact: gcNameAndContactCtrl.text.trim(),
        gcContactPerson: gcContactPersonCtrl.text.trim(),
        gcPhone: gcPhoneCtrl.text.trim(),
        gcEmail: gcEmailCtrl.text.trim(),
        accessDetails: accessDetailsCtrl.text.trim(),
        scopeOfSummary: scopeOfSummaryCtrl.text.trim(),
        gcContactMethod: gcContactMethodCtrl.text.trim(),
        projectManager: projectManagerCtrl.text.trim(),
        superintendent: superintendentCtrl.text.trim(),
        officeAdmin: officeAdminCtrl.text.trim(),
        safetyContact: safetyContactCtrl.text.trim(),
        contractValue: contractValueCtrl.text.trim(),
        markupPercent: markupPercentCtrl.text.trim(),
        duration: durationCtrl.text.trim(),
        bidDate: bidDate.value,
        awardDate: awardDate.value,
        manpower: manpowerCtrl.text.trim(),
        startDate: startDate.value,
        completionDate: completionDate.value,
        alternatives: alternativesCtrl.text.trim(),
        concreteSupplier: concreteSupplierCtrl.text.trim(),
        mixInfo: mixInfoCtrl.text.trim(),
        rebarVendor: rebarVendorCtrl.text.trim(),
        submittalStatus: submittalStatusCtrl.text.trim(),
        formingMaterialPlan: formingMaterialPlanCtrl.text.trim(),
        curingSpecs: curingSpecsCtrl.text.trim(),
        specialItems: specialItemsCtrl.text.trim(),
        leadTimeRisks: leadTimeRisksCtrl.text.trim(),
        subcontractExecuted: subcontractExecuted.value,
        bondRequired: bondRequired.value,
        prevailingWage: prevailingWage.value,
        scheduleOfValuesReady: scheduleOfValuesReady.value,
        insuranceCertsDate: insuranceCertsDate.value,
        permits: permitsCtrl.text.trim(),
        retentionPercent: retentionPercentCtrl.text.trim(),
        paymentTerms: paymentTermsCtrl.text.trim(),
        drawSchedule: drawScheduleCtrl.text.trim(),
        layoutAndSurveyBy: layoutAndSurveyByCtrl.text.trim(),
        benchmarkInfo: benchmarkInfoCtrl.text.trim(),
        accessZones: accessZonesCtrl.text.trim(),
        workHours: workHoursCtrl.text.trim(),
        safetyOrientation: safetyOrientationCtrl.text.trim(),
        inspectionNeeds: inspectionNeedsCtrl.text.trim(),
        coordinationIssues: coordinationIssuesCtrl.text.trim(),
        weatherRisks: weatherRisksCtrl.text.trim(),
        soilCondition: soilConditionCtrl.text.trim(),
        estimatorsNotes: estimatorsNotesCtrl.text.trim(),
      );

  // API: PUT /projects/{id}/job-info
  Future<void> saveChanges() async {
    if (isSaving.value) return;
    isSaving.value = true;
    try {
      await ProjectsMockData.saveJobInfo(projectId, _buildModel());
      Get.snackbar('Saved', 'Job information updated.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      gcNameAndContactCtrl,
      gcContactPersonCtrl,
      gcPhoneCtrl,
      gcEmailCtrl,
      accessDetailsCtrl,
      scopeOfSummaryCtrl,
      gcContactMethodCtrl,
      projectManagerCtrl,
      superintendentCtrl,
      officeAdminCtrl,
      safetyContactCtrl,
      contractValueCtrl,
      markupPercentCtrl,
      durationCtrl,
      manpowerCtrl,
      alternativesCtrl,
      concreteSupplierCtrl,
      mixInfoCtrl,
      rebarVendorCtrl,
      submittalStatusCtrl,
      formingMaterialPlanCtrl,
      curingSpecsCtrl,
      specialItemsCtrl,
      leadTimeRisksCtrl,
      permitsCtrl,
      retentionPercentCtrl,
      paymentTermsCtrl,
      drawScheduleCtrl,
      layoutAndSurveyByCtrl,
      benchmarkInfoCtrl,
      accessZonesCtrl,
      workHoursCtrl,
      safetyOrientationCtrl,
      inspectionNeedsCtrl,
      coordinationIssuesCtrl,
      weatherRisksCtrl,
      soilConditionCtrl,
      estimatorsNotesCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
