import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/financials_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../models/procurement_models.dart';
import '../../models/project_enums.dart';

/// Controllers for one editable line on the New Purchase Order form.
class PurchaseOrderLineDraft {
  final descriptionCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final unitCostCtrl = TextEditingController();
  final costCodeCtrl = TextEditingController();
  final Rxn<DateTime> expectedDelivery = Rxn<DateTime>();

  bool get isBlank => descriptionCtrl.text.trim().isEmpty;

  PurchaseOrderLineItem toModel() => PurchaseOrderLineItem(
        description: descriptionCtrl.text.trim(),
        quantity: double.tryParse(quantityCtrl.text.trim()) ?? 0,
        unit: unitCtrl.text.trim(),
        unitCost: double.tryParse(unitCostCtrl.text.trim()) ?? 0,
        costCode: costCodeCtrl.text.trim().isEmpty ? null : costCodeCtrl.text.trim(),
        expectedDelivery: expectedDelivery.value,
      );

  void dispose() {
    for (final c in [descriptionCtrl, quantityCtrl, unitCtrl, unitCostCtrl, costCodeCtrl]) {
      c.dispose();
    }
  }
}

/// Owns the "New Purchase Order" form. Short-lived, no `tag`. Starts with
/// one blank line item, as in the reference. New POs are created as
/// Draft (a guess — the reference doesn't show the resulting status).
class NewPurchaseOrderLogic extends GetxController {
  final String projectId;
  NewPurchaseOrderLogic(this.projectId);

  final Rxn<String> vendor = Rxn<String>();
  final Rxn<DateTime> neededBy = Rxn<DateTime>();
  final termsCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final lines = <PurchaseOrderLineDraft>[].obs;
  final isCreating = false.obs;

  // API: GET /org/vendors
  List<String> get vendors => FinancialsMockData.vendors;

  @override
  void onInit() {
    super.onInit();
    lines.add(PurchaseOrderLineDraft());
  }

  void addLine() => lines.add(PurchaseOrderLineDraft());

  /// Removing the last remaining line leaves a fresh blank one so the form
  /// never has zero lines.
  void removeLine(PurchaseOrderLineDraft draft) {
    lines.remove(draft);
    if (lines.isEmpty) lines.add(PurchaseOrderLineDraft());
    // Dispose after the frame so the card's TextFields unmount first.
    WidgetsBinding.instance.addPostFrameCallback((_) => draft.dispose());
  }

  String? _nullIfBlank(String v) => v.trim().isEmpty ? null : v.trim();

  // API: POST /projects/{id}/purchase-orders
  Future<void> createOrder() async {
    if (vendor.value == null) {
      Get.snackbar('Missing vendor', 'Select a vendor first.');
      return;
    }
    final filled = lines.where((l) => !l.isBlank).toList();
    if (filled.isEmpty) {
      Get.snackbar('No line items', 'Add at least one line item with a description.');
      return;
    }

    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.purchaseOrders(projectId);
      final number = 'PO-${(store.length + 1).toString().padLeft(4, '0')}';
      store.insert(
        0,
        PurchaseOrderModel(
          id: 'po_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          vendor: vendor.value!,
          neededBy: neededBy.value,
          terms: _nullIfBlank(termsCtrl.text),
          deliveryAddress: _nullIfBlank(addressCtrl.text),
          notes: _nullIfBlank(notesCtrl.text),
          status: PurchaseOrderStatus.draft,
          lineItems: [for (final l in filled) l.toModel()],
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('Purchase order created', '$number was saved as a draft.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    termsCtrl.dispose();
    addressCtrl.dispose();
    notesCtrl.dispose();
    for (final l in lines) {
      l.dispose();
    }
    super.onClose();
  }
}
