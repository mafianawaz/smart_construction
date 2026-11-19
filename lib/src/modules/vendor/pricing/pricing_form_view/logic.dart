import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/pricing_category.dart';
import '../models/pricing_item_model.dart';
import '../models/pricing_status.dart';

class PricingFormLogic extends GetxController {
  PricingFormLogic({required this.category, this.existingItem});

  final PricingCategory category;

  /// Null when adding a new item; set when editing one in place.
  final PricingItemModel? existingItem;

  bool get isEditing => existingItem != null;
  String get screenTitle =>
      isEditing ? category.editFormTitle : category.addFormTitle;

  late final nameController =
      TextEditingController(text: existingItem?.name ?? '');
  late final codeController =
      TextEditingController(text: existingItem?.code ?? '');
  late final descriptionController =
      TextEditingController(text: existingItem?.description ?? '');
  late final unitPriceController = TextEditingController(
    text: existingItem != null ? existingItem!.unitPrice.toStringAsFixed(2) : '',
  );
  late final minimumOrderController = TextEditingController(
    text: existingItem != null ? '${existingItem!.minimumOrder}' : '1',
  );
  late final deliveryFeeController = TextEditingController(
    text: existingItem != null ? existingItem!.deliveryFee.toStringAsFixed(2) : '',
  );
  late final leadTimeController = TextEditingController(
    text: existingItem != null ? '${existingItem!.leadTimeDays}' : '1',
  );

  late final Rx<String> subCategory = (existingItem?.subCategory ??
          category.subCategoryOptions.first)
      .obs;
  late final Rx<String> unit =
      (existingItem?.unit ?? category.unitOptions.first).obs;

  final RxString errorMessage = ''.obs;

  void setSubCategory(value) {
    subCategory.value = value;
    update();
  }

  void setUnit(value) {
    unit.value = value;
    update();
  }

  /// Validates and builds the resulting item, or sets [errorMessage] and
  /// returns null. Kept intentionally simple (required-field + numeric
  /// checks) — see NOTES_PRICING.md for what real validation should add.
  PricingItemModel? submit() {
    if (nameController.text.trim().isEmpty) {
      errorMessage.value = 'Item name is required.';
      return null;
    }
    if (codeController.text.trim().isEmpty) {
      errorMessage.value = 'Item code is required.';
      return null;
    }
    final unitPrice = double.tryParse(unitPriceController.text.trim());
    if (unitPrice == null || unitPrice < 0) {
      errorMessage.value = 'Enter a valid unit price.';
      return null;
    }
    final minimumOrder = int.tryParse(minimumOrderController.text.trim());
    if (minimumOrder == null || minimumOrder < 1) {
      errorMessage.value = 'Enter a valid minimum order.';
      return null;
    }
    final deliveryFee =
        double.tryParse(deliveryFeeController.text.trim()) ?? 0.0;
    final leadTimeDays = int.tryParse(leadTimeController.text.trim()) ?? 1;

    errorMessage.value = '';

    // TODO(api): POST /api/pricing-items (add) or
    // PATCH /api/pricing-items/{id} (edit).
    return PricingItemModel(
      id: existingItem?.id ?? 'price-${DateTime.now().millisecondsSinceEpoch}',
      category: category,
      name: nameController.text.trim(),
      code: codeController.text.trim(),
      subCategory: subCategory.value,
      unit: unit.value,
      description: descriptionController.text.trim(),
      unitPrice: unitPrice,
      minimumOrder: minimumOrder,
      deliveryFee: deliveryFee,
      leadTimeDays: leadTimeDays,
      // Resubmitting an edited item sends it back to pending review.
      status: PricingStatus.pending,
      submittedAt: existingItem?.submittedAt ?? DateTime.now(),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    unitPriceController.dispose();
    minimumOrderController.dispose();
    deliveryFeeController.dispose();
    leadTimeController.dispose();
    super.onClose();
  }
}
