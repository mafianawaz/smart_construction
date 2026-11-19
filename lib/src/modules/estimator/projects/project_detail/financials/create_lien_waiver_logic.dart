import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/financial_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Create Lien Waiver" form. Short-lived, no `tag`. Waiver Type
/// starts on Conditional Partial, as in the reference.
class CreateLienWaiverLogic extends GetxController {
  final String projectId;
  final String projectLabel;
  CreateLienWaiverLogic(this.projectId, this.projectLabel);

  final Rxn<String> project = Rxn<String>();
  final Rxn<SovRecord> linkedSov = Rxn<SovRecord>();
  final Rx<LienWaiverType> type = LienWaiverType.conditionalPartial.obs;
  final recipientCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final Rxn<DateTime> throughDate = Rxn<DateTime>();
  final amountCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final isCreating = false.obs;

  List<String> get projectOptions => [if (projectLabel.isNotEmpty) projectLabel];
  List<SovRecord> get sovs => ProjectWorkStore.to.sovs(projectId).toList();

  String? _nullIfBlank(String v) => v.trim().isEmpty ? null : v.trim();

  // API: POST /projects/{id}/lien-waivers
  Future<void> create() async {
    final recipient = recipientCtrl.text.trim();
    if (project.value == null) {
      Get.snackbar('Missing project', 'Select a project first.');
      return;
    }
    if (recipient.isEmpty) {
      Get.snackbar('Missing recipient', 'Enter the recipient name.');
      return;
    }

    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      ProjectWorkStore.to.lienWaivers(projectId).insert(
            0,
            LienWaiverRecord(
              id: 'lw_${DateTime.now().microsecondsSinceEpoch}',
              projectLabel: project.value!,
              sovId: linkedSov.value?.id,
              type: type.value,
              recipient: recipient,
              company: _nullIfBlank(companyCtrl.text),
              throughDate: throughDate.value,
              amount: double.tryParse(amountCtrl.text.trim().replaceAll(',', '')) ?? 0,
              notes: _nullIfBlank(notesCtrl.text),
            ),
          );
      Get.back();
      Get.snackbar('Waiver created', 'Lien waiver for $recipient was added.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    recipientCtrl.dispose();
    companyCtrl.dispose();
    amountCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
