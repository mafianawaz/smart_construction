import 'package:get/get.dart';
import 'data/reports_mock_data.dart';
import 'models/report_models.dart';


/// Plain-field + `update()` controller (matches PricingLogic's GetBuilder pattern).
class ReportsLogic extends GetxController {
  final List<ReportType> reports = ReportsMockData.reportTypes;
  final List<ReportProject> projects = ReportsMockData.fetchProjects();

  late ReportType selected = reports.first;
  ReportFilters filters = const ReportFilters();
  ReportTableModel? table;

  final Set<ReportGroup> collapsedGroups = {};

  List<ReportType> reportsIn(ReportGroup group) =>
      reports.where((r) => r.group == group).toList();

  bool isExpanded(ReportGroup group) => !collapsedGroups.contains(group);

  String? get selectedProjectName {
    for (final p in projects) {
      if (p.id == filters.projectId) return p.name;
    }
    return null;
  }

  void toggleGroup(ReportGroup group) {
    if (!collapsedGroups.remove(group)) collapsedGroups.add(group);
    update();
  }

  /// "Expand" chip: expands every group, or collapses all when already open.
  void toggleExpandAll() {
    if (collapsedGroups.isEmpty) {
      collapsedGroups.addAll(ReportGroup.values);
    } else {
      collapsedGroups.clear();
    }
    update();
  }

  void selectReport(ReportType report) {
    selected = report;
    _reload();
  }

  void applyFilters(ReportFilters next) {
    filters = next;
    _reload();
  }

  void reset() {
    filters = const ReportFilters();
    collapsedGroups.clear();
    _reload();
  }

  void printReport() {
    Get.snackbar('Print', table == null
        ? 'Select a project to generate this report first.'
        : 'Printing "${selected.label}" is not wired up yet.');
  }

  void exportReport() {
    Get.snackbar('Export', table == null
        ? 'Select a project to generate this report first.'
        : 'Export for "${selected.label}" is not wired up yet.');
  }

  void _reload() {
    table = ReportsMockData.fetchReport(selected, filters);
    update();
  }
}
