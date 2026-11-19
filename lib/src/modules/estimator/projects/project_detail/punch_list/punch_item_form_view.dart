import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'punch_item_form_logic.dart';

/// "Add Punch Item" / "Edit Punch Item" — one form for both, pushed from
/// the Punch List. Card 1: Title*, Description, Location, Trade + Priority
/// side by side. Card 2: Assign To (Team Member), Assignee Name (Manual),
/// Assignee Email. Card 3: Due Date. Save is pinned below the scroll area.
class PunchItemFormView extends StatelessWidget {
  final String projectId;
  final PunchItemModel? existing;
  const PunchItemFormView({super.key, required this.projectId, this.existing});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PunchItemFormLogic>(
      init: PunchItemFormLogic(projectId, existing: existing),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: logic.isEditing ? 'Edit Punch Item' : 'Add Punch Item',
            showBackButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      children: [
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                                heading: 'Title *',
                                hintText: 'Punch item title',
                                controller: logic.titleCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Description',
                                hintText: 'Describe the issue...',
                                controller: logic.descriptionCtrl,
                                maxLines: 3),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Location',
                                hintText: 'e.g., Suite 200, North Wing',
                                controller: logic.locationCtrl),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(() => ProjectDropdown<ProjectTrade>(
                                        label: 'Trade',
                                        hint: 'Select',
                                        value: logic.trade.value,
                                        options: ProjectTrade.values,
                                        labelOf: (t) => t.label,
                                        onChanged: (v) {
                                          if (v != null) logic.trade.value = v;
                                        },
                                      )),
                                ),
                                const SizedBox(width: 10),
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
                              ],
                            ),
                          ],
                        ),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Assign To (Team Member)',
                                  hint: 'Select a team member',
                                  value: logic.teamMember.value,
                                  options: logic.teamMemberOptions,
                                  labelOf: (m) => m,
                                  onChanged: logic.onTeamMemberChanged,
                                )),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Assignee Name (Manual)',
                                hintText: 'Enter name manually',
                                controller: logic.assigneeNameCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Assignee Email',
                                hintText: 'Enter email manually',
                                controller: logic.assigneeEmailCtrl,
                                keyboardType: TextInputType.emailAddress),
                          ],
                        ),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDateField(
                                  label: 'Due Date',
                                  hint: 'dd/mm/yyyy',
                                  format: 'dd/MM/yyyy',
                                  value: logic.dueDate.value,
                                  onChanged: (d) => logic.dueDate.value = d,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: logic.isEditing ? 'Save Changes' : 'Add Item',
                        onPressed: logic.isSaving.value
                            ? null
                            : () async {
                                if (await logic.save()) Get.back();
                              },
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
