import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../widgets/project_action_button.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_dropdown.dart';
import '../widgets/project_form_card.dart';
import 'new_purchase_order_logic.dart';

/// "New Purchase Order" — pushed from the Orders section's New PO button.
/// Vendor / Needed By / Terms + Delivery Address / Notes, then a repeatable
/// Line Items list; Create PO is pinned below the scroll area.
class NewPurchaseOrderView extends StatelessWidget {
  final String projectId;
  const NewPurchaseOrderView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewPurchaseOrderLogic>(
      init: NewPurchaseOrderLogic(projectId),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'New Purchase Order',
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
                          'Create a purchase order with line items.',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 12),
                        ProjectFormCard(
                          children: [
                            Obx(() => ProjectDropdown<String>(
                                  label: 'Vendor',
                                  hint: 'Select vendor...',
                                  value: logic.vendor.value,
                                  options: logic.vendors,
                                  labelOf: (v) => v,
                                  onChanged: (v) => logic.vendor.value = v,
                                )),
                            projectFieldGap,
                            Obx(() => ProjectDateField(
                                  label: 'Needed By',
                                  hint: 'dd/mm/yyyy',
                                  format: 'dd/MM/yyyy',
                                  value: logic.neededBy.value,
                                  onChanged: (d) => logic.neededBy.value = d,
                                )),
                            projectFieldGap,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Terms',
                                    hintText: 'Net 30, COD...',
                                    controller: logic.termsCtrl,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: CustomTextField(
                                    heading: 'Delivery Address',
                                    hintText: 'Address...',
                                    controller: logic.addressCtrl,
                                  ),
                                ),
                              ],
                            ),
                            projectFieldGap,
                            CustomTextField(
                              heading: 'Notes',
                              hintText: 'Enter any additional notes...',
                              controller: logic.notesCtrl,
                              maxLines: 4,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: Text('Line Items',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            ),
                            ProjectActionButton(
                              label: 'Add Item',
                              icon: Icons.add,
                              filled: false,
                              expand: false,
                              height: 32,
                              onPressed: logic.addLine,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Column(
                              children: [
                                for (final draft in logic.lines.toList())
                                  _LineItemCard(
                                    key: ObjectKey(draft),
                                    draft: draft,
                                    onRemove: () => logic.removeLine(draft),
                                  ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                  child: Obx(() => CustomButton(
                        text: 'Create PO',
                        onPressed: logic.isCreating.value ? null : logic.createOrder,
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

class _LineItemCard extends StatelessWidget {
  final PurchaseOrderLineDraft draft;
  final VoidCallback onRemove;

  const _LineItemCard({super.key, required this.draft, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ProjectFormCard(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: onRemove,
            child: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade500),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CustomTextField(
                heading: 'Description',
                hintText: 'Material/Item...',
                controller: draft.descriptionCtrl,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: CustomTextField(
                heading: 'Qty',
                hintText: '0',
                controller: draft.quantityCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        projectFieldGap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Unit',
                hintText: 'ea, lf...',
                controller: draft.unitCtrl,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomTextField(
                heading: 'Unit Cost',
                hintText: '\$0.00',
                controller: draft.unitCostCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
          ],
        ),
        projectFieldGap,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextField(
                heading: 'Cost Code',
                hintText: 'Search c...',
                controller: draft.costCodeCtrl,
                leftIconPath: AppIcons.search,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Obx(() => ProjectDateField(
                    label: 'Expected Delivery',
                    hint: 'dd/mm/yyyy',
                    format: 'dd/MM/yyyy',
                    value: draft.expectedDelivery.value,
                    onChanged: (d) => draft.expectedDelivery.value = d,
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
