import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/procurement_orders_models.dart';
import '../widgets/proc_inputs.dart';

/// Create / edit a vendor invoice. Pops with the resulting [VendorInvoice].
class NewInvoiceLogic extends GetxController {
  final List<PurchaseOrder> orders;
  final String nextNumber;
  final VendorInvoice? existing;

  NewInvoiceLogic({
    required this.orders,
    required this.nextNumber,
    this.existing,
  });

  bool get isEdit => existing != null;

  String? poNumber;
  DateTime? dueDate;
  DateTime? paidDate;
  final numberCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final Map<String, String> errors = {};

  List<String> get poOptions {
    final list = orders.map((o) => o.number).toList();
    final cur = existing?.poNumber;
    if (cur != null && !list.contains(cur)) list.add(cur);
    return list;
  }

  PurchaseOrder? _order(String? number) {
    for (final o in orders) {
      if (o.number == number) return o;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    final e = existing;
    if (e == null) {
      numberCtrl.text = nextNumber;
      return;
    }
    numberCtrl.text = e.number;
    poNumber = e.poNumber;
    amountCtrl.text = e.amount == e.amount.roundToDouble()
        ? e.amount.toInt().toString()
        : e.amount.toString();
    dueDate = e.dueDate;
    paidDate = e.paidDate;
    notesCtrl.text = e.notes;
  }

  @override
  void onClose() {
    numberCtrl.dispose();
    amountCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  /// Picking a PO suggests its estimate as the invoice amount.
  void setPo(String? v) {
    poNumber = v;
    errors.remove('po');
    final order = _order(v);
    if (order != null && amountCtrl.text.trim().isEmpty && order.estimate > 0) {
      amountCtrl.text = order.estimate == order.estimate.roundToDouble()
          ? order.estimate.toInt().toString()
          : order.estimate.toString();
    }
    update();
  }

  void clearError(String key) {
    if (errors.remove(key) != null) update();
  }

  Future<void> pickDue() async {
    final picked = await pickProcDate(dueDate);
    if (picked == null) return;
    dueDate = picked;
    update();
  }

  Future<void> pickPaid() async {
    final picked = await pickProcDate(paidDate);
    if (picked == null) return;
    paidDate = picked;
    update();
  }

  void clearPaid() {
    paidDate = null;
    update();
  }

  /// Paid date wins; otherwise a past due date means overdue.
  InvoiceStatus get derivedStatus {
    if (paidDate != null) return InvoiceStatus.paid;
    final due = dueDate;
    if (due != null) {
      final n = DateTime.now();
      if (due.isBefore(DateTime(n.year, n.month, n.day))) {
        return InvoiceStatus.overdue;
      }
    }
    return InvoiceStatus.pending;
  }

  void submit() {
    errors.clear();
    final number = numberCtrl.text.trim();
    final amount = double.tryParse(amountCtrl.text.trim());
    if (poNumber == null) errors['po'] = 'Select a purchase order';
    if (number.isEmpty) errors['number'] = 'Invoice number is required';
    if (amount == null || amount <= 0) errors['amount'] = 'Enter an amount above 0';
    if (errors.isNotEmpty) {
      update();
      return;
    }

    final order = _order(poNumber);
    final e = existing;
    // POST /vendor-invoices (PUT /vendor-invoices/{id} when editing).
    Get.back(
      result: VendorInvoice(
        id: e?.id ?? 'inv-${DateTime.now().microsecondsSinceEpoch}',
        number: number,
        poNumber: poNumber!,
        vendor: order?.vendor ?? e?.vendor ?? '—',
        project: order?.project ?? e?.project ?? '',
        status: derivedStatus,
        amount: amount!,
        dueDate: dueDate,
        paidDate: paidDate,
        notes: notesCtrl.text.trim(),
        bookmarked: e?.bookmarked ?? false,
      ),
    );
  }
}
