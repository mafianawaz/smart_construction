import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/cost_record_model.dart';

class AddCostRecordLogic extends GetxController {
  final description = TextEditingController();
  final scopeCategory = TextEditingController();
  final trade = TextEditingController();
  final costCode = TextEditingController();
  final completedDateText = TextEditingController();
  final quantity = TextEditingController(text: '0');
  final unit = TextEditingController();
  final unitCost = TextEditingController(text: '0');
  final projectName = TextEditingController();
  final projectType = TextEditingController();
  final material = TextEditingController(text: '0');
  final labor = TextEditingController(text: '0');
  final equipment = TextEditingController(text: '0');
  final subcontract = TextEditingController(text: '0');

  final completedDate = Rxn<DateTime>();

  Future<void> pickCompletedDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: completedDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      completedDate.value = picked;
      completedDateText.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  double _num(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  String? _validate() {
    if (description.text.trim().isEmpty) return 'Description is required';
    if (scopeCategory.text.trim().isEmpty) return 'Scope category is required';
    if (trade.text.trim().isEmpty) return 'Trade is required';
    if (costCode.text.trim().isEmpty) return 'Cost code is required';
    if (completedDate.value == null) return 'Completed date is required';
    if (_num(quantity) <= 0) return 'Quantity must be greater than 0';
    if (unit.text.trim().isEmpty) return 'Unit is required';
    if (_num(unitCost) < 0) return 'Unit cost cannot be negative';
    return null;
  }

  void submit() {
    final error = _validate();
    if (error != null) {
      Get.snackbar('Missing information', error,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    Get.back(
      result: CostRecordModel(
        id: 'hc_${DateTime.now().microsecondsSinceEpoch}',
        description: description.text.trim(),
        scopeCategory: scopeCategory.text.trim(),
        trade: trade.text.trim(),
        costCode: costCode.text.trim(),
        completedDate: completedDate.value!,
        quantity: _num(quantity),
        unit: unit.text.trim(),
        unitCost: _num(unitCost),
        projectName: projectName.text.trim(),
        projectType: projectType.text.trim(),
        material: _num(material),
        labor: _num(labor),
        equipment: _num(equipment),
        subcontract: _num(subcontract),
      ),
    );
  }

  @override
  void onClose() {
    for (final c in [
      description, scopeCategory, trade, costCode, completedDateText,
      quantity, unit, unitCost, projectName, projectType,
      material, labor, equipment, subcontract,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
