import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/project_enums.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'add_line_item_logic.dart';

/// "Add Manual Line Items" — pushed from the Estimate tab. Three cards
/// (core fields / Labour / cost allocations + notes) with the Add Line
/// Items button pinned below, as in the reference.
class AddLineItemView extends StatelessWidget {
  final String projectId;
  const AddLineItemView({super.key, required this.projectId});

  Widget _money(String heading, TextEditingController c) => CustomTextField(
        heading: heading,
        hintText: '0',
        controller: c,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      );

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddLineItemLogic>(
      init: AddLineItemLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'Add Manual Line Items',
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
                          'Create a custom estimate line item with detailed cost breakdown',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            CustomTextField(
                              heading: 'Description',
                              hintText: 'e.g., Foundation excavation',
                              controller: logic.descriptionCtrl,
                            ),
                            projectFieldGap,
                            Obx(() => ProjectDropdown<EstimateLineCategory>(
                                  label: 'Category',
                                  hint: 'Select a category',
                                  value: logic.category.value,
                                  options: EstimateLineCategory.values,
                                  labelOf: (c) => c.label,
                                  onChanged: (c) => logic.category.value = c,
                                )),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Unit',
                              hintText: 'e.g., CY, SF, LF',
                              controller: logic.unitCtrl,
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Quantity',
                              hintText: '0',
                              controller: logic.quantityCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                            ),
                          ],
                        ),
                        ProjectFormCard(
                          title: 'Labour',
                          children: [
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Labor Classification (from Cost Rates)',
                                  hint: manualLaborClassification,
                                  value: logic.laborClassification.value,
                                  options: logic.laborClassifications,
                                  labelOf: (s) => s,
                                  onChanged: (s) =>
                                      logic.laborClassification.value = s ?? manualLaborClassification,
                                )),
                            projectFieldGap,
                            _money('Labor hours', logic.laborHoursCtrl),
                            projectFieldGap,
                            _money('Labor Cost', logic.laborCostCtrl),
                          ],
                        ),
                        ProjectFormCard(
                          children: [
                            _money('Equipment Cost', logic.equipmentCtrl),
                            projectFieldGap,
                            _money('Consumables Cost', logic.consumablesCtrl),
                            projectFieldGap,
                            _money('Subcontract Cost', logic.subcontractCtrl),
                            projectFieldGap,
                            _money('Overhead Allocation', logic.overheadCtrl),
                            projectFieldGap,
                            _money('Profit Allocation', logic.profitCtrl),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Notes (optional)',
                              hintText: 'Additional notes or details...',
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
                        text: 'Add Line Items',
                        onPressed: logic.isSaving.value ? null : logic.addLineItem,
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
