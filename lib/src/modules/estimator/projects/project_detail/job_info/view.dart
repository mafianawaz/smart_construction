import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import 'logic.dart';
import 'widgets/collapsible_section.dart';
import 'widgets/job_info_fields.dart';

/// Job Info tab — the estimator handoff packet, as 7 collapsible
/// sections ending in a full-width Save Changes button.
class JobInfoView extends StatelessWidget {
  final String projectId;
  const JobInfoView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobInfoLogic>(
      init: JobInfoLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CollapsibleSection(
                        title: 'Job Overview',
                        subtitle: 'GC info, access details, and scope summary',
                        children: [
                          CustomTextField(
                              heading: 'Gc Name & Contact',
                              hintText: 'General Contractor Company',
                              controller: logic.gcNameAndContactCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Gc Contact Person',
                              hintText: 'John Smith',
                              controller: logic.gcContactPersonCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Gc Phone',
                              hintText: '(000) 123-4567',
                              controller: logic.gcPhoneCtrl,
                              keyboardType: TextInputType.phone),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Gc Email',
                              hintText: 'john@gc.com',
                              controller: logic.gcEmailCtrl,
                              keyboardType: TextInputType.emailAddress),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Access Details',
                              hintText: 'Gate codes, restricted hours, security requirements...',
                              controller: logic.accessDetailsCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Scope Of Summary',
                              hintText: "Summary of your company's scope on this project...",
                              controller: logic.scopeOfSummaryCtrl,
                              maxLines: 3),
                        ],
                      ),
                      CollapsibleSection(
                        title: 'Communication Protocol',
                        subtitle: 'Project contacts and communication methods',
                        children: [
                          CustomTextField(
                              heading: 'Gc Contacts Method',
                              hintText: 'Preferred contact method',
                              controller: logic.gcContactMethodCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Project Manager',
                              hintText: 'Company Project Manager',
                              controller: logic.projectManagerCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Superintendent',
                              hintText: 'Company Superintendent',
                              controller: logic.superintendentCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Office Admin',
                              hintText: 'Office Admin contact',
                              controller: logic.officeAdminCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Safety Contact',
                              hintText: 'Safety officer contact',
                              controller: logic.safetyContactCtrl),
                        ],
                      ),
                      CollapsibleSection(
                        title: 'Estimate Snapshots',
                        subtitle: 'Contract value, dates, duration, and manpower',
                        children: [
                          CustomTextField(
                              heading: 'Contract Value',
                              hintText: '0.00',
                              controller: logic.contractValueCtrl,
                              keyboardType: TextInputType.number),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Markup (%)',
                              hintText: '25',
                              controller: logic.markupPercentCtrl,
                              keyboardType: TextInputType.number),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Duration',
                              hintText: 'e.g., 6 months',
                              controller: logic.durationCtrl),
                          jobInfoFieldGap,
                          Obx(() => JobInfoDateField(
                                label: 'Bid Date',
                                value: logic.bidDate.value,
                                onChanged: (d) => logic.bidDate.value = d,
                              )),
                          jobInfoFieldGap,
                          Obx(() => JobInfoDateField(
                                label: 'Award Date',
                                value: logic.awardDate.value,
                                onChanged: (d) => logic.awardDate.value = d,
                              )),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Manpower',
                              hintText: 'e.g., 4-6 crew',
                              controller: logic.manpowerCtrl),
                          jobInfoFieldGap,
                          Obx(() => JobInfoDateField(
                                label: 'Start Date',
                                value: logic.startDate.value,
                                onChanged: (d) => logic.startDate.value = d,
                              )),
                          jobInfoFieldGap,
                          Obx(() => JobInfoDateField(
                                label: 'Completion Date',
                                value: logic.completionDate.value,
                                onChanged: (d) => logic.completionDate.value = d,
                              )),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Alternatives',
                              hintText: 'List any alternate scope or pricing...',
                              controller: logic.alternativesCtrl,
                              maxLines: 3),
                        ],
                      ),
                      CollapsibleSection(
                        title: 'Materials & Supply Chain',
                        subtitle: 'Suppliers, materials, lead times, and submittals',
                        children: [
                          CustomTextField(
                              heading: 'Concrete Supplier',
                              hintText: 'Supplier name',
                              controller: logic.concreteSupplierCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Mix Info',
                              hintText: 'Concrete mix specifications',
                              controller: logic.mixInfoCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Rebar Vendor',
                              hintText: 'Vendor name',
                              controller: logic.rebarVendorCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Submittal Status',
                              hintText: 'Status of submittals',
                              controller: logic.submittalStatusCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Forming Material Plan',
                              hintText: 'Forming approach and materials',
                              controller: logic.formingMaterialPlanCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Curing Specs',
                              hintText: 'Curing requirements',
                              controller: logic.curingSpecsCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Special Items',
                              hintText: 'Any special materials or equipment needed',
                              controller: logic.specialItemsCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Lead Time Risks',
                              hintText: 'Materials with long lead times or availability concerns',
                              controller: logic.leadTimeRisksCtrl,
                              maxLines: 3),
                        ],
                      ),
                      CollapsibleSection(
                        title: 'Contract & Documentation',
                        subtitle: 'Subcontract, insurance, bonds, permits, and payment terms',
                        children: [
                          Obx(() => JobInfoCheckboxRow(
                                label: 'Subcontract Executed?',
                                value: logic.subcontractExecuted.value,
                                onChanged: (v) => logic.subcontractExecuted.value = v,
                              )),
                          Obx(() => JobInfoCheckboxRow(
                                label: 'Bond Required?',
                                value: logic.bondRequired.value,
                                onChanged: (v) => logic.bondRequired.value = v,
                              )),
                          Obx(() => JobInfoCheckboxRow(
                                label: 'Prevailing Wage?',
                                value: logic.prevailingWage.value,
                                onChanged: (v) => logic.prevailingWage.value = v,
                              )),
                          Obx(() => JobInfoCheckboxRow(
                                label: 'Schedule of Values Ready?',
                                value: logic.scheduleOfValuesReady.value,
                                onChanged: (v) => logic.scheduleOfValuesReady.value = v,
                              )),
                          jobInfoFieldGap,
                          Obx(() => JobInfoDateField(
                                label: 'Insurance Certs',
                                value: logic.insuranceCertsDate.value,
                                onChanged: (d) => logic.insuranceCertsDate.value = d,
                              )),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Permits',
                              hintText: 'Required permits and status',
                              controller: logic.permitsCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Retention %',
                              hintText: 'e.g., 10',
                              controller: logic.retentionPercentCtrl,
                              keyboardType: TextInputType.number),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Payment Terms',
                              hintText: 'e.g., Net 30',
                              controller: logic.paymentTermsCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Draw Schedule',
                              hintText: 'Billing schedule and draw dates..',
                              controller: logic.drawScheduleCtrl,
                              maxLines: 3),
                        ],
                      ),
                      CollapsibleSection(
                        title: 'Field Work Details',
                        subtitle: 'Layout, benchmarks, work hours, safety, and inspections',
                        children: [
                          CustomTextField(
                              heading: 'Layout & Survey By',
                              hintText: 'Who provides layout?',
                              controller: logic.layoutAndSurveyByCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Benchmark Info',
                              hintText: 'Benchmark location and elevation',
                              controller: logic.benchmarkInfoCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Access Zones',
                              hintText: 'Staging areas and access points',
                              controller: logic.accessZonesCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Work Hours',
                              hintText: 'e.g., 7am-3:30pm M-F',
                              controller: logic.workHoursCtrl),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Safety Orientation',
                              hintText: 'Safety requirements and orientation details',
                              controller: logic.safetyOrientationCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Inspection Needs',
                              hintText: 'Required inspections and timing',
                              controller: logic.inspectionNeedsCtrl,
                              maxLines: 3),
                        ],
                      ),
                      CollapsibleSection(
                        title: 'Project Notes & Risk Items',
                        subtitle: 'Coordination issues, weather risks, soil conditions, and notes',
                        children: [
                          CustomTextField(
                              heading: 'Coordination Issues',
                              hintText: 'Known coordination challenges',
                              controller: logic.coordinationIssuesCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Weather Risks',
                              hintText: 'Seasonal or weather concerns',
                              controller: logic.weatherRisksCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Soil Condition',
                              hintText: 'Known soil conditions or concerns',
                              controller: logic.soilConditionCtrl,
                              maxLines: 3),
                          jobInfoFieldGap,
                          CustomTextField(
                              heading: 'Estimators Notes',
                              hintText: 'Additional notes from the estimator',
                              controller: logic.estimatorsNotesCtrl,
                              maxLines: 3),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Obx(()=> CustomButton(
                text: 'Save Changes',
                onPressed: logic.isSaving.value ? null : logic.saveChanges,
              )),
            ],
          ),
        );
      },
    );
  }
}
