import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'create_change_order_logic.dart';

/// "Create Change Order" — pushed from the Change Orders sub-tab. CO Number
/// + Amount side by side with helper lines, Cost Code, the grey "Scope of
/// Work (for Production Rate Tracking)" box (category -> work type), and
/// Description; Create Change Order is pinned below the scroll area.
class CreateChangeOrderView extends StatelessWidget {
  final String projectId;
  const CreateChangeOrderView({super.key, required this.projectId});

  Widget _helper(String text) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(text, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateChangeOrderLogic>(
      init: CreateChangeOrderLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Create Change Order',
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
                          'Creates a new Potential Change Order (PCO). A CO number will be '
                          'auto-assigned unless you specify one.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextField(
                                        heading: 'CO Number (optional)',
                                        hintText: 'Auto-generated (e.g...',
                                        controller: logic.numberCtrl,
                                      ),
                                      _helper('Leave blank for auto-numbering'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomTextField(
                                        heading: 'Amount (\$)',
                                        hintText: '2500.00',
                                        controller: logic.amountCtrl,
                                        keyboardType: const TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                      ),
                                      _helper('Enter positive for additions'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Cost Code',
                                  hint: 'Select cost code (optional)',
                                  value: logic.costCode.value,
                                  options: logic.costCodes,
                                  labelOf: (c) => c,
                                  onChanged: (c) => logic.costCode.value = c,
                                )),
                            projectFieldGap,
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Scope of Work (for Production Rate Tracking)',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(height: 10),
                                  Obx(() => ProjectDropdown<String>(
                                        label: 'Work Type Category',
                                        hint: 'Select category',
                                        value: logic.workTypeCategory.value,
                                        options: logic.workTypeCategories,
                                        labelOf: (c) => c,
                                        onChanged: logic.selectCategory,
                                      )),
                                  const SizedBox(height: 10),
                                  Obx(() => ProjectDropdown<String>(
                                        // Keyed on the category so the field resets
                                        // when the category changes.
                                        key: ValueKey(logic.workTypeCategory.value),
                                        label: 'Work Type',
                                        hint: 'Select category first',
                                        value: logic.workType.value,
                                        options: logic.workTypeOptions,
                                        labelOf: (w) => w,
                                        onChanged: (w) {
                                          if (logic.workTypeCategory.value != null) {
                                            logic.workType.value = w;
                                          }
                                        },
                                      )),
                                  _helper('Select a work type to enable production rate '
                                      'tracking for this change order.'),
                                ],
                              ),
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Description',
                              hintText: 'Describe the change...',
                              controller: logic.descriptionCtrl,
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
                        text: 'Create Change Order',
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
