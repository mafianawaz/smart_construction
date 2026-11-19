import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/crew_models.dart';

/// Shared by New Crew Template and Edit Crew Template.
/// `initial == null` means create. Pops with the finished template.
class CrewTemplateFormLogic extends GetxController {
  final CrewTemplateModel? initial;

  CrewTemplateFormLogic({this.initial});

  bool get isEdit => initial != null;

  static String _num(double? v) =>
      v == null ? '' : (v % 1 == 0 ? v.toStringAsFixed(0) : v.toString());

  late final codeController = TextEditingController(text: initial?.code);
  late final nameController = TextEditingController(text: initial?.name);
  late final tradeController = TextEditingController(text: initial?.tradeType);
  late final hoursController = TextEditingController(
    text: (initial?.defaultHoursPerDay ?? 8).toStringAsFixed(2),
  );
  late final unitController =
      TextEditingController(text: initial?.productionUnit);
  late final productionController =
      TextEditingController(text: _num(initial?.productionPerDay));
  late final descriptionController =
      TextEditingController(text: initial?.description);

  late final isActive = (initial?.isActive ?? true).obs;
  late final workers = <CrewWorkerModel>[...?initial?.workers].obs;
  late final equipment = <CrewEquipmentModel>[...?initial?.equipment].obs;

  /// Bumped when hours change so the live cost summary recomputes.
  final hoursTick = 0.obs;

  final codeError = RxnString();
  final nameError = RxnString();
  final hoursError = RxnString();

  void setActive(bool v) => isActive.value = v;

  void onHoursChanged( _) => hoursTick.value++;

  double get hoursPerDay => double.tryParse(hoursController.text.trim()) ?? 0;

  void addWorker(CrewWorkerModel w) => workers.add(w);
  void removeWorkerAt(int i) => workers.removeAt(i);
  void addEquipment(CrewEquipmentModel e) => equipment.add(e);
  void removeEquipmentAt(int i) => equipment.removeAt(i);

  /// Hours used by row costs; reading [hoursTick] makes Obx rebuild on edits.
  double get hoursForCost {
    hoursTick.value;
    return hoursPerDay;
  }

  /// Live preview of the daily cost, using the formulas in the form's intro.
  double get previewDailyCost {
    final h = hoursForCost;
    final labor = workers.fold(0.0, (s, w) => s + w.dailyCost(h));
    final equip = equipment.fold(0.0, (s, e) => s + e.dailyCost);
    return labor + equip;
  }

  bool _validate() {
    codeError.value =
        codeController.text.trim().isEmpty ? 'Code is required' : null;
    nameError.value =
        nameController.text.trim().isEmpty ? 'Name is required' : null;
    final h = double.tryParse(hoursController.text.trim());
    hoursError.value =
        (h == null || h <= 0 || h > 24) ? 'Enter hours between 0 and 24' : null;
    return codeError.value == null &&
        nameError.value == null &&
        hoursError.value == null;
  }

  void submit() {
    if (!_validate()) return;
    final result = CrewTemplateModel(
      id: initial?.id ?? 'crew-${DateTime.now().microsecondsSinceEpoch}',
      code: codeController.text.trim().toUpperCase(),
      name: nameController.text.trim(),
      tradeType: tradeController.text.trim(),
      defaultHoursPerDay: hoursPerDay,
      productionUnit: unitController.text.trim().toUpperCase(),
      productionPerDay: double.tryParse(productionController.text.trim()),
      description: descriptionController.text.trim(),
      isActive: isActive.value,
      workers: List.of(workers),
      equipment: List.of(equipment),
    );
    // TODO(api): POST /crew-templates  |  PUT /crew-templates/{id}
    Get.back(result: result);
  }

  @override
  void onClose() {
    for (final c in [
      codeController,
      nameController,
      tradeController,
      hoursController,
      unitController,
      productionController,
      descriptionController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
