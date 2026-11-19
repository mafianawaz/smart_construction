import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../job_info/widgets/job_info_fields.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'create_rfi_logic.dart';

/// "Create RFI" — pushed from the RFIs tab. One card: Subject*, Question*,
/// Priority + Category, Assign To, Subcontractor, Drawing + Spec
/// reference, Date Required, Impact Description and the Cost Impact /
/// Schedule Impact checkboxes. Create RFI is pinned below the scroll area.
class CreateRfiView extends StatelessWidget {
  final String projectId;
  const CreateRfiView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateRfiLogic>(
      init: CreateRfiLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(title: 'Create RFI', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Submit a request for information to the design team.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                                heading: 'Subject *',
                                hintText: 'Brief description of the issue',
                                controller: logic.subjectCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Question *',
                                hintText: 'Detailed question requiring clarification...',
                                controller: logic.questionCtrl,
                                maxLines: 3),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(() => ProjectDropdown<PunchPriority>(
                                        label: 'Priority',
                                        hint: 'Select',
                                        value: logic.priority.value,
                                        options: PunchPriority.values,
                                        labelOf: (p) => p.label,
                                        onChanged: (v) {
                                          if (v != null) logic.priority.value = v;
                                        },
                                      )),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Obx(() => ProjectDropdown<RfiCategory>(
                                        label: 'Category',
                                        hint: 'Select',
                                        value: logic.category.value,
                                        options: RfiCategory.values,
                                        labelOf: (c) => c.label,
                                        onChanged: (v) {
                                          if (v != null) logic.category.value = v;
                                        },
                                      )),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Assign To',
                                  hint: 'Unassigned',
                                  value: logic.assignTo.value,
                                  options: logic.assignOptions,
                                  labelOf: (m) => m,
                                  onChanged: (v) {
                                    if (v != null) logic.assignTo.value = v;
                                  },
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Subcontractor',
                                  hint: 'None',
                                  value: logic.subcontractor.value,
                                  options: logic.subcontractorOptions,
                                  labelOf: (m) => m,
                                  onChanged: (v) {
                                    if (v != null) logic.subcontractor.value = v;
                                  },
                                )),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                      heading: 'Drawing Reference',
                                      hintText: 'e.g., Sheet A-201',
                                      controller: logic.drawingCtrl),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                      heading: 'Spec Reference',
                                      hintText: 'e.g., Section 03 30 00',
                                      controller: logic.specCtrl),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            Obx(() => ProjectDateField(
                                  label: 'Date Required',
                                  hint: 'dd/mm/yyyy',
                                  format: 'dd/MM/yyyy',
                                  value: logic.dateRequired.value,
                                  onChanged: (d) => logic.dateRequired.value = d,
                                )),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Impact Description',
                                hintText: 'Describe the impact if not resolved...',
                                controller: logic.impactCtrl,
                                maxLines: 3),
                            projectFieldGap,
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(() => JobInfoCheckboxRow(
                                        label: 'Cost Impact',
                                        value: logic.costImpact.value,
                                        onChanged: (v) => logic.costImpact.value = v,
                                      )),
                                ),
                                Expanded(
                                  child: Obx(() => JobInfoCheckboxRow(
                                        label: 'Schedule Impact',
                                        value: logic.scheduleImpact.value,
                                        onChanged: (v) => logic.scheduleImpact.value = v,
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Create RFI',
                        onPressed: logic.isCreating.value ? null : logic.create,
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
