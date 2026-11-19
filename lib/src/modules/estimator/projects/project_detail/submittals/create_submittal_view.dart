import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'create_submittal_logic.dart';

/// "Create Submittal" — one card: Subject*, Description, Submittal Type +
/// Phase, Spec Section + Document Category, Date Required. Create
/// Submittal is pinned below the scroll area.
class CreateSubmittalView extends StatelessWidget {
  final String projectId;
  const CreateSubmittalView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateSubmittalLogic>(
      init: CreateSubmittalLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
              title: 'Create Submittal', showBackButton: true, centerTitle: true),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(15, 12, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Create a new submittal for review and approval.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                                heading: 'Subject *',
                                hintText: 'Brief submittal subject...',
                                controller: logic.subjectCtrl),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Description',
                                hintText: 'Optional description...',
                                controller: logic.descriptionCtrl,
                                maxLines: 3),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<SubmittalType>(
                                  label: 'Submittal Type',
                                  hint: 'Select',
                                  value: logic.type.value,
                                  options: SubmittalType.values,
                                  labelOf: (t) => t.label,
                                  onChanged: (v) {
                                    if (v != null) logic.type.value = v;
                                  },
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<SubmittalPhase>(
                                  label: 'Phase',
                                  hint: 'Select',
                                  value: logic.phase.value,
                                  options: SubmittalPhase.values,
                                  labelOf: (p) => p.label,
                                  onChanged: (v) {
                                    if (v != null) logic.phase.value = v;
                                  },
                                )),
                            projectFieldGap,
                            CustomTextField(
                                heading: 'Spec Section',
                                hintText: 'e.g., 03 30 00',
                                controller: logic.specSectionCtrl),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Document Category',
                                  hint: 'Select category...',
                                  value: logic.category.value,
                                  options: submittalDocumentCategories,
                                  labelOf: (c) => c,
                                  onChanged: (v) => logic.category.value = v,
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDateField(
                                  label: 'Date Required',
                                  hint: 'dd/mm/yyyy',
                                  format: 'dd/MM/yyyy',
                                  value: logic.dateRequired.value,
                                  onChanged: (d) => logic.dateRequired.value = d,
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
                        text: 'Create Submittal',
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
