import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../data/projects_mock_data.dart';
import '../../models/project_enums.dart';
import '../widgets/project_format.dart';

/// Owns the "Markup Overrides" form. A blank field means "inherit the org
/// default"; a filled one is stored as this estimate's override. Short-lived,
/// no `tag`.
class MarkupOverridesLogic extends GetxController {
  final String projectId;
  MarkupOverridesLogic(this.projectId);

  final Map<MarkupKind, TextEditingController> controllers = {
    for (final k in MarkupKind.values) k: TextEditingController(),
  };

  /// Drives each row's INHERITED / OVERRIDDEN badge as the user types.
  final Map<MarkupKind, RxBool> overridden = {
    for (final k in MarkupKind.values) k: false.obs,
  };

  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = ProjectWorkStore.to.markupOverrides(projectId);
    for (final k in MarkupKind.values) {
      final value = saved[k];
      if (value != null) {
        controllers[k]!.text = projectNumber(value);
        overridden[k]!.value = true;
      }
    }
  }

  double orgDefault(MarkupKind kind) => ProjectsMockData.orgMarkupDefaults[kind] ?? 0;

  void onChanged(MarkupKind kind, String text) =>
      overridden[kind]!.value = text.trim().isNotEmpty;

  // API: PUT /projects/{id}/estimate/markup-overrides  (audit-logged server side)
  Future<void> save() async {
    final parsed = <MarkupKind, double>{};
    for (final k in MarkupKind.values) {
      final text = controllers[k]!.text.trim();
      if (text.isEmpty) continue;
      final value = double.tryParse(text);
      if (value == null || value < 0 || value > 100) {
        Get.snackbar('Invalid ${k.label}', 'Enter a percentage between 0 and 100, or leave it blank.');
        return;
      }
      parsed[k] = value;
    }

    isSaving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final store = ProjectWorkStore.to.markupOverrides(projectId);
      store
        ..clear()
        ..addAll(parsed);
      Get.back();
      Get.snackbar('Overrides saved', 'Markups for this estimate were updated.');
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.onClose();
  }
}
