import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Create Submittal" form. Short-lived, no `tag`.
class CreateSubmittalLogic extends GetxController {
  final String projectId;
  CreateSubmittalLogic(this.projectId);

  final subjectCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final specSectionCtrl = TextEditingController();

  final Rx<SubmittalType> type = SubmittalType.contractor.obs;
  final Rx<SubmittalPhase> phase = SubmittalPhase.construction.obs;
  final Rxn<String> category = Rxn<String>();
  final Rxn<DateTime> dateRequired = Rxn<DateTime>();
  final isCreating = false.obs;

  String? _clean(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  // API: POST /projects/{id}/submittals
  Future<void> create() async {
    if (subjectCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing subject', 'Give this submittal a subject first.');
      return;
    }
    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.submittals(projectId);
      final number = 'SUB-${(store.length + 1).toString().padLeft(4, '0')}';
      store.insert(
        0,
        SubmittalModel(
          id: 'sub_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          subject: subjectCtrl.text.trim(),
          description: _clean(descriptionCtrl),
          type: type.value,
          phase: phase.value,
          specSection: _clean(specSectionCtrl),
          documentCategory: category.value,
          dateRequired: dateRequired.value,
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('Submittal created', '$number was submitted for review.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [subjectCtrl, descriptionCtrl, specSectionCtrl]) {
      c.dispose();
    }
    super.onClose();
  }
}
