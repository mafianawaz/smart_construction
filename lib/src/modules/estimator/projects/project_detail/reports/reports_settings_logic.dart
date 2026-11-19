import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/portal_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';
import '../../models/project_enums.dart';
import '../../models/scheduled_log_model.dart';
import 'generate_report_view.dart';

/// Owns Reports Settings: weekly / monthly counters, auto-generate
/// toggles, email recipients and the "Scheduled log emails" card (which
/// loads on its own and can fail). Short-lived, tagged by project.
class ReportsSettingsLogic extends GetxController {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  final String projectId;
  ReportsSettingsLogic(this.projectId);

  RxList<ProgressReportModel> get reports => ProjectWorkStore.to.progressReports(projectId);
  Rx<ReportAutomationSettings> get automation =>
      ProjectWorkStore.to.reportAutomation(projectId);

  final recipientCtrl = TextEditingController();

  final Rx<CardLoadState> logsState = CardLoadState.loading.obs;
  final RxList<ScheduledLogSettings> scheduledLogs = <ScheduledLogSettings>[].obs;

  int countOf(ReportType t) => reports.where((r) => r.type == t).length;

  @override
  void onInit() {
    super.onInit();
    loadScheduledLogs();
  }

  // API: PATCH /projects/{id}/progress-reports/settings { autoWeekly }
  void setAutoWeekly(bool v) => automation.value = automation.value.copyWith(autoWeekly: v);

  // API: PATCH /projects/{id}/progress-reports/settings { autoMonthly }
  void setAutoMonthly(bool v) =>
      automation.value = automation.value.copyWith(autoMonthly: v);

  // API: POST /projects/{id}/progress-reports/recipients
  void addRecipient() {
    final email = recipientCtrl.text.trim();
    if (!_emailPattern.hasMatch(email)) {
      Get.snackbar('Check email address', 'Enter a valid email address.');
      return;
    }
    final current = automation.value.recipients;
    if (current.any((e) => e.toLowerCase() == email.toLowerCase())) {
      Get.snackbar('Already added', '$email is already a recipient.');
      return;
    }
    automation.value = automation.value.copyWith(recipients: [...current, email]);
    recipientCtrl.clear();
  }

  // API: DELETE /projects/{id}/progress-reports/recipients/{email}
  void removeRecipient(String email) => automation.value = automation.value
      .copyWith(recipients: automation.value.recipients.where((e) => e != email).toList());

  // API: GET /projects/{id}/scheduled-logs
  Future<void> loadScheduledLogs() async {
    logsState.value = CardLoadState.loading;
    try {
      scheduledLogs.assignAll(await PortalMockData.loadScheduledLogs(projectId));
      logsState.value = CardLoadState.loaded;
    } catch (_) {
      logsState.value = CardLoadState.error;
    }
  }

  void _updateLog(ScheduledLogType type, ScheduledLogSettings Function(ScheduledLogSettings) f) {
    final i = scheduledLogs.indexWhere((l) => l.type == type);
    if (i != -1) scheduledLogs[i] = f(scheduledLogs[i]);
  }

  void setLogCadence(ScheduledLogType type, LogCadence c) =>
      _updateLog(type, (l) => l.copyWith(cadence: c));

  // API: POST /projects/{id}/scheduled-logs/{type}/test
  void sendTestNow(ScheduledLogType type) =>
      Get.snackbar('Test sent', '${type.title} test email queued.');

  // API: PATCH /projects/{id}/scheduled-logs/{type}
  void saveLog(ScheduledLogType type) =>
      Get.snackbar('Saved', '${type.title} settings updated.');

  void openGenerate() => Get.to(
        () => GenerateReportView(projectId: projectId),
        routeName: '/reports/generate',
      );

  // API: GET /projects/{id}/progress-reports/{reportId}/download
  void download(ProgressReportModel report) =>
      Get.snackbar('Download', 'Report download is not wired up yet.');

  @override
  void onClose() {
    recipientCtrl.dispose();
    super.onClose();
  }
}
