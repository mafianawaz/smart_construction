import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../data/projects_mock_data.dart';
import '../../models/estimate_models.dart';
import '../../models/project_enums.dart';
import 'add_line_item_view.dart';
import 'import_takeoff_view.dart';
import 'markup_overrides_view.dart';

/// Owns the Estimate tab. Line items, markup overrides and the Draft /
/// Approved status live in `ProjectWorkStore` so the pushed forms and this
/// tab stay in sync. Put with `tag: projectId`.
class EstimateLogic extends GetxController {
  final String projectId;
  EstimateLogic(this.projectId);

  ProjectWorkStore get _store => ProjectWorkStore.to;

  RxList<EstimateLineItemModel> get items => _store.estimateLines(projectId);
  Rx<EstimateStatus> get status => _store.estimateStatus(projectId);

  /// Override for this estimate if set, otherwise the org default.
  double effectivePercent(MarkupKind kind) =>
      _store.markupOverrides(projectId)[kind] ?? ProjectsMockData.orgMarkupDefaults[kind] ?? 0;

  /// Reads the line items and overrides — call inside an `Obx`.
  EstimateTotals get totals => EstimateCalculator.compute(items.toList(), effectivePercent);

  void openMarkups() => Get.to(
        () => MarkupOverridesView(projectId: projectId),
        routeName: '/estimate/markups',
      );

  void openImportTakeoff() => Get.to(
        () => ImportTakeoffView(projectId: projectId),
        routeName: '/estimate/import-takeoff',
      );

  void openAddLineItem() => Get.to(
        () => AddLineItemView(projectId: projectId),
        routeName: '/estimate/add-line-item',
      );

  void removeLineItem(EstimateLineItemModel item) => items.remove(item);

  // API: POST /projects/{id}/estimate/approve  (also syncs to the budget)
  void approveAndSync() {
    if (items.isEmpty) {
      Get.snackbar('Nothing to sync', 'Add line items to the estimate first.');
      return;
    }
    status.value = EstimateStatus.approved;
    Get.snackbar('Estimate approved', 'The estimate was synced to the project budget.');
  }

  // API: GET /projects/{id}/estimate/export?format=pdf
  void exportPdf() => Get.snackbar('PDF', 'Estimate export is not wired up yet.');

  // API: GET /projects/{id}/estimate/export?format=xlsx
  void exportExcel() => Get.snackbar('Excel', 'Estimate export is not wired up yet.');

  void showOrgDefaults() =>
      Get.snackbar('Org defaults', 'Organization estimating defaults are not wired up yet.');
}
