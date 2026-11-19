import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_button.dart';
import '../../../utils/app_color.dart';
import 'logic.dart';
import 'request_overtime/view.dart';
import 'widgets/gps_status_banner.dart';
import 'widgets/project_selector_card.dart';
import 'widgets/shift_history_section.dart';
import 'models/time_tracking_models.dart';

/// Screen-agnostic entry point covering screens 1 & 2 of the reference
/// design (empty Clock In state, and Clock In with populated Shift
/// History) — both are just different states of the same controller.
class TimeTrackingScreen extends StatelessWidget {
  final String instanceTag;

  const TimeTrackingScreen({super.key, this.instanceTag = 'default'});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      TimeTrackingController(instanceTag: instanceTag),
      tag: instanceTag,
    );

    return Scaffold(
      appBar: AppPrimaryBar(
        title: 'Time Tracking',
        showBackButton: true,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Track the hours of your shift',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text('Clock in to start tracking', style: TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: Obx(()=> Column(
                children: [
                  ProjectSelectorCard(
                    projects: controller.projects,
                    costCodes: controller.costCodes,
                    selectedProject: controller.selectedProject.value,
                    selectedCostCode: controller.selectedCostCode.value,
                    locked: controller.isClockedIn.value,
                    onProjectChanged: controller.selectProject,
                    onCostCodeChanged: controller.selectCostCode,
                  ),
                  const SizedBox(height: 16),
                  GpsStatusBanner(
                    status: controller.gpsStatus.value,
                    onRetry: controller.retryGpsCheck,
                  ),
                  const SizedBox(height: 16),
                  CustomButton(text: 'Clock In', onPressed: controller.clockIn),
                ],
              ),)
            ),

            // Obx(() => SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: controller.canClockIn && !controller.isSubmitting.value
            //           ? controller.clockIn
            //           : null,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: AppColors.primaryOrange,
            //         disabledBackgroundColor: AppColors.primaryOrange.withOpacity(0.5),
            //         padding: const EdgeInsets.symmetric(vertical: 16),
            //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //       ),
            //       child: controller.isSubmitting.value
            //           ? const SizedBox(
            //         height: 18,
            //         width: 18,
            //         child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            //       )
            //           : Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: const [
            //           Text('Clock In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            //           SizedBox(width: 6),
            //           Icon(Icons.arrow_forward, size: 16, color: Colors.white),
            //         ],
            //       ),
            //     ),
            //   ),),
            const SizedBox(height: 28),
            ShiftHistorySection(
                entries: controller.shiftHistory,
                onViewAll: () {},
                onRequestOvertime: (shift) => _openOvertimeRequest(context, shift),
              ),
          ],
        ),
      ),
    );
  }

  void _openOvertimeRequest(BuildContext context, ShiftEntry shift) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RequestOvertimeScreen(shift: shift)),
    );
  }
}
