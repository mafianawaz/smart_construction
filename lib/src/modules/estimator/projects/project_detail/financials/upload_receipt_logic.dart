import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../data/projects_mock_data.dart';
import '../../models/financial_models.dart';

/// Owns the "Upload Receipt" form. Short-lived, no `tag`. The file picker
/// is not wired up (no picker package is confirmed in the app), so "Select
/// File" validates the details and saves the receipt with a placeholder file
/// name — flagged in NOTES_PROCUREMENT_FINANCIALS.md.
class UploadReceiptLogic extends GetxController {
  final String projectId;
  UploadReceiptLogic(this.projectId);

  final vendorCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final costCodeCtrl = TextEditingController();
  final Rx<DateTime> date = DateTime.now().obs;
  final isUploading = false.obs;

  // API: GET /org/cost-codes  (suggestions for the search-or-type field)
  List<String> get costCodes => ProjectsMockData.costCodes;

  // API: POST /projects/{id}/receipts  (multipart: fields + file)
  Future<void> selectFileAndUpload() async {
    final vendor = vendorCtrl.text.trim();
    final amount = double.tryParse(amountCtrl.text.trim().replaceAll(',', ''));
    if (vendor.isEmpty) {
      Get.snackbar('Missing vendor', 'Enter the vendor name first.');
      return;
    }
    if (amount == null || amount <= 0) {
      Get.snackbar('Missing amount', 'Enter the receipt amount.');
      return;
    }

    isUploading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.receipts(projectId);
      store.insert(
        0,
        ReceiptRecord(
          id: 'rc_${DateTime.now().microsecondsSinceEpoch}',
          vendor: vendor,
          amount: amount,
          category: categoryCtrl.text.trim(),
          costCode: costCodeCtrl.text.trim().isEmpty ? null : costCodeCtrl.text.trim(),
          date: date.value,
          fileName: 'receipt_${store.length + 1}.pdf',
        ),
      );
      Get.back();
      Get.snackbar('Receipt uploaded', 'The receipt from $vendor was added.');
    } finally {
      isUploading.value = false;
    }
  }

  @override
  void onClose() {
    vendorCtrl.dispose();
    amountCtrl.dispose();
    categoryCtrl.dispose();
    costCodeCtrl.dispose();
    super.onClose();
  }
}
