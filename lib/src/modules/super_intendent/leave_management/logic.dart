import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'model/leave_model.dart';

class SuperInLeaveManagementLogic extends GetxController {
  // History
  final requests = <LeaveRequest>[].obs;

  // Form state
  final selectedType = Rx<LeaveType>(LeaveType.vacation);
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final reasonController = TextEditingController();
  final isSubmitting = false.obs;

  // ---- Balances -----------------------------------------------------------
  List<LeaveType> get balanceTypes =>
      LeaveType.values.where((t) => t.hasBalance).toList();

  int usedDays(LeaveType t) => requests
      .where((r) => r.type == t && r.status == LeaveStatus.approved)
      .fold(0, (sum, r) => sum + r.days);

  int remainingDays(LeaveType t) => (t.totalDays ?? 0) - usedDays(t);

  // ---- Pickers ------------------------------------------------------------
  Future<void> pickStartDate(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365 * 2)),
    );
    if (picked == null) return;
    startDate.value = picked;
    // Keep end >= start
    if (endDate.value != null && endDate.value!.isBefore(picked)) {
      endDate.value = null;
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final first = startDate.value ?? today;
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? first,
      firstDate: first,
      lastDate: today.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) endDate.value = picked;
  }

  // ---- Actions ------------------------------------------------------------
  String? _validate() {
    if (startDate.value == null) return 'Please select a start date';
    if (endDate.value == null) return 'Please select an end date';
    final t = selectedType.value;
    if (t.hasBalance) {
      final days = endDate.value!.difference(startDate.value!).inDays + 1;
      if (days > remainingDays(t)) {
        return 'Only ${remainingDays(t)} ${t.label} days remaining';
      }
    }
    return null;
  }

  Future<void> submit() async {
    final error = _validate();
    if (error != null) {
      Get.snackbar('Check your request', error,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSubmitting.value = true;
    try {
      // TODO: replace with your API call
      await Future.delayed(const Duration(milliseconds: 600));

      requests.insert(
        0,
        LeaveRequest(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          type: selectedType.value,
          start: startDate.value!,
          end: endDate.value!,
          reason: reasonController.text.trim(),
        ),
      );
      _resetForm();
      Get.back();
    } finally {
      isSubmitting.value = false;
    }
  }

  void cancelRequest(String id) {
    // TODO: call API, then remove locally
    requests.removeWhere((r) => r.id == id && r.status == LeaveStatus.pending);
  }

  void _resetForm() {
    selectedType.value = LeaveType.vacation;
    startDate.value = null;
    endDate.value = null;
    reasonController.clear();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}