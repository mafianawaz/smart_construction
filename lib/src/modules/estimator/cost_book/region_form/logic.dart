import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cost_book_models.dart';

/// Shared by Add Region and Edit Region. `initial == null` means add.
/// Pops with the finished [GeoFactorModel]; the caller persists it.
class RegionFormLogic extends GetxController {
  final GeoFactorModel? initial;

  RegionFormLogic({this.initial});

  bool get isEdit => initial != null;

  static String _mult(double? v) => (v ?? 1).toStringAsFixed(3);

  late final codeController = TextEditingController(text: initial?.regionCode);
  late final nameController = TextEditingController(text: initial?.regionName);
  late final cityController = TextEditingController(text: initial?.city);
  late final stateController = TextEditingController(text: initial?.state);
  late final postalController =
      TextEditingController(text: initial?.postalCode);
  late final materialController =
      TextEditingController(text: _mult(initial?.materialMult));
  late final laborController =
      TextEditingController(text: _mult(initial?.laborMult));
  late final equipmentController =
      TextEditingController(text: _mult(initial?.equipmentMult));
  late final totalController =
      TextEditingController(text: _mult(initial?.totalMult));

  late final asOf = (initial?.asOf ?? DateTime.now()).obs;
  late final asOfController =
      TextEditingController(text: formatFieldDate(asOf.value));

  final codeError = RxnString();
  final nameError = RxnString();
  final multiplierError = RxnString();

  void setAsOf(DateTime date) {
    asOf.value = date;
    asOfController.text = formatFieldDate(date);
  }

  double? _parse(TextEditingController c) {
    final v = double.tryParse(c.text.trim());
    return (v == null || v <= 0) ? null : v;
  }

  bool _validate() {
    codeError.value =
        codeController.text.trim().isEmpty ? 'Region code is required' : null;
    nameError.value =
        nameController.text.trim().isEmpty ? 'Region name is required' : null;
    final ok = [
      materialController,
      laborController,
      equipmentController,
      totalController,
    ].every((c) => _parse(c) != null);
    multiplierError.value = ok ? null : 'Multipliers must be numbers above 0';
    return codeError.value == null && nameError.value == null && ok;
  }

  void submit() {
    if (!_validate()) return;
    final result = GeoFactorModel(
      id: initial?.id ?? 'geo-${DateTime.now().microsecondsSinceEpoch}',
      regionCode: codeController.text.trim().toUpperCase(),
      regionName: nameController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim().toUpperCase(),
      postalCode: postalController.text.trim(),
      materialMult: _parse(materialController)!,
      laborMult: _parse(laborController)!,
      equipmentMult: _parse(equipmentController)!,
      totalMult: _parse(totalController)!,
      asOf: asOf.value,
    );
    // TODO(api): POST /cost-book/geo-factors  |  PUT /cost-book/geo-factors/{id}
    Get.back(result: result);
  }

  @override
  void onClose() {
    for (final c in [
      codeController,
      nameController,
      cityController,
      stateController,
      postalController,
      materialController,
      laborController,
      equipmentController,
      totalController,
      asOfController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
