import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';
import 'generate_report_view.dart';
import 'reports_settings_view.dart';

/// Owns the Progress Reports tab. Reports live in `ProjectWorkStore` so
/// the Generate form's result survives tab switches. Put with
/// `tag: projectId`.
class ReportsLogic extends GetxController {
  final String projectId;
  ReportsLogic(this.projectId);

  RxList<ProgressReportModel> get reports => ProjectWorkStore.to.progressReports(projectId);

  void openSettings() => Get.to(
        () => ReportsSettingsView(projectId: projectId),
        routeName: '/reports/settings',
      );

  void openGenerate() => Get.to(
        () => GenerateReportView(projectId: projectId),
        routeName: '/reports/generate',
      );

  // API: GET /projects/{id}/progress-reports/{reportId}/download
  void download(ProgressReportModel report) {
    Get.snackbar('Download', 'Report download is not wired up yet.');
  }
}
