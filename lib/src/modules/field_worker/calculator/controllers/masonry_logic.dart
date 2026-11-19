import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/masonry_data.dart';
import '../models/masonry_models.dart';


class MasonryLogic extends GetxController {
  final TextEditingController wallLengthController = TextEditingController();
  final TextEditingController wallHeightController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();
  final TextEditingController mortarPriceController = TextEditingController();

  MasonryUnitType selectedUnitType = MasonryData.unitTypes.first;
  MortarJointOption selectedJoint = MasonryData.defaultJoint;

  final List<MasonryOpening> openings = [];

  /// Ordered so the UI can render results in a stable, predictable order.
  final Map<String, String> results = {};

   setUnitType(MasonryUnitType? type) {
    selectedUnitType = type ?? MasonryData.unitTypes.first;
    _calculate();
  }

  void setJoint(MortarJointOption? joint) {
    selectedJoint = joint ?? MasonryData.defaultJoint;
    _calculate();
  }

  void addOpening() {
    final opening = MasonryOpening();
    opening.widthController.addListener(_calculate);
    opening.heightController.addListener(_calculate);
    openings.add(opening);
    update();
  }

  void removeOpening(MasonryOpening opening) {
    openings.remove(opening);
    opening.dispose();
    _calculate();
  }

  void _calculate() {
    final wallLength = double.tryParse(wallLengthController.text) ?? 0;
    final wallHeight = double.tryParse(wallHeightController.text) ?? 0;
    final grossArea = wallLength * wallHeight;

    double openingsArea = 0;
    for (final opening in openings) {
      openingsArea += opening.areaSqFt;
    }

    final netArea = grossArea - openingsArea;
    results.clear();

    if (netArea <= 0) {
      update();
      return;
    }

    results['netArea'] = '${netArea.toStringAsFixed(2)} sq ft';

    // Face area of one unit including its mortar joint on two sides.
    final joint = selectedJoint.thicknessIn;
    final unitFaceAreaSqFt =
        ((selectedUnitType.lengthIn + joint) * (selectedUnitType.heightIn + joint)) / 144;

    final unitsNeeded = unitFaceAreaSqFt > 0 ? (netArea / unitFaceAreaSqFt).ceil() : 0;
    results['units'] = '$unitsNeeded ${selectedUnitType.pluralLabel}';

    final bagsNeeded =
        selectedUnitType.unitsPerBag > 0 ? (unitsNeeded / selectedUnitType.unitsPerBag).ceil() : 0;
    results['mortarBags'] = '$bagsNeeded bag(s)';

    final unitPrice = double.tryParse(unitPriceController.text);
    final mortarPrice = double.tryParse(mortarPriceController.text);
    if (unitPrice != null || mortarPrice != null) {
      final cost = (unitsNeeded * (unitPrice ?? 0)) + (bagsNeeded * (mortarPrice ?? 0));
      results['estimatedCost'] = '\$${cost.toStringAsFixed(2)}';
    }

    update();
  }

  @override
  void onInit() {
    super.onInit();
    for (final c in [
      wallLengthController,
      wallHeightController,
      unitPriceController,
      mortarPriceController,
    ]) {
      c.addListener(_calculate);
    }
  }

  @override
  void onClose() {
    wallLengthController.dispose();
    wallHeightController.dispose();
    unitPriceController.dispose();
    mortarPriceController.dispose();
    for (final opening in openings) {
      opening.dispose();
    }
    super.onClose();
  }
}
