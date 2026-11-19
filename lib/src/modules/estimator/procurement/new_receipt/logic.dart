import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/procurement_orders_models.dart';
import '../widgets/proc_inputs.dart';

/// Create / edit a delivery receipt. Pops with the resulting [DeliveryReceipt].
class NewReceiptLogic extends GetxController {
  final List<PurchaseOrder> orders; // POs a receipt can be booked against
  final List<String> inspectors;
  final String nextNumber;
  final DeliveryReceipt? existing;

  NewReceiptLogic({
    required this.orders,
    required this.inspectors,
    required this.nextNumber,
    this.existing,
  });

  bool get isEdit => existing != null;

  String? poNumber;
  DateTime receivedOn = DateTime.now();
  String? inspectedBy;
  final receivedCtrl = TextEditingController();
  final expectedCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final Map<String, String> errors = {};

  List<String> get poOptions {
    final list = orders.map((o) => o.number).toList();
    final cur = existing?.poNumber;
    if (cur != null && !list.contains(cur)) list.add(cur);
    return list;
  }

  List<String> get inspectorOptions {
    final cur = inspectedBy;
    return cur == null || cur.isEmpty || inspectors.contains(cur)
        ? inspectors
        : [...inspectors, cur];
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
    if (e == null) return;
    poNumber = e.poNumber;
    receivedOn = e.receivedOn;
    inspectedBy = e.inspectedBy.isEmpty ? null : e.inspectedBy;
    receivedCtrl.text = e.itemsReceived.toString();
    expectedCtrl.text = e.itemsExpected > 0 ? e.itemsExpected.toString() : '';
    notesCtrl.text = e.notes;
  }

  @override
  void onClose() {
    receivedCtrl.dispose();
    expectedCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }

  /// Picking a PO suggests the expected quantity from its line items.
  void setPo(String? v) {
    poNumber = v;
    errors.remove('po');
    final order = _order(v);
    if (order != null && expectedCtrl.text.trim().isEmpty) {
      final total = order.items.fold(0.0, (s, i) => s + i.qty);
      if (total > 0) expectedCtrl.text = total.round().toString();
    }
    update();
  }

  void setInspector(String? v) {
    inspectedBy = v;
    update();
  }

  void clearError(String key) {
    if (errors.remove(key) != null) update();
  }

  Future<void> pickDate() async {
    final picked = await pickProcDate(receivedOn);
    if (picked == null) return;
    receivedOn = picked;
    update();
  }

  void submit() {
    errors.clear();
    if (poNumber == null) errors['po'] = 'Select a purchase order';

    final received = int.tryParse(receivedCtrl.text.trim());
    final expected = int.tryParse(expectedCtrl.text.trim()) ?? 0;
    if (received == null || received <= 0) {
      errors['received'] = 'Enter items received';
    } else if (expected > 0 && received > expected) {
      errors['received'] = 'More than expected ($expected)';
    }
    if (errors.isNotEmpty) {
      update();
      return;
    }

    final order = _order(poNumber);
    final e = existing;
    // POST /delivery-receipts (PUT /delivery-receipts/{id} when editing).
    Get.back(
      result: DeliveryReceipt(
        id: e?.id ?? 'dr-${DateTime.now().microsecondsSinceEpoch}',
        number: nextNumber,
        poNumber: poNumber!,
        vendor: order?.vendor ?? e?.vendor ?? '—',
        project: order?.project ?? e?.project ?? '',
        status: expected > 0 && received! < expected
            ? ReceiptStatus.partial
            : ReceiptStatus.received,
        receivedOn: receivedOn,
        itemsReceived: received!,
        itemsExpected: expected,
        inspectedBy: inspectedBy ?? '',
        notes: notesCtrl.text.trim(),
        bookmarked: e?.bookmarked ?? false,
      ),
    );
  }
}
