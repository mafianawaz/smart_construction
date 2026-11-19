import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';
import '../widgets/proc_form_scaffold.dart';
import '../widgets/proc_inputs.dart';
import 'logic.dart';

/// New / edit Delivery Receipt. Not in the Figma (only the "+ New DR" button
/// is), so this is my own layout in the same style. Pops with a [DeliveryReceipt].
class NewReceiptView extends StatelessWidget {
  final List<PurchaseOrder> orders;
  final List<String> inspectors;
  final String nextNumber;
  final DeliveryReceipt? existing;

  const NewReceiptView({
    super.key,
    required this.orders,
    required this.inspectors,
    required this.nextNumber,
    this.existing,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewReceiptLogic>(
      init: NewReceiptLogic(
        orders: orders,
        inspectors: inspectors,
        nextNumber: nextNumber,
        existing: existing,
      ),
      builder: (logic) {
        return ProcFormScaffold(
          title: logic.isEdit ? 'Edit Delivery Receipt' : 'New Delivery Receipt',
          subtitle: 'Record items received against a purchase order.',
          buttonText: logic.isEdit ? 'Save Changes' : 'Create DR',
          onSubmit: logic.submit,
          children: [
            ProcDropdown(
              label: 'Purchase Order',
              required: true,
              hint: 'Select PO...',
              value: logic.poNumber,
              options: logic.poOptions,
              errorText: logic.errors['po'],
              onChanged: logic.setPo,
            ),
            ProcRow(
              left: ProcDateField(
                label: 'Received On',
                text: formatProcDate(logic.receivedOn),
                onTap: logic.pickDate,
              ),
              right: ProcDropdown(
                label: 'Inspected By',
                hint: 'Select inspector...',
                value: logic.inspectedBy,
                options: logic.inspectorOptions,
                onChanged: logic.setInspector,
              ),
            ),
            ProcRow(
              left: ProcField(
                label: 'Items Received',
                required: true,
                hint: '0',
                controller: logic.receivedCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: procDigitsFormatters(),
                errorText: logic.errors['received'],
                onChanged: (_) => logic.clearError('received'),
              ),
              right: ProcField(
                label: 'Items Expected',
                hint: 'Optional',
                controller: logic.expectedCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: procDigitsFormatters(),
              ),
            ),
            Text(
              'If fewer items are received than expected, the receipt is marked Partial.',
              style: TextStyle(fontSize: 11, color: ProcStyle.muted),
            ),
            const SizedBox(height: 14),
            ProcField(
              label: 'Notes',
              hint: 'Condition, damage, missing items...',
              controller: logic.notesCtrl,
              maxLines: 4,
            ),
          ],
        );
      },
    );
  }
}
