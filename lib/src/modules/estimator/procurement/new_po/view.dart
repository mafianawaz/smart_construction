import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';
import '../new_request/logic.dart' show LineItemDraft;
import '../widgets/proc_form_scaffold.dart';
import '../widgets/proc_inputs.dart';
import 'logic.dart';

/// New Purchase Order form (also used to edit one). Pops with a [PurchaseOrder].
class NewPurchaseOrderView extends StatelessWidget {
  final List<String> projects;
  final List<String> vendors;
  final String nextNumber;
  final PurchaseOrder? existing;

  const NewPurchaseOrderView({
    super.key,
    required this.projects,
    required this.vendors,
    required this.nextNumber,
    this.existing,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewPurchaseOrderLogic>(
      init: NewPurchaseOrderLogic(
        projects: projects,
        vendors: vendors,
        nextNumber: nextNumber,
        existing: existing,
      ),
      builder: (logic) {
        return ProcFormScaffold(
          title: logic.isEdit ? 'Edit Purchase Order' : 'New Purchase Order',
          subtitle: 'Create a purchase order with line items.',
          buttonText: logic.isEdit ? 'Save Changes' : 'Create PO',
          onSubmit: logic.submit,
          children: [
            ProcRow(
              left: ProcDropdown(
                label: 'Project',
                required: true,
                hint: 'Select project...',
                value: logic.project,
                options: logic.projectOptions,
                errorText: logic.errors['project'],
                onChanged: logic.setProject,
              ),
              right: ProcDropdown(
                label: 'Vendor',
                hint: 'Select vendor...',
                value: logic.vendor,
                options: logic.vendorOptions,
                onChanged: logic.setVendor,
              ),
            ),
            ProcRow(
              left: ProcDateField(
                label: 'Needed By',
                text: logic.neededBy == null
                    ? ''
                    : formatProcDate(logic.neededBy!),
                onTap: logic.pickDate,
              ),
              right: ProcField(
                label: 'Terms',
                hint: 'Net 30, COD...',
                controller: logic.termsCtrl,
              ),
            ),
            ProcField(
              label: 'Delivery Address',
              hint: 'Enter delivery address...',
              controller: logic.addressCtrl,
              keyboardType: TextInputType.streetAddress,
            ),
            ProcField(
              label: 'Notes',
              hint: 'Add any additional instructions...',
              controller: logic.notesCtrl,
              maxLines: 4,
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Line Items',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
                GestureDetector(
                  onTap: logic.addItem,
                  child: Text('+ Add Item',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: ProcStyle.orange)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < logic.items.length; i++)
              _LineItemRow(
                logic: logic,
                index: i,
                item: logic.items[i],
              ),
            if (logic.errors['items'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(logic.errors['items']!,
                    style: const TextStyle(
                        fontSize: 11, color: ProcStyle.danger)),
              ),
            Row(
              children: [
                Text('Estimated total',
                    style: TextStyle(fontSize: 12, color: ProcStyle.muted)),
                const Spacer(),
                Text(logic.estimateText,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Description / Qty / Unit / Unit Cost row (no card, per the Figma).
class _LineItemRow extends StatelessWidget {
  final NewPurchaseOrderLogic logic;
  final int index;
  final LineItemDraft item;

  const _LineItemRow({
    required this.logic,
    required this.index,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    const decimal = TextInputType.numberWithOptions(decimal: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 4,
              child: ProcField(
                label: index == 0 ? 'Description' : null,
                hint: 'Enter desc...',
                controller: item.description,
                errorText: item.errors['description'],
                onChanged: (_) => logic.clearItemError(item, 'description'),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: ProcField(
                label: index == 0 ? 'Qty' : null,
                hint: '0',
                controller: item.qty,
                keyboardType: decimal,
                inputFormatters: procDecimalFormatters(),
                errorText: item.errors['qty'],
                onChanged: (_) {
                  logic.clearItemError(item, 'qty');
                  logic.update();
                },
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 2,
              child: ProcField(
                label: index == 0 ? 'Unit' : null,
                hint: 'ea',
                controller: item.unit,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              flex: 3,
              child: ProcField(
                label: index == 0 ? 'Unit Cost' : null,
                hint: '\$0.00',
                controller: item.unitCost,
                keyboardType: decimal,
                inputFormatters: procDecimalFormatters(),
                onChanged: (_) => logic.update(),
              ),
            ),
            if (logic.items.length > 1)
              Padding(
                // Align with the 44px-high inputs (+ label row on the first line).
                padding: EdgeInsets.only(top: index == 0 ? 24 : 0, left: 2),
                child: SizedBox(
                  width: 28,
                  height: 44,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close,
                        size: 16, color: ProcStyle.danger),
                    onPressed: () => logic.removeItem(index),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
