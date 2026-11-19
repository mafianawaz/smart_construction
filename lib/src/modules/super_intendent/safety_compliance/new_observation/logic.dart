import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/safety_mock_data.dart';
import '../models/safety_models.dart';

/// Form controller for the New Observation screen.
/// Pops with the created [SafetyObservation] via `Get.back(result:)`.
class NewObservationLogic extends GetxController {
  final TextEditingController descriptionController = TextEditingController();

  String? category;
  ObservationType type = ObservationType.atRisk;
  ObservationSeverity severity = ObservationSeverity.medium;
  bool submitted = false;

  String? get categoryError =>
      submitted && category == null ? 'Select a category' : null;

  String? get descriptionError =>
      submitted && descriptionController.text.trim().isEmpty
          ? 'Describe what you observed'
          : null;

  void setCategory(String? value) {
    category = value;
    update();
  }

  void setType(ObservationType value) {
    type = value;
    update();
  }

  void setSeverity(ObservationSeverity value) {
    severity = value;
    update();
  }

  void onDescriptionChanged(_) {
    if (submitted) update(); // re-validate live after first submit attempt
  }

  void submit() {
    submitted = true;
    update();
    if (categoryError != null || descriptionError != null) return;

    final now = DateTime.now();
    Get.back<SafetyObservation>(
      result: SafetyObservation(
        id: 'obs_${now.millisecondsSinceEpoch}',
        date: now,
        title: category!,
        description: descriptionController.text.trim(),
        observer: SafetyMockData.currentObserverName,
        type: type,
        severity: severity,
      ),
    );
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
