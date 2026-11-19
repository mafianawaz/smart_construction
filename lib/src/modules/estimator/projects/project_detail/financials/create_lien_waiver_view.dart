import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/financial_models.dart';
import '../../models/project_enums.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'create_lien_waiver_logic.dart';

/// "Create Lien Waiver" — pushed from the Lien Waivers strip's New Waiver.
/// Project, Linked SOV (optional), Waiver Type, Recipient Name + Company,
/// Through Date + Amount, Notes; Create Waiver is pinned below the scroll
/// area.
class CreateLienWaiverView extends StatelessWidget {
  final String projectId;
  final String projectLabel;
  const CreateLienWaiverView({super.key, required this.projectId, this.projectLabel = ''});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateLienWaiverLogic>(
      init: CreateLienWaiverLogic(projectId, projectLabel),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Create Lien Waiver',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Track a conditional or unconditional lien waiver.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Project',
                                  hint: 'Select project...',
                                  value: logic.project.value,
                                  options: logic.projectOptions,
                                  labelOf: (p) => p,
                                  onChanged: (p) => logic.project.value = p,
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<SovRecord>(
                                  label: 'Linked SOV (optional)',
                                  hint: 'Select SOV...',
                                  value: logic.linkedSov.value,
                                  options: logic.sovs,
                                  labelOf: (s) => '${s.number} · ${s.title}',
                                  onChanged: (s) => logic.linkedSov.value = s,
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<LienWaiverType>(
                                  label: 'Waiver Type',
                                  hint: LienWaiverType.conditionalPartial.label,
                                  value: logic.type.value,
                                  options: LienWaiverType.values,
                                  labelOf: (t) => t.label,
                                  onChanged: (t) => logic.type.value =
                                      t ?? LienWaiverType.conditionalPartial,
                                )),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Recipient Name',
                                    hintText: 'e.g., John Doe',
                                    controller: logic.recipientCtrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Company (optional)',
                                    hintText: 'e.g., ACME Corp',
                                    controller: logic.companyCtrl,
                                  ),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(() => ProjectDateField(
                                        label: 'Through Date',
                                        hint: 'dd/mm/yyyy',
                                        format: 'dd/MM/yyyy',
                                        value: logic.throughDate.value,
                                        onChanged: (d) => logic.throughDate.value = d,
                                      )),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Amount (\$)',
                                    hintText: '0.00',
                                    controller: logic.amountCtrl,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(decimal: true),
                                  ),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Notes (optional)',
                              hintText: 'Additional notes or details...',
                              controller: logic.notesCtrl,
                              maxLines: 4,
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
                        text: 'Create Waiver',
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
