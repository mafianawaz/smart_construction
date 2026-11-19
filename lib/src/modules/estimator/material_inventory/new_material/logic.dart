import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/inventory_mock_data.dart';
import '../models/inventory_models.dart';

class NewMaterialLogic extends GetxController {
  final Set<String> existingSkus; // lower-cased
  final Set<String> existingBarcodes; // lower-cased

  NewMaterialLogic({
    required this.existingSkus,
    required this.existingBarcodes,
  });

  final skuCtrl = TextEditingController();
  final barcodeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final unitCostCtrl = TextEditingController();
  final reorderPointCtrl = TextEditingController();
  final reorderQtyCtrl = TextEditingController();

  String uom = 'EA';
  String? category;

  final Map<String, String> errors = {};

  List<String> get uoms => InventoryMockData.uoms;
  List<String> get categories => InventoryMockData.categories;

  void setUom(String? v) {
    if (v == null) return;
    uom = v;
    update();
  }

  void setCategory(String? v) {
    category = v;
    update();
  }

  void clearError(String key) {
    if (errors.remove(key) != null) update();
  }

  /// Stub: wire a scanner package and put the result in [barcodeCtrl].
  void scanBarcode() => Get.snackbar('', 'Scanner not connected yet',
      titleText: const SizedBox.shrink(), snackPosition: SnackPosition.BOTTOM);

  void create() {
    errors.clear();
    final sku = skuCtrl.text.trim();
    final barcode = barcodeCtrl.text.trim();
    final name = nameCtrl.text.trim();

    if (sku.isEmpty) {
      errors['sku'] = 'SKU is required';
    } else if (existingSkus.contains(sku.toLowerCase())) {
      errors['sku'] = 'SKU already exists';
    }
    if (barcode.isNotEmpty && existingBarcodes.contains(barcode.toLowerCase())) {
      errors['barcode'] = 'Barcode already in use';
    }
    if (name.isEmpty) errors['name'] = 'Name is required';

    double? parse(TextEditingController c, String key) {
      final t = c.text.trim();
      if (t.isEmpty) return 0;
      final v = double.tryParse(t);
      if (v == null || v < 0) {
        errors[key] = 'Enter a valid number';
        return null;
      }
      return v;
    }

    final cost = parse(unitCostCtrl, 'unitCost');
    final point = parse(reorderPointCtrl, 'reorderPoint');
    final qty = parse(reorderQtyCtrl, 'reorderQty');

    if (errors.isNotEmpty) {
      update();
      return;
    }

    // POST /inventory/materials — replace with the real call, then pop with
    // the server's version of the item.
    Get.back(
      result: InventoryMaterial(
        id: 'm-${DateTime.now().microsecondsSinceEpoch}',
        sku: sku,
        barcode: barcode,
        name: name,
        uom: uom,
        category: category ?? '',
        unitCost: cost!,
        reorderPoint: point!,
        reorderQty: qty!,
      ),
    );
  }

  @override
  void onClose() {
    skuCtrl.dispose();
    barcodeCtrl.dispose();
    nameCtrl.dispose();
    unitCostCtrl.dispose();
    reorderPointCtrl.dispose();
    reorderQtyCtrl.dispose();
    super.onClose();
  }
}
