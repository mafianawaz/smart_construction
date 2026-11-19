import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/location_models.dart';
import '../../models/project_enums.dart';

/// Owns the "Add Location" form. Short-lived, no `tag`.
class AddLocationLogic extends GetxController {
  final String projectId;
  AddLocationLogic(this.projectId);

  final nameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();

  /// BUILDING is preselected, as in the reference.
  final Rx<LocationLevel> level = LocationLevel.building.obs;
  final isCreating = false.obs;

  // API: POST /projects/{id}/locations
  Future<void> createLocation() async {
    final name = nameCtrl.text.trim();
    if (name.isEmpty) {
      Get.snackbar('Missing name', 'Give this location a name first.');
      return;
    }

    isCreating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      ProjectWorkStore.to.locations(projectId).add(LocationModel(
            id: 'loc_${DateTime.now().microsecondsSinceEpoch}',
            name: name,
            level: level.value,
            description:
                descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim(),
          ));
      Get.back();
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    descriptionCtrl.dispose();
    super.onClose();
  }
}
