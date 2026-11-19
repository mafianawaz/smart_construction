import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/procurement_orders_models.dart';
import '../models/purchase_request_models.dart';
import '../widgets/proc_form_scaffold.dart';
import '../widgets/proc_inputs.dart';
import 'logic.dart';

/// New / edit Vendor Invoice. Not in the Figma (only the "+ New Invoice"
/// button is), so this is my own layout in the same style.
/// Pops with a [VendorInvoice].
class NewInvoiceView extends StatelessWidget {
  final List<PurchaseOrder> orders;
  final String nextNumber;
  final VendorInvoice? existing;

  const NewInvoiceView({
    super.key,
    required this.orders,
    required this.nextNumber,
    this.existing,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewInvoiceLogic>(
      init: NewInvoiceLogic(
        orders: orders,
        nextNumber: nextNumber,
        existing: existing,
      ),
      builder: (logic) {
        final status = logic.derivedStatus;
        return ProcFormScaffold(
          title: logic.isEdit ? 'Edit Vendor Invoice' : 'New Vendor Invoice',
          subtitle: 'Log an invoice received from a vendor.',
          buttonText: logic.isEdit ? 'Save Changes' : 'Create Invoice',
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
              left: ProcField(
                label: 'Invoice #',
                required: true,
                hint: 'INV-0000-000',
                controller: logic.numberCtrl,
                errorText: logic.errors['number'],
                onChanged: (_) => logic.clearError('number'),
              ),
              right: ProcField(
                label: 'Amount',
                required: true,
                hint: '\$0.00',
                controller: logic.amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: procDecimalFormatters(),
                errorText: logic.errors['amount'],
                onChanged: (_) => logic.clearError('amount'),
              ),
            ),
            ProcRow(
              left: ProcDateField(
                label: 'Due Date',
                text: logic.dueDate == null ? '' : formatProcDate(logic.dueDate!),
                onTap: logic.pickDue,
              ),
              right: ProcDateField(
                label: 'Paid Date',
                text: logic.paidDate == null ? '' : formatProcDate(logic.paidDate!),
                onTap: logic.pickPaid,
              ),
            ),
            Row(
              children: [
                Text('Status: ',
                    style: TextStyle(fontSize: 11, color: ProcStyle.muted)),
                Text(status.label,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: status.fg)),
                const Spacer(),
                if (logic.paidDate != null)
                  GestureDetector(
                    onTap: logic.clearPaid,
                    child: Text('Clear paid date',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ProcStyle.orange)),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            ProcField(
              label: 'Notes',
              hint: 'Payment terms, disputes, references...',
              controller: logic.notesCtrl,
              maxLines: 4,
            ),
          ],
        );
      },
    );
  }
}
