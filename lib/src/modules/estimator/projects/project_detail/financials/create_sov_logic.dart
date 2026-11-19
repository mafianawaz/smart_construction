import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/financial_models.dart';

/// Owns the "Create Schedule of Values" form. Short-lived, no `tag`.
class CreateSovLogic extends GetxController {
  final String projectId;
  CreateSovLogic(this.projectId);

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final isCreating = false.obs;

  // API: POST /projects/{id}/sovs
  Future<void> create() async {
    final title = titleCtrl.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Missing title', 'Give this SOV a title first.');
      return;
    }

    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.sovs(projectId);
      final number = 'SOV-${(store.length + 1).toString().padLeft(3, '0')}';
      store.insert(
        0,
        SovRecord(
          id: 'sov_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          title: title,
          description: descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('SOV created', '$number was created.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
