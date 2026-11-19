import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/marketplace_mock_data.dart';
import '../models/marketplace_models.dart';

/// Shared Create / Edit controller for the equipment listing form.
class EquipmentFormLogic extends GetxController {
  EquipmentFormLogic({this.existing});

  final EquipmentModel? existing;
  bool get isEdit => existing != null;

  final nameC = TextEditingController();
  final makeModelC = TextEditingController();
  final yearC = TextEditingController();
  final dailyC = TextEditingController();
  final weeklyC = TextEditingController();
  final monthlyC = TextEditingController();
  final depositC = TextEditingController();
  final locationC = TextEditingController();
  final radiusC = TextEditingController();
  final photosC = TextEditingController();
  final descriptionC = TextEditingController();

  final category = ''.obs;
  final condition = 'Good'.obs;
  final ongoing = true.obs;

  @override
  void onInit() {
    super.onInit();
    final e = existing;
    if (e != null) {
      nameC.text = e.name;
      makeModelC.text = [e.make, e.model].where((s) => s.isNotEmpty).join(' ');
      yearC.text = e.year;
      dailyC.text = _num(e.dailyRate);
      weeklyC.text = _num(e.weeklyRate);
      monthlyC.text = _num(e.monthlyRate);
      depositC.text = _num(e.deposit);
      locationC.text = e.location;
      radiusC.text = e.deliveryRadius;
      photosC.text = e.photoUrls.join(', ');
      descriptionC.text = e.description;
      category.value = e.category;
      condition.value = e.condition;
      ongoing.value = e.ongoing;
    }
  }

  String _num(double v) => v == 0 ? '' : v.toStringAsFixed(2);

  double _parse(TextEditingController c) =>
      double.tryParse(c.text.trim()) ?? 0;

  /// Returns null and shows a snackbar when required fields are missing.
  EquipmentModel? build() {
    if (nameC.text.trim().isEmpty || category.value.isEmpty) {
      Get.snackbar('Missing details', 'Equipment name and category are required');
      return null;
    }
    final parts = makeModelC.text.trim().split(RegExp(r'\s+'));
    final make = parts.isEmpty ? '' : parts.first;
    final model = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    final photos = photosC.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final base = existing ??
        EquipmentModel(
          id: 'e${DateTime.now().microsecondsSinceEpoch}',
          name: '',
          make: '',
          model: '',
          year: '',
          category: '',
          condition: 'Good',
          dailyRate: 0,
          weeklyRate: 0,
          monthlyRate: 0,
          deposit: 0,
          location: '',
          deliveryRadius: '',
          photoUrls: const [],
          ongoing: true,
          description: '',
          ownerOrg: MarketplaceMockData.currentOrg,
        );

    return base.copyWith(
      name: nameC.text.trim(),
      make: make,
      model: model,
      year: yearC.text.trim(),
      category: category.value,
      condition: condition.value,
      dailyRate: _parse(dailyC),
      weeklyRate: _parse(weeklyC),
      monthlyRate: _parse(monthlyC),
      deposit: _parse(depositC),
      location: locationC.text.trim(),
      deliveryRadius: radiusC.text.trim(),
      photoUrls: photos,
      ongoing: ongoing.value,
      description: descriptionC.text.trim(),
    );
  }

  @override
  void onClose() {
    for (final c in [
      nameC,
      makeModelC,
      yearC,
      dailyC,
      weeklyC,
      monthlyC,
      depositC,
      locationC,
      radiusC,
      photosC,
      descriptionC,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
