import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';
import '../../models/project_enums.dart';

/// Owns the Generate Report form. Short-lived, no `tag`.
class GenerateReportLogic extends GetxController {
  final String projectId;
  GenerateReportLogic(this.projectId);

  final Rx<ReportType> type = ReportType.weekly.obs;
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final isGenerating = false.obs;

  // API: POST /projects/{id}/progress-reports { type, start, end }
  Future<void> generate() async {
    final start = startDate.value;
    final end = endDate.value;
    if (start == null || end == null) {
      Get.snackbar('Pick a date range', 'Choose a start and end date first.');
      return;
    }
    if (end.isBefore(start)) {
      Get.snackbar('Check dates', 'End date must be on or after the start date.');
      return;
    }
    isGenerating.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      ProjectWorkStore.to.progressReports(projectId).insert(
            0,
            ProgressReportModel(
              id: 'rep_${DateTime.now().microsecondsSinceEpoch}',
              type: type.value,
              rangeStart: start,
              rangeEnd: end,
              generatedAt: DateTime.now(),
            ),
          );
      Get.back();
      Get.snackbar('Report generated', 'Your ${type.value.label.toLowerCase()} is ready.');
    } finally {
      isGenerating.value = false;
    }
  }
}
