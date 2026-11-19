import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';

/// Owns the Labor tab: the Filters & Sorting card drives the Labor Hours
/// list. The two rate cards (Project Default Labor Rates / Employee Rate
/// Overrides) only have empty-state references so they hold no state yet.
/// Put with `tag: projectId`.
class LaborHoursLogic extends GetxController {
  final String projectId;
  LaborHoursLogic(this.projectId);

  RxList<LaborEntryModel> get entries => ProjectWorkStore.to.laborEntries(projectId);

  /// null = "All Trades" / "All Statuses".
  final Rxn<ProjectTrade> trade = Rxn<ProjectTrade>();
  final Rxn<TimeApprovalStatus> approval = Rxn<TimeApprovalStatus>();
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();
  final employeeQuery = ''.obs;
  final sort = LaborSort.dateNewest.obs;

  void onEmployeeSearch(q) => employeeQuery.value = q.trim().toLowerCase();

  bool get hasActiveFilters =>
      trade.value != null ||
      approval.value != null ||
      startDate.value != null ||
      endDate.value != null ||
      employeeQuery.value.isNotEmpty;

  /// Call inside an `Obx`.
  List<LaborEntryModel> get filteredEntries {
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    final list = entries
        .where((e) => trade.value == null || e.trade == trade.value)
        .where((e) => approval.value == null || e.status == approval.value)
        .where((e) => startDate.value == null || !day(e.date).isBefore(day(startDate.value!)))
        .where((e) => endDate.value == null || !day(e.date).isAfter(day(endDate.value!)))
        .where((e) =>
            employeeQuery.value.isEmpty || e.employee.toLowerCase().contains(employeeQuery.value))
        .toList();
    switch (sort.value) {
      case LaborSort.dateNewest:
        list.sort((a, b) => b.date.compareTo(a.date));
        break;
      case LaborSort.dateOldest:
        list.sort((a, b) => a.date.compareTo(b.date));
        break;
      case LaborSort.hoursHighest:
        list.sort((a, b) => b.hours.compareTo(a.hours));
        break;
      case LaborSort.employee:
        list.sort((a, b) => a.employee.toLowerCase().compareTo(b.employee.toLowerCase()));
        break;
    }
    return list;
  }

  void clearFilters() {
    trade.value = null;
    approval.value = null;
    startDate.value = null;
    endDate.value = null;
    employeeQuery.value = '';
  }
}
