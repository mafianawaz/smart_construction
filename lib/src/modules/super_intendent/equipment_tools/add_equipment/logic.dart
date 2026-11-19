import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/equipment_format.dart';
import '../models/equipment_models.dart';

/// Form state for Add New Equipment. Closes via `Get.back(result:)` with an
/// [EquipmentDraft] on Create, or with nothing on Cancel.
class AddEquipmentLogic extends GetxController {
  final TextEditingController nameC = TextEditingController();
  final TextEditingController hoursC = TextEditingController(text: '0');
  final TextEditingController makeC = TextEditingController();
  final TextEditingController modelC = TextEditingController();
  final TextEditingController yearC = TextEditingController();
  final TextEditingController serialC = TextEditingController();
  final TextEditingController vinC = TextEditingController();
  final TextEditingController plateC = TextEditingController();
  final TextEditingController priceC = TextEditingController(text: '0.00');
  final TextEditingController locationC = TextEditingController();
  final TextEditingController lifeC = TextEditingController();
  final TextEditingController salvageC = TextEditingController(text: '0.00');
  final TextEditingController descriptionC = TextEditingController();
  final TextEditingController notesC = TextEditingController();

  EquipmentType? type;
  DepreciationMethod? method;
  DateTime? inServiceDate;
  bool submitted = false;

  // ───────────── validation (shown only after the first Create tap) ─────────────

  String? get nameError =>
      submitted && nameC.text.trim().isEmpty ? 'Name is required' : null;

  String? get typeError => submitted && type == null ? 'Select a type' : null;

  String? get yearError {
    if (!submitted) return null;
    final text = yearC.text.trim();
    if (text.isEmpty) return null;
    final y = int.tryParse(text);
    if (y == null || y < 1900 || y > DateTime.now().year + 1) {
      return 'Enter a valid year';
    }
    return null;
  }

  bool get isValid => nameError == null && typeError == null && yearError == null;

  /// Re-validates live once the user has tried to submit.
  void onTextChanged(_) {
    if (submitted) update();
  }

  void setType(EquipmentType? value) {
    type = value;
    update();
  }

  void setMethod(DepreciationMethod? value) {
    method = value;
    update();
  }

  void setInServiceDate(DateTime value) {
    inServiceDate = value;
    update();
  }

  void submit() {
    submitted = true;
    update();
    if (!isValid) return;

    final yearText = yearC.text.trim();
    final lifeText = lifeC.text.trim();
    Get.back<EquipmentDraft>(
      result: EquipmentDraft(
        name: nameC.text.trim(),
        type: type!,
        currentHours: EquipmentFormat.parseNumber(hoursC.text),
        make: makeC.text.trim(),
        model: modelC.text.trim(),
        year: yearText.isEmpty ? null : int.tryParse(yearText),
        serialNumber: serialC.text.trim(),
        vin: vinC.text.trim(),
        licensePlate: plateC.text.trim(),
        purchasePrice: EquipmentFormat.parseNumber(priceC.text),
        homeLocation: locationC.text.trim(),
        depreciationMethod: method,
        usefulLifeYears: lifeText.isEmpty ? null : int.tryParse(lifeText),
        salvageValue: EquipmentFormat.parseNumber(salvageC.text),
        inServiceDate: inServiceDate,
        description: descriptionC.text.trim(),
        notes: notesC.text.trim(),
      ),
    );
  }

  void cancel() => Get.back<EquipmentDraft>();

  @override
  void onClose() {
    for (final c in [
      nameC, hoursC, makeC, modelC, yearC, serialC, vinC, plateC,
      priceC, locationC, lifeC, salvageC, descriptionC, notesC,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
