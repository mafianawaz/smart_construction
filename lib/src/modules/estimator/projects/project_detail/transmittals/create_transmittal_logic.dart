import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Create Transmittal" form. Short-lived, no `tag`.
class CreateTransmittalLogic extends GetxController {
  final String projectId;
  CreateTransmittalLogic(this.projectId);

  final subjectCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final revisionCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  final Rxn<TransmittalDocType> documentType = Rxn<TransmittalDocType>();
  final notifyExtra = false.obs;
  final extraEmails = <String>[].obs;
  final selectedRecipients = <String>{}.obs;
  final isCreating = false.obs;

  /// Companies assigned to this project's subcontracts. Empty until the
  /// Subcontractors tab has data, which shows "No subcontractors available".
  // API: GET /projects/{id}/subcontractor-assignments
  List<String> get availableRecipients =>
      ProjectWorkStore.to.subcontractors(projectId).map((s) => s.company).toList();

  void toggleRecipient(String name) {
    if (!selectedRecipients.remove(name)) selectedRecipients.add(name);
  }

  void addEmail() {
    final e = emailCtrl.text.trim();
    if (e.isEmpty || !e.contains('@')) {
      Get.snackbar('Invalid email', 'Enter a valid email address.');
      return;
    }
    if (!extraEmails.contains(e)) extraEmails.add(e);
    emailCtrl.clear();
  }

  void removeEmail(String e) => extraEmails.remove(e);

  String? _clean(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  // API: POST /projects/{id}/transmittals
  Future<void> create() async {
    if (subjectCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing subject', 'Give this transmittal a subject first.');
      return;
    }
    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.transmittals(projectId);
      final number = 'TR-${(store.length + 1).toString().padLeft(4, '0')}';
      store.insert(
        0,
        TransmittalModel(
          id: 'tr_${DateTime.now().microsecondsSinceEpoch}',
          number: number,
          subject: subjectCtrl.text.trim(),
          description: _clean(descriptionCtrl),
          documentType: documentType.value,
          revisionNumber: _clean(revisionCtrl),
          recipients: selectedRecipients.toList(),
          notes: _clean(notesCtrl),
          notifyEmails: notifyExtra.value ? extraEmails.toList() : const [],
          createdAt: DateTime.now(),
        ),
      );
      Get.back();
      Get.snackbar('Transmittal created', '$number was created as a draft.');
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [subjectCtrl, descriptionCtrl, revisionCtrl, notesCtrl, emailCtrl]) {
      c.dispose();
    }
    super.onClose();
  }
}
