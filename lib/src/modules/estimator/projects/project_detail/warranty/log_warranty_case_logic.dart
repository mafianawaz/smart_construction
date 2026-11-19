import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Log Warranty Case" form. Short-lived, no `tag`.
class LogWarrantyCaseLogic extends GetxController {
  final String projectId;
  LogWarrantyCaseLogic(this.projectId);

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final assignedToCtrl = TextEditingController();
  final responsibilityCtrl = TextEditingController();
  final reporterEmailCtrl = TextEditingController();
  final costCtrl = TextEditingController();

  final Rx<WarrantyType> type = WarrantyType.defect.obs;
  final Rx<PunchPriority> priority = PunchPriority.medium.obs;
  final Rxn<DateTime> reportedDate = Rxn<DateTime>();
  final Rxn<DateTime> targetResolution = Rxn<DateTime>();
  final isCreating = false.obs;

  String? _clean(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  // API: POST /projects/{id}/warranty-cases
  Future<void> create() async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing title', 'Give this case a title first.');
      return;
    }
    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.warrantyCases(projectId);
      final number = 'WC-${(store.length + 1).toString().padLeft(4, '0')}';
      store.insert(
        0,
        WarrantyCaseModel(
          id: 'wc_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          title: titleCtrl.text.trim(),
          type: type.value,
          priority: priority.value,
          description: _clean(descriptionCtrl),
          location: _clean(locationCtrl),
          assignedTo: _clean(assignedToCtrl),
          responsibility: _clean(responsibilityCtrl),
          reporterEmail: _clean(reporterEmailCtrl),
          reportedDate: reportedDate.value,
          targetResolution: targetResolution.value,
          estimatedCost: double.tryParse(costCtrl.text.trim()),
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('Case logged', '$number was logged.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      titleCtrl,
      descriptionCtrl,
      locationCtrl,
      assignedToCtrl,
      responsibilityCtrl,
      reporterEmailCtrl,
      costCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
