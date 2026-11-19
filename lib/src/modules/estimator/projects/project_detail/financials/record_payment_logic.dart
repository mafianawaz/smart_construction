import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/financial_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Record Payment" form. Short-lived, no `tag`. Payment Method
/// starts on Check, as in the reference.
class RecordPaymentLogic extends GetxController {
  final String projectId;
  RecordPaymentLogic(this.projectId);

  final Rxn<SovRecord> sov = Rxn<SovRecord>();
  final amountCtrl = TextEditingController();
  final Rxn<DateTime> paymentDate = Rxn<DateTime>();
  final Rx<PaymentMethod> method = PaymentMethod.check.obs;
  final referenceCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final isSaving = false.obs;

  List<SovRecord> get sovs => ProjectWorkStore.to.sovs(projectId).toList();

  // API: POST /projects/{id}/sovs/{sovId}/payments
  Future<void> record() async {
    final amount = double.tryParse(amountCtrl.text.trim().replaceAll(',', ''));
    if (sov.value == null) {
      Get.snackbar('Missing SOV', 'Select the SOV pay app this payment is for.');
      return;
    }
    if (amount == null || amount <= 0) {
      Get.snackbar('Missing amount', 'Enter the payment amount.');
      return;
    }

    isSaving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      ProjectWorkStore.to.payments(projectId).insert(
            0,
            PaymentRecord(
              id: 'pay_${DateTime.now().microsecondsSinceEpoch}',
              sovId: sov.value!.id,
              amount: amount,
              date: paymentDate.value ?? DateTime.now(),
              method: method.value,
              reference:
                  referenceCtrl.text.trim().isEmpty ? null : referenceCtrl.text.trim(),
              notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
            ),
          );
      Get.back();
      Get.snackbar('Payment recorded', 'Payment applied to ${sov.value!.number}.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    amountCtrl.dispose();
    referenceCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
