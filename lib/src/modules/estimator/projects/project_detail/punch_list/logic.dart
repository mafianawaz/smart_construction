import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';
import 'punch_item_detail_view.dart';
import 'punch_item_form_view.dart';

/// Owns the Punch List tab: search, the three filter pills and the list.
/// Items live in `ProjectWorkStore` so the Add / Edit form and the detail
/// screen stay in sync and survive tab switches. Put with `tag: projectId`.
class PunchListLogic extends GetxController {
  final String projectId;
  PunchListLogic(this.projectId);

  RxList<PunchItemModel> get items => ProjectWorkStore.to.punchItems(projectId);

  final searchQuery = ''.obs;

  /// null = "All Statuses" / "All Trades" / "All Priority".
  final Rxn<PunchStatus> statusFilter = Rxn<PunchStatus>();
  final Rxn<ProjectTrade> tradeFilter = Rxn<ProjectTrade>();
  final Rxn<PunchPriority> priorityFilter = Rxn<PunchPriority>();

  void onSearch(query) => searchQuery.value = query.trim().toLowerCase();

  /// Matches title, number or location. Call inside an `Obx`.
  List<PunchItemModel> get filteredItems => items
      .where((i) => statusFilter.value == null || i.status == statusFilter.value)
      .where((i) => tradeFilter.value == null || i.trade == tradeFilter.value)
      .where((i) => priorityFilter.value == null || i.priority == priorityFilter.value)
      .where((i) =>
          searchQuery.value.isEmpty ||
          i.title.toLowerCase().contains(searchQuery.value) ||
          i.number.toLowerCase().contains(searchQuery.value) ||
          (i.location ?? '').toLowerCase().contains(searchQuery.value))
      .toList();

  void openAdd() => Get.to(
        () => PunchItemFormView(projectId: projectId),
        routeName: '/punch-list/add',
      );

  void openEdit(PunchItemModel item) => Get.to(
        () => PunchItemFormView(projectId: projectId, existing: item),
        routeName: '/punch-list/edit',
      );

  void openDetail(PunchItemModel item) => Get.to(
        () => PunchItemDetailView(projectId: projectId, itemId: item.id),
        routeName: '/punch-list/detail',
      );

  // API: DELETE /projects/{id}/punch-items/{itemId}
  void delete(PunchItemModel item) => items.removeWhere((i) => i.id == item.id);

  // API: GET /projects/{id}/punch-items/export.pdf
  void exportPdf() {
    Get.snackbar('Export PDF', 'PDF export is not wired up yet.');
  }
}
