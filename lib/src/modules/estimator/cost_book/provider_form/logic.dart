import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cost_book_models.dart';

/// Shared by Add Provider and Edit Provider. `initial == null` means add.
/// Pops with the finished [CostBookProviderModel]; the caller persists it.
class ProviderFormLogic extends GetxController {
  final CostBookProviderModel? initial;

  ProviderFormLogic({this.initial});

  bool get isEdit => initial != null;

  late final nameController = TextEditingController(text: initial?.name);
  late final endpointController =
      TextEditingController(text: initial?.apiEndpoint);
  late final keyEnvController =
      TextEditingController(text: initial?.apiKeyEnvVar);
  late final regionController =
      TextEditingController(text: initial?.defaultRegion);
  late final notesController = TextEditingController(text: initial?.notes);

  late final kind = (initial?.kind ?? ProviderKind.builtin).obs;
  late final isActive = (initial?.isActive ?? true).obs;

  final nameError = RxnString();
  final endpointError = RxnString();

  void setKind(ProviderKind? value) {
    if (value == null) return;
    kind.value = value;
    endpointError.value = null;
  }

  void setActive(bool value) => isActive.value = value;

  bool _validate() {
    nameError.value =
        nameController.text.trim().isEmpty ? 'Name is required' : null;
    endpointError.value =
        kind.value.needsApi && endpointController.text.trim().isEmpty
            ? 'API endpoint is required for external providers'
            : null;
    return nameError.value == null && endpointError.value == null;
  }

  void submit() {
    if (!_validate()) return;
    final base = initial;
    final result = CostBookProviderModel(
      id: base?.id ?? 'prov-${DateTime.now().microsecondsSinceEpoch}',
      name: nameController.text.trim(),
      kind: kind.value,
      apiEndpoint: endpointController.text.trim(),
      apiKeyEnvVar: keyEnvController.text.trim(),
      defaultRegion: regionController.text.trim(),
      notes: notesController.text.trim(),
      isActive: isActive.value,
      lastSynced: base?.lastSynced,
    );
    // TODO(api): POST /cost-book/providers  |  PUT /cost-book/providers/{id}
    Get.back(result: result);
  }

  @override
  void onClose() {
    nameController.dispose();
    endpointController.dispose();
    keyEnvController.dispose();
    regionController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
