import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/scope_models.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'record_usage_logic.dart';

/// "Record Materials Usage" — pushed from the Materials tab's "Add
/// Usage". The Record Usage button is pinned below the scroll area, as in
/// the reference.
class RecordUsageView extends StatelessWidget {
  final String projectId;
  const RecordUsageView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecordUsageLogic>(
      init: RecordUsageLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Record Materials Usage',
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
                          'Enter the materials used today. This will be deducted from the budget.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDropdown<ScopeItemModel>(
                                  label: 'Scope Item',
                                  hint: 'Select scope item',
                                  value: logic.scopeItem.value,
                                  options: logic.scopeItems,
                                  labelOf: (i) => i.name,
                                  onChanged: logic.selectScopeItem,
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDateField(
                                  label: 'Date',
                                  value: logic.date.value,
                                  onChanged: (d) => logic.date.value = d,
                                )),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Description',
                              hintText: 'e.g., Concrete pour for section A',
                              controller: logic.descriptionCtrl,
                            ),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Quantity',
                                    hintText: '0',
                                    controller: logic.quantityCtrl,
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Unit',
                                    hintText: 'SF, CY, etc.',
                                    controller: logic.unitCtrl,
                                  ),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Unit Cost (\$)',
                              hintText: '0.00',
                              controller: logic.unitCostCtrl,
                              keyboardType: TextInputType.number,
                            ),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Vendor (Optional)',
                                    hintText: 'Vendor name',
                                    controller: logic.vendorCtrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Receipt # (Optional)',
                                    hintText: 'Receipt number',
                                    controller: logic.receiptCtrl,
                                  ),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Notes (Optional)',
                              hintText: 'Any additional notes...',
                              controller: logic.notesCtrl,
                              maxLines: 3,
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
                        text: 'Record Usage',
                        onPressed: logic.isSaving.value ? null : logic.recordUsage,
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
