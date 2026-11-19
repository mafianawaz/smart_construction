import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/materials_models.dart';
import '../../models/scope_models.dart';

/// Owns the "Record Materials Usage" form. Short-lived, no `tag`.
class RecordUsageLogic extends GetxController {
  final String projectId;
  RecordUsageLogic(this.projectId);

  final descriptionCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final unitCostCtrl = TextEditingController();
  final vendorCtrl = TextEditingController();
  final receiptCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final Rxn<ScopeItemModel> scopeItem = Rxn<ScopeItemModel>();
  final Rxn<DateTime> date = Rxn<DateTime>();
  final isSaving = false.obs;

  List<ScopeItemModel> get scopeItems => ProjectWorkStore.to.scopeItems(projectId).toList();

  /// Picking a scope item prefills the unit (still editable) — saves
  /// retyping "CY" on every entry.
  void selectScopeItem(ScopeItemModel? item) {
    scopeItem.value = item;
    if (item != null && unitCtrl.text.trim().isEmpty) unitCtrl.text = item.unit;
  }

  // API: POST /projects/{id}/material-usage
  Future<void> recordUsage() async {
    final item = scopeItem.value;
    final quantity = double.tryParse(quantityCtrl.text.trim()) ?? 0;
    final unitCost = double.tryParse(unitCostCtrl.text.trim()) ?? 0;

    if (item == null) {
      Get.snackbar('Missing scope item', 'Select the scope item this usage belongs to.');
      return;
    }
    if (quantity <= 0) {
      Get.snackbar('Missing quantity', 'Quantity must be greater than 0.');
      return;
    }

    String? optional(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

    isSaving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      ProjectWorkStore.to.materialUsages(projectId).add(MaterialUsageModel(
            id: 'usage_${DateTime.now().microsecondsSinceEpoch}',
            scopeItemId: item.id,
            scopeItemName: item.name,
            date: date.value ?? DateTime.now(),
            description: descriptionCtrl.text.trim(),
            quantity: quantity,
            unit: unitCtrl.text.trim().isEmpty ? item.unit : unitCtrl.text.trim(),
            unitCost: unitCost,
            vendor: optional(vendorCtrl),
            receiptNumber: optional(receiptCtrl),
            notes: optional(notesCtrl),
          ));
      Get.back();
      Get.snackbar('Usage recorded', 'Deducted from the ${item.name} budget.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      descriptionCtrl,
      quantityCtrl,
      unitCtrl,
      unitCostCtrl,
      vendorCtrl,
      receiptCtrl,
      notesCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
