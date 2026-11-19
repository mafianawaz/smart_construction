import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../data/projects_mock_data.dart';
import '../../models/estimate_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Add Manual Line Items" form. Short-lived, no `tag`.
class AddLineItemLogic extends GetxController {
  final String projectId;
  AddLineItemLogic(this.projectId);

  final descriptionCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final laborHoursCtrl = TextEditingController();
  final laborCostCtrl = TextEditingController();
  final equipmentCtrl = TextEditingController();
  final consumablesCtrl = TextEditingController();
  final subcontractCtrl = TextEditingController();
  final overheadCtrl = TextEditingController();
  final profitCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  final Rxn<EstimateLineCategory> category = Rxn<EstimateLineCategory>();
  final laborClassification = manualLaborClassification.obs;
  final isSaving = false.obs;

  List<String> get laborClassifications => ProjectsMockData.laborClassifications;

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  // API: POST /projects/{id}/estimate/line-items
  Future<void> addLineItem() async {
    final description = descriptionCtrl.text.trim();
    if (description.isEmpty) {
      Get.snackbar('Missing description', 'Describe the line item first.');
      return;
    }

    isSaving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      ProjectWorkStore.to.estimateLines(projectId).add(EstimateLineItemModel(
            id: 'line_${DateTime.now().microsecondsSinceEpoch}',
            description: description,
            category: category.value ?? EstimateLineCategory.other,
            unit: unitCtrl.text.trim().toUpperCase(),
            quantity: _num(quantityCtrl),
            laborClassification: laborClassification.value,
            laborHours: _num(laborHoursCtrl),
            laborCost: _num(laborCostCtrl),
            equipmentCost: _num(equipmentCtrl),
            consumablesCost: _num(consumablesCtrl),
            subcontractCost: _num(subcontractCtrl),
            overheadAllocation: _num(overheadCtrl),
            profitAllocation: _num(profitCtrl),
            notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
          ));
      Get.back();
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      descriptionCtrl,
      unitCtrl,
      quantityCtrl,
      laborHoursCtrl,
      laborCostCtrl,
      equipmentCtrl,
      consumablesCtrl,
      subcontractCtrl,
      overheadCtrl,
      profitCtrl,
      notesCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
