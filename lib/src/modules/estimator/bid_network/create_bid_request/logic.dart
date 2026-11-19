import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/bid_network_models.dart';

class CreateBidRequestLogic extends GetxController {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final scopeController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final budgetMinController = TextEditingController();
  final budgetMaxController = TextEditingController();
  final specialController = TextEditingController();

  final selectedTrades = <String>[].obs;
  final dueDate = Rxn<DateTime>();
  final projectStart = Rxn<DateTime>();
  final showBudget = true.obs;
  final requiresBonding = false.obs;
  final requiresInsurance = true.obs;
  final submitted = false.obs;

  /// Title, trades and due date are the required fields (marked * in design).
  bool get isValid =>
      titleController.text.trim().isNotEmpty &&
      selectedTrades.isNotEmpty &&
      dueDate.value != null;

  String? get titleError =>
      submitted.value && titleController.text.trim().isEmpty ? 'Required' : null;
  String? get tradesError =>
      submitted.value && selectedTrades.isEmpty ? 'Select at least one trade' : null;
  String? get dueDateError =>
      submitted.value && dueDate.value == null ? 'Required' : null;

  void toggleTrade(String trade) {
    selectedTrades.contains(trade)
        ? selectedTrades.remove(trade)
        : selectedTrades.add(trade);
  }

  void setTrades(List<String> trades) => selectedTrades.assignAll(trades);

  /// Builds the model for a draft. TODO(api): POST /bid-network/requests
  BidRequestModel? saveAsDraft() {
    submitted.value = true;
    if (!isValid) return null;
    return BidRequestModel(
      id: 'bn-${DateTime.now().millisecondsSinceEpoch}',
      title: titleController.text.trim(),
      organization: 'dcec', // TODO(auth): current organization
      description: descriptionController.text.trim(),
      scopeOfWork: scopeController.text.trim(),
      trades: selectedTrades.map((t) => t.toUpperCase()).toList(),
      status: BidRequestStatus.draft,
      createdAt: DateTime.now(),
      dueDate: dueDate.value,
      projectStart: projectStart.value,
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      state: stateController.text.trim(),
      budgetMin: double.tryParse(budgetMinController.text.trim()),
      budgetMax: double.tryParse(budgetMaxController.text.trim()),
      showBudget: showBudget.value,
      requiresBonding: requiresBonding.value,
      requiresInsurance: requiresInsurance.value,
      specialRequirements: specialController.text.trim(),
    );
  }

  @override
  void onClose() {
    for (final c in [
      titleController,
      descriptionController,
      scopeController,
      addressController,
      cityController,
      stateController,
      budgetMinController,
      budgetMaxController,
      specialController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
