import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/field_ops_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Create RFI" form. Short-lived, no `tag`.
class CreateRfiLogic extends GetxController {
  final String projectId;
  CreateRfiLogic(this.projectId);

  static const String noSubcontractor = 'None';

  final subjectCtrl = TextEditingController();
  final questionCtrl = TextEditingController();
  final drawingCtrl = TextEditingController();
  final specCtrl = TextEditingController();
  final impactCtrl = TextEditingController();

  final Rx<PunchPriority> priority = PunchPriority.medium.obs;
  final Rx<RfiCategory> category = RfiCategory.none.obs;
  final RxString assignTo = FieldOpsMockData.teamMembers.first.obs; // "Unassigned"
  final RxString subcontractor = noSubcontractor.obs;
  final Rxn<DateTime> dateRequired = Rxn<DateTime>();
  final costImpact = false.obs;
  final scheduleImpact = false.obs;
  final isCreating = false.obs;

  List<String> get assignOptions => FieldOpsMockData.teamMembers;

  /// "None" plus whoever is assigned to the project's subcontracts.
  List<String> get subcontractorOptions => [
        noSubcontractor,
        ...ProjectWorkStore.to.subcontractors(projectId).map((s) => s.company),
      ];

  String? _clean(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  // API: POST /projects/{id}/rfis
  Future<void> create() async {
    if (subjectCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing subject', 'Add a brief description of the issue first.');
      return;
    }
    if (questionCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing question', 'Describe the question requiring clarification.');
      return;
    }
    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.rfis(projectId);
      final number = 'RFI-${(store.length + 1).toString().padLeft(4, '0')}';
      store.insert(
        0,
        RfiModel(
          id: 'rfi_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          subject: subjectCtrl.text.trim(),
          question: questionCtrl.text.trim(),
          priority: priority.value,
          category: category.value,
          assignedTo: assignTo.value == assignOptions.first ? null : assignTo.value,
          subcontractor: subcontractor.value == noSubcontractor ? null : subcontractor.value,
          drawingReference: _clean(drawingCtrl),
          specReference: _clean(specCtrl),
          dateRequired: dateRequired.value,
          impactDescription: _clean(impactCtrl),
          costImpact: costImpact.value,
          scheduleImpact: scheduleImpact.value,
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('RFI created', '$number was created.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [subjectCtrl, questionCtrl, drawingCtrl, specCtrl, impactCtrl]) {
      c.dispose();
    }
    super.onClose();
  }
}
