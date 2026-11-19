import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/projects_mock_data.dart';
import '../models/change_order_model.dart';
import '../models/closeout_readiness_model.dart';
import '../models/geofence_models.dart';
import '../models/project_enums.dart';
import '../models/project_model.dart';
import '../models/scheduled_log_model.dart';

/// Owns everything on the Project Detail screen. Put with `tag:
/// project.id` so multiple projects' details never collide.
///
/// Every method marked `// API:` is a mock-data seam.
class ProjectDetailLogic extends GetxController {
  final ProjectModel project;
  ProjectDetailLogic(this.project);

  final Rx<ProjectDetailTab> tab = ProjectDetailTab.overview.obs;
  onTabChange(ProjectDetailTab t) => tab.value = t;

  final RxBool isRefreshingHealth = false.obs;

  final RxList<ChangeOrderModel> changeOrders = <ChangeOrderModel>[].obs;
  final Rx<CloseoutReadinessModel> closeoutReadiness =
      const CloseoutReadinessModel().obs;
  final Rx<GeofenceSettings> geofence = const GeofenceSettings().obs;

  final RxBool autoChangeOrdersEnabled = false.obs;
  final autoChangeOrderThresholdCtrl = TextEditingController(text: '0.00');

  final RxString payrollFormVariant = ProjectsMockData.payrollFormVariants.first.obs;

  final RxList<ScheduledLogSettings> scheduledLogs = <ScheduledLogSettings>[].obs;

  final Rx<DateTime> complianceStart =
      DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  final Rx<DateTime> complianceEnd = DateTime.now().obs;
  final RxList<ShiftGeofenceStatus> complianceShifts = <ShiftGeofenceStatus>[].obs;
  final RxBool isLoadingCompliance = false.obs;

  @override
  void onInit() {
    super.onInit();
    changeOrders.assignAll(ProjectsMockData.changeOrders(project.id));
    closeoutReadiness.value = ProjectsMockData.closeoutReadiness(project.id);
    geofence.value = ProjectsMockData.geofenceSettings(project.id);
    autoChangeOrdersEnabled.value = true; // matches the reference's "on" toggle
    scheduledLogs.assignAll(ProjectsMockData.scheduledLogSettings(project.id));
    loadComplianceShifts();
  }

  // API: POST /projects/{id}/health-score/refresh
  Future<void> refreshHealthScore() async {
    isRefreshingHealth.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isRefreshingHealth.value = false;
  }

  // ---- Change Orders --------------------------------------------------

  void viewChangeOrders() {
    Get.snackbar('Change Orders', 'Change order list is not wired up yet.');
  }

  // ---- Geo-fence Enforcement --------------------------------------------

  void setEnforcementMode(GeofenceEnforcementMode mode) =>
      geofence.value = geofence.value.copyWith(mode: mode);

  // API: POST /projects/{id}/site-coordinates
  void setSiteCoordinates() {
    Get.snackbar('Site Coordinates', 'Address entry is not wired up yet.');
  }

  void pickOnMap() {
    Get.snackbar('Pick on Map', 'Map picker is not wired up yet.');
  }

  // API: POST /projects/{id}/geofence-zones
  void addGeofenceZone() {
    Get.snackbar('Geo-fence Zone', 'Zone creation is not wired up yet.');
  }

  // ---- Auto Change Orders -----------------------------------------------

  void toggleAutoGeneration(bool value) => autoChangeOrdersEnabled.value = value;

  // API: PATCH /projects/{id}/auto-change-orders { costThreshold }
  void saveCostThreshold() {
    Get.snackbar('Saved', 'Cost threshold updated.');
  }

  // ---- Certified Payroll --------------------------------------------------

  // API: PATCH /projects/{id}/payroll-form { variant }
  void setPayrollFormVariant(String variant) => payrollFormVariant.value = variant;

  // ---- Scheduled Log Emails -----------------------------------------------

  void _updateLog(ScheduledLogType type, ScheduledLogSettings Function(ScheduledLogSettings) update) {
    final index = scheduledLogs.indexWhere((l) => l.type == type);
    if (index == -1) return;
    scheduledLogs[index] = update(scheduledLogs[index]);
  }

  void setLogCadence(ScheduledLogType type, LogCadence cadence) =>
      _updateLog(type, (l) => l.copyWith(cadence: cadence));

  // API: POST /projects/{id}/scheduled-logs/{type}/test
  void sendTestNow(ScheduledLogType type) {
    Get.snackbar('Test sent', '${type.title} test email queued.');
  }

  // API: PATCH /projects/{id}/scheduled-logs/{type}
  void saveLogSettings(ScheduledLogType type) {
    Get.snackbar('Saved', '${type.title} settings updated.');
  }

  // ---- Geo-fence Compliance -----------------------------------------------

  void setComplianceRange(DateTime start, DateTime end) {
    complianceStart.value = start;
    complianceEnd.value = end;
    loadComplianceShifts();
  }

  // API: GET /projects/{id}/geofence-compliance?start&end
  Future<void> loadComplianceShifts() async {
    isLoadingCompliance.value = true;
    final shifts = await ProjectsMockData.shiftStatuses(
      project.id,
      start: complianceStart.value,
      end: complianceEnd.value,
    );
    complianceShifts.assignAll(shifts);
    isLoadingCompliance.value = false;
  }

  @override
  void onClose() {
    autoChangeOrderThresholdCtrl.dispose();
    super.onClose();
  }
}
