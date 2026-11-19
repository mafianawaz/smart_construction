import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../../utils/app_color.dart';
import '../../../../widgets/app_appbar.dart';
import '../models/time_tracking_models.dart';
import '../widgets/overtime_form_card.dart';
import 'logic.dart';


/// Screen-agnostic Request Overtime form. Instantiated with the
/// ShiftEntry the request applies to; the controller is tagged per
/// shift id so multiple in-flight requests never collide.
class RequestOvertimeScreen extends StatelessWidget {
  final ShiftEntry shift;

  const RequestOvertimeScreen({super.key, required this.shift});

  String _formatExcess(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final decimalHours = (d.inMinutes / 60).toStringAsFixed(2);
    return '${hours}h ${minutes}m($decimalHours hrs)';
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tag = 'overtime_${shift.id}';
    final controller = Get.put(OvertimeController(shift: shift), tag: tag);

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Time Tracking',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Request Overtime', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date: ${_formatDate(shift.date)}',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                  Flexible(
                    child: Text(
                      'Project: ${shift.projectName}',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() => OvertimeFormCard(
                  excessHoursLabel: _formatExcess(controller.excessHours),
                  approvers: controller.approvers,
                  selectedApprover: controller.selectedApprover.value,
                  onApproverChanged: controller.selectApprover,
                  onNotesChanged: controller.updateNotes,
                  notesController: controller.notesController,
                ),
              ),
              const SizedBox(height: 24),
              Obx(()=> CustomButton(
                  isLoading: controller.isSubmitting.value,
                  text: 'Submit',
                  onPressed: () async {
                    await controller.submit();
                    if (context.mounted) Navigator.of(context).pop();
                  }),)
            ],
          ),
        ),
      ),
    );
  }
}
