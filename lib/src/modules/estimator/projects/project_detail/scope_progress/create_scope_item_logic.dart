import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/scope_models.dart';

/// Owns the "Create New Scope Items" form. Short-lived, no `tag` — a
/// second pass always starts clean.
class CreateScopeItemLogic extends GetxController {
  final String projectId;
  CreateScopeItemLogic(this.projectId);

  final nameCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final unitPriceCtrl = TextEditingController();

  final isCreating = false.obs;

  // API: POST /projects/{id}/scope-items
  Future<void> createScopeItem() async {
    final name = nameCtrl.text.trim();
    final unit = unitCtrl.text.trim();
    final quantity = double.tryParse(quantityCtrl.text.trim()) ?? 0;

    if (name.isEmpty) {
      Get.snackbar('Missing scope of work', 'Describe the scope item first.');
      return;
    }
    if (unit.isEmpty) {
      Get.snackbar('Missing unit', 'Enter a unit such as SF or CY.');
      return;
    }
    if (quantity <= 0) {
      Get.snackbar('Missing quantity', 'Total quantity must be greater than 0.');
      return;
    }

    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      ProjectWorkStore.to.scopeItems(projectId).add(ScopeItemModel(
            id: 'scope_${DateTime.now().microsecondsSinceEpoch}',
            name: name,
            unit: unit.toUpperCase(),
            totalQuantity: quantity,
            unitPrice: double.tryParse(unitPriceCtrl.text.trim()),
          ));
      Get.back();
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [nameCtrl, unitCtrl, quantityCtrl, unitPriceCtrl]) {
      c.dispose();
    }
    super.onClose();
  }
}
