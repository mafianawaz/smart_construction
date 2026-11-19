import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/mock_data.dart';
import '../models/time_tracking_models.dart';

/// Owns state for the Request Overtime form. One instance per shift being
/// contested — construct with the ShiftEntry that triggered the request.
class OvertimeController extends GetxController {
  final ShiftEntry shift;
  OvertimeController({required this.shift});

  final Rx<ApproverOption?> selectedApprover = Rx<ApproverOption?>(null);
  final RxString notes = ''.obs;
  final TextEditingController notesController = TextEditingController();
  final RxBool isSubmitting = false.obs;
  final RxList<ApproverOption> approvers = <ApproverOption>[].obs;

  @override
  void onInit() {
    super.onInit();
    approvers.assignAll(TimeTrackingMockData.approvers());
  }

  Duration get excessHours => shift.overtimeExcess ?? Duration.zero;

  void selectApprover(ApproverOption? approver) => selectedApprover.value = approver;

  void updateNotes(String value) => notesController.text = value;

  bool get canSubmit =>
      selectedApprover.value != null && notesController.text.trim().isNotEmpty && !isSubmitting.value;

  Future<void> submit() async {
    if (!canSubmit) return;
    isSubmitting.value = true;
    // TODO: call overtime-request API with shift.id, selectedApprover, notes.
    await Future.delayed(const Duration(milliseconds: 500));
    isSubmitting.value = false;
  }
}
