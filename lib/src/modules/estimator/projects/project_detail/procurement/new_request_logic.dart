import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/procurement_models.dart';
import '../../models/project_enums.dart';

/// Controllers for one editable line on the New Purchase Request form.
class PurchaseLineDraft {
  final descriptionCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final estCostCtrl = TextEditingController();
  final costCodeCtrl = TextEditingController();

  bool get isBlank => descriptionCtrl.text.trim().isEmpty;

  PurchaseRequestLineItem toModel() => PurchaseRequestLineItem(
        description: descriptionCtrl.text.trim(),
        quantity: double.tryParse(quantityCtrl.text.trim()) ?? 0,
        unit: unitCtrl.text.trim(),
        estCost: double.tryParse(estCostCtrl.text.trim()) ?? 0,
        costCode: costCodeCtrl.text.trim().isEmpty ? null : costCodeCtrl.text.trim(),
      );

  void dispose() {
    for (final c in [descriptionCtrl, quantityCtrl, unitCtrl, estCostCtrl, costCodeCtrl]) {
      c.dispose();
    }
  }
}

/// Owns the "New Purchase Request" form. Short-lived, no `tag`. Starts
/// with one blank line item, as in the reference.
class NewRequestLogic extends GetxController {
  final String projectId;
  NewRequestLogic(this.projectId);

  final titleCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final Rxn<DateTime> neededBy = Rxn<DateTime>();

  final lines = <PurchaseLineDraft>[].obs;
  final isCreating = false.obs;

  @override
  void onInit() {
    super.onInit();
    lines.add(PurchaseLineDraft());
  }

  void addLine() => lines.add(PurchaseLineDraft());

  /// Removing the last remaining line leaves a fresh blank one so the
  /// form never has zero lines.
  void removeLine(PurchaseLineDraft draft) {
    lines.remove(draft);
    if (lines.isEmpty) lines.add(PurchaseLineDraft());
    // Dispose after the frame so the card's TextFields unmount first.
    WidgetsBinding.instance.addPostFrameCallback((_) => draft.dispose());
  }

  // API: POST /projects/{id}/purchase-requests
  Future<void> createRequest() async {
    final title = titleCtrl.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Missing title', 'Give this request a title first.');
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
      final store = ProjectWorkStore.to.purchaseRequests(projectId);
      final number = 'PR-${(store.length + 1).toString().padLeft(4, '0')}';
      store.insert(
        0,
        PurchaseRequestModel(
          id: 'pr_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          title: title,
          neededBy: neededBy.value,
          notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
          status: PurchaseRequestStatus.pending,
          lineItems: [for (final l in filled) l.toModel()],
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('Request created', '$number was submitted for approval.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    notesCtrl.dispose();
    for (final l in lines) {
      l.dispose();
    }
    super.onClose();
  }
}
