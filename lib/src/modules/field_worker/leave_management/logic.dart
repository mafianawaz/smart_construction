import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LeaveBalance {
  final String title;
  final String icon;
  final int total;
  final int used;

  const LeaveBalance({
    required this.title,
    required this.icon,
    required this.total,
    required this.used,
  });

  int get remaining => total - used;
}

class LeaveRequest {
  final String id;
  final String type;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;

  const LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  int get days => endDate.difference(startDate).inDays + 1;
}

class LeaveManagementLogic extends GetxController {
  // ============================================================
  // FORM CONTROLLERS
  // ============================================================

  final reasonController = TextEditingController();

  // ============================================================
  // FORM STATE
  // ============================================================

  final selectedLeaveType = RxnString();

  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  final leaveTypeError = RxnString();
  final startDateError = RxnString();
  final endDateError = RxnString();

  // ============================================================
  // SCREEN STATE
  // ============================================================

  bool isRequestMode = false;
  bool isSubmitting = false;

  // ============================================================
  // LEAVE TYPES
  // ============================================================

  final List<String> leaveTypes = const [
    'Jury Duty',
    'Personal',
    'Medical',
    'Vacation',
    'Family',
    'Emergency',
  ];

  // ============================================================
  // BALANCES
  // ============================================================

  final List<LeaveBalance> leaveBalances = const [
    LeaveBalance(
      title: 'Vacation',
      icon: 'vacation',
      total: 15,
      used: 0,
    ),
    LeaveBalance(
      title: 'Medical',
      icon: 'medical',
      total: 10,
      used: 0,
    ),
    LeaveBalance(
      title: 'Personal',
      icon: 'personal',
      total: 3,
      used: 0,
    ),
    LeaveBalance(
      title: 'Jury Duty',
      icon: 'jury',
      total: 5,
      used: 4,
    ),
    LeaveBalance(
      title: 'Family',
      icon: 'family',
      total: 0,
      used: 0,
    ),
    LeaveBalance(
      title: 'Emergency',
      icon: 'emergency',
      total: 4,
      used: 0,
    ),
  ];

  // ============================================================
  // REQUEST HISTORY
  // ============================================================

  final List<LeaveRequest> requests = [
    LeaveRequest(
      id: '1',
      type: 'Jury Duty',
      startDate: DateTime(2026, 6, 17),
      endDate: DateTime(2026, 6, 20),
      reason: 'TESTING LEAVE',
      status: 'Approved',
    ),
    LeaveRequest(
      id: '2',
      type: 'Personal',
      startDate: DateTime(2026, 6, 19),
      endDate: DateTime(2026, 6, 23),
      reason: 'TESTING',
      status: 'Denied',
    ),
  ];

  // ============================================================
  // NAVIGATION
  // ============================================================

  void openRequestForm() {
    clearForm();

    isRequestMode = true;

    update();
  }

  void closeRequestForm() {
    clearForm();

    isRequestMode = false;

    update();
  }

  // ============================================================
  // LEAVE TYPE
  // ============================================================

  void selectLeaveType(String? value) {
    selectedLeaveType.value = value;
    leaveTypeError.value = null;
  }

  // ============================================================
  // START DATE
  // ============================================================

  Future<void> pickStartDate(BuildContext context) async {
    final today = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? today,
      firstDate: today,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    startDate.value = picked;
    startDateError.value = null;

    // Reset end date if it is now invalid.
    if (endDate.value != null &&
        endDate.value!.isBefore(picked)) {
      endDate.value = null;
    }
  }

  // ============================================================
  // END DATE
  // ============================================================

  Future<void> pickEndDate(BuildContext context) async {
    final minimumDate = startDate.value ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: endDate.value ?? minimumDate,
      firstDate: minimumDate,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    endDate.value = picked;
    endDateError.value = null;
  }

  // ============================================================
  // VALIDATION
  // ============================================================

  bool validateForm() {
    bool valid = true;

    leaveTypeError.value = null;
    startDateError.value = null;
    endDateError.value = null;

    if (selectedLeaveType.value == null) {
      leaveTypeError.value = 'Please select a leave type';
      valid = false;
    }

    if (startDate.value == null) {
      startDateError.value = 'Please select a start date';
      valid = false;
    }

    if (endDate.value == null) {
      endDateError.value = 'Please select an end date';
      valid = false;
    }

    if (startDate.value != null &&
        endDate.value != null &&
        endDate.value!.isBefore(startDate.value!)) {
      endDateError.value =
      'End date cannot be before start date';
      valid = false;
    }

    return valid;
  }

  // ============================================================
  // REQUESTED DAYS
  // ============================================================

  int get requestedDays {
    if (startDate.value == null || endDate.value == null) {
      return 0;
    }

    return endDate.value!
        .difference(startDate.value!)
        .inDays +
        1;
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> submitRequest() async {
    if (!validateForm()) {
      return;
    }

    isSubmitting = true;
    update();

    try {
      // TODO: API integration
      //
      // await leaveService.createLeaveRequest(
      //   leaveType: selectedLeaveType.value!,
      //   startDate: startDate.value!,
      //   endDate: endDate.value!,
      //   reason: reasonController.text.trim(),
      // );

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      requests.insert(
        0,
        LeaveRequest(
          id: DateTime.now()
              .millisecondsSinceEpoch
              .toString(),
          type: selectedLeaveType.value!,
          startDate: startDate.value!,
          endDate: endDate.value!,
          reason: reasonController.text.trim(),
          status: 'Pending',
        ),
      );

      isSubmitting = false;
      isRequestMode = false;

      clearForm();

      update();

      Get.snackbar(
        'Leave Request',
        'Your leave request has been submitted successfully.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isSubmitting = false;

      update();

      Get.snackbar(
        'Error',
        'Unable to submit leave request.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // CANCEL REQUEST
  // ============================================================

  Future<void> cancelRequest(LeaveRequest request) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Cancel Leave Request'),
        content: const Text(
          'Are you sure you want to cancel this leave request?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // TODO: API cancel request

    requests.removeWhere(
          (item) => item.id == request.id,
    );

    update();

    Get.snackbar(
      'Leave Request',
      'Leave request cancelled successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void clearForm() {
    selectedLeaveType.value = null;

    startDate.value = null;
    endDate.value = null;

    leaveTypeError.value = null;
    startDateError.value = null;
    endDateError.value = null;

    reasonController.clear();
  }

  @override
  void onClose() {
    reasonController.dispose();
    super.onClose();
  }
}