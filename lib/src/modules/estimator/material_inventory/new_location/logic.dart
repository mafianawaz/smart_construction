import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/inventory_models.dart';

class NewLocationLogic extends GetxController {
  final Set<String> existingCodes; // lower-cased

  NewLocationLogic({required this.existingCodes});

  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  LocationType type = LocationType.warehouse;
  final Map<String, String> errors = {};

  void setType(LocationType? v) {
    if (v == null) return;
    type = v;
    update();
  }

  void clearError(String key) {
    if (errors.remove(key) != null) update();
  }

  void create() {
    errors.clear();
    final code = codeCtrl.text.trim();
    final name = nameCtrl.text.trim();

    if (code.isEmpty) {
      errors['code'] = 'Code is required';
    } else if (existingCodes.contains(code.toLowerCase())) {
      errors['code'] = 'Code already exists';
    }
    if (name.isEmpty) errors['name'] = 'Name is required';

    if (errors.isNotEmpty) {
      update();
      return;
    }

    // POST /inventory/locations — replace with the real call, then pop with
    // the server's version of the location.
    Get.back(
      result: StockLocation(
        id: 'l-${DateTime.now().microsecondsSinceEpoch}',
        code: code,
        name: name,
        type: type,
        address: addressCtrl.text.trim(),
        notes: notesCtrl.text.trim(),
      ),
    );
  }

  @override
  void onClose() {
    codeCtrl.dispose();
    nameCtrl.dispose();
    addressCtrl.dispose();
    notesCtrl.dispose();
    super.onClose();
  }
}
