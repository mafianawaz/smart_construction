import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';

/// Owns the Maintenance tab: the Log / Schedule / Cost Summary strip, the
/// log filters and the totals. Read-only for now — the references show no
/// create flow. Put with `tag: projectId`.
class MaintenanceLogic extends GetxController {
  final String projectId;
  MaintenanceLogic(this.projectId);

  RxList<MaintenanceLogModel> get logs => ProjectWorkStore.to.maintenanceLogs(projectId);
  RxList<MaintenanceScheduleModel> get schedules =>
      ProjectWorkStore.to.maintenanceSchedules(projectId);

  final section = MaintenanceSection.log.obs;
  void onSectionChange(MaintenanceSection s) => section.value = s;

  /// null = "All Types".
  final Rxn<MaintenanceType> typeFilter = Rxn<MaintenanceType>();
  final Rxn<DateTime> fromDate = Rxn<DateTime>();
  final Rxn<DateTime> toDate = Rxn<DateTime>();

  /// Call inside an `Obx`.
  List<MaintenanceLogModel> get filteredLogs {
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    return logs
        .where((l) => typeFilter.value == null || l.type == typeFilter.value)
        .where((l) => fromDate.value == null || !day(l.date).isBefore(day(fromDate.value!)))
        .where((l) => toDate.value == null || !day(l.date).isAfter(day(toDate.value!)))
        .toList();
  }

  double get totalCost => logs.fold(0.0, (sum, l) => sum + l.cost);
}
