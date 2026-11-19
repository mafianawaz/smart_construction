import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/financials_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../data/projects_mock_data.dart';
import '../../models/financial_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Create Change Order" form. Short-lived, no `tag`.
class CreateChangeOrderLogic extends GetxController {
  final String projectId;
  CreateChangeOrderLogic(this.projectId);

  final numberCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final Rxn<String> costCode = Rxn<String>();
  final Rxn<String> workTypeCategory = Rxn<String>();
  final Rxn<String> workType = Rxn<String>();
  final isCreating = false.obs;

  // API: GET /org/cost-codes
  List<String> get costCodes => ProjectsMockData.costCodes;

  // API: GET /org/work-types
  List<String> get workTypeCategories => FinancialsMockData.workTypes.keys.toList();

  /// Empty until a category is picked ("Select category first").
  List<String> get workTypeOptions => FinancialsMockData.workTypes[workTypeCategory.value] ?? [];

  void selectCategory(String? c) {
    workTypeCategory.value = c;
    workType.value = null;
  }

  // API: POST /projects/{id}/change-orders
  Future<void> create() async {
    final amount = double.tryParse(amountCtrl.text.trim().replaceAll(',', ''));
    if (amount == null) {
      Get.snackbar('Missing amount', 'Enter the change order amount (e.g. 2500.00).');
      return;
    }

    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.changeOrderRecords(projectId);
      final typed = numberCtrl.text.trim();
      final number =
          typed.isNotEmpty ? typed : 'PCO-${(store.length + 1).toString().padLeft(3, '0')}';
      store.insert(
        0,
        ChangeOrderRecord(
          id: 'co_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          amount: amount,
          costCode: costCode.value,
          workTypeCategory: workTypeCategory.value,
          workType: workType.value,
          description: descriptionCtrl.text.trim(),
          status: ChangeOrderRecordStatus.pending,
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('Change order created', '$number was added as a pending change order.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    numberCtrl.dispose();
    amountCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
