import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'log_warranty_case_logic.dart';

/// "Log Warranty Case" — one card: Title*, Type + Priority, Description,
/// Location + Assigned To, Responsibility + Reporter Email, Reported Date
/// + Target Resolution, Estimated Cost ($). Create Case is pinned below
/// the scroll area.
class LogWarrantyCaseView extends StatelessWidget {
  final String projectId;
  const LogWarrantyCaseView({super.key, required this.projectId});

  Widget _pair(Widget a, Widget b) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [Expanded(child: a), const SizedBox(width: 10), Expanded(child: b)],
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogWarrantyCaseLogic>(
      init: LogWarrantyCaseLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Log Warranty Case', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create a new warranty case, defect, or callback for this project.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                                heading: 'Title *',
                                hintText: 'e.g., Roof leak at north gap',
                                controller: logic.titleCtrl),
                            projectFieldGap,
                            _pair(
                              Obx(() => ProjectDropdown<WarrantyType>(
                                    label: 'Type',
                                    hint: 'Select',
                                    value: logic.type.value,
                                    options: WarrantyType.values,
                                    labelOf: (t) => t.label,
                                    onChanged: (v) {
                                      if (v != null) logic.type.value = v;
                                    },
                                  )),
                              Obx(() => ProjectDropdown<PunchPriority>(
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
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Description',
                                hintText: 'Describe the issue...',
                                controller: logic.descriptionCtrl,
                                maxLines: 4),
                            projectFieldGap,
                            _pair(
                              CustomTextField(
                                  heading: 'Location',
                                  hintText: 'Room, floor, area...',
                                  controller: logic.locationCtrl),
                              CustomTextField(
                                  heading: 'Assigned To',
                                  hintText: 'Name',
                                  controller: logic.assignedToCtrl),
                            ),
                            projectFieldGap,
                            _pair(
                              CustomTextField(
                                  heading: 'Responsibility',
                                  hintText: 'Party name',
                                  controller: logic.responsibilityCtrl),
                              CustomTextField(
                                  heading: 'Reporter Email',
                                  hintText: 'Enter email',
                                  controller: logic.reporterEmailCtrl,
                                  keyboardType: TextInputType.emailAddress),
                            ),
                            projectFieldGap,
                            _pair(
                              Obx(() => ProjectDateField(
                                    label: 'Reported Date',
                                    hint: 'dd/mm/yyyy',
                                    format: 'dd/MM/yyyy',
                                    value: logic.reportedDate.value,
                                    onChanged: (d) => logic.reportedDate.value = d,
                                  )),
                              Obx(() => ProjectDateField(
                                    label: 'Target Resolution',
                                    hint: 'dd/mm/yyyy',
                                    format: 'dd/MM/yyyy',
                                    value: logic.targetResolution.value,
                                    onChanged: (d) => logic.targetResolution.value = d,
                                  )),
                            ),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Estimated Cost (\$)',
                                hintText: '0.00',
                                controller: logic.costCtrl,
                                keyboardType: TextInputType.number),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Create Case',
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
