import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/kpi_model.dart';

/// Form controller for Create / Edit KPI Template.
/// Pops the finished [KpiTemplate] via `Get.back(result:)`.
class CreateKpiLogic extends GetxController {
  CreateKpiLogic({this.existing});

  final KpiTemplate? existing;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  KpiCategory category = KpiCategory.custom;
  KpiDirection direction = KpiDirection.higherIsBetter;
  bool showNameError = false;

  bool get isEditing => existing != null;

  @override
  void onInit() {
    super.onInit();
    final e = existing;
    if (e != null) {
      nameController.text = e.name;
      descriptionController.text = e.description;
      unitController.text = e.unit;
      category = e.category;
      direction = e.direction;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    unitController.dispose();
    super.onClose();
  }

  void setCategory(c) {
    category = c;
    update();
  }

  void setDirection(d) {
    direction = d;
    update();
  }

  void onNameChanged(_) {
    if (showNameError) {
      showNameError = false;
      update();
    }
  }

  void submit() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      showNameError = true;
      update();
      return;
    }
    final unit = unitController.text.trim().isEmpty
        ? 'count'
        : unitController.text.trim();

    final result = (existing ??
            KpiTemplate(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              name: name,
              category: category,
              unit: unit,
              direction: direction,
            ))
        .copyWith(
      name: name,
      description: descriptionController.text.trim(),
      category: category,
      unit: unit,
      direction: direction,
    );
    Get.back(result: result);
  }
}
