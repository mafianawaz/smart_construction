import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_enums.dart';
import '../../models/scope_models.dart';
import 'create_scope_item_view.dart';

/// Owns the Scope & Progress tab's UI state (search + filters). The items
/// themselves live in `ProjectWorkStore` so Materials can read them.
/// Put with `tag: projectId`.
class ScopeProgressLogic extends GetxController {
  final String projectId;
  ScopeProgressLogic(this.projectId);

  RxList<ScopeItemModel> get items => ProjectWorkStore.to.scopeItems(projectId);

  final searchQuery = ''.obs;

  /// null = "All Statuses" / "All Units".
  final Rxn<ScopeItemStatus> statusFilter = Rxn<ScopeItemStatus>();
  final Rxn<String> unitFilter = Rxn<String>();

  void onSearch(query) => searchQuery.value = query.trim().toLowerCase();
  void setStatusFilter(ScopeItemStatus? s) => statusFilter.value = s;
  void setUnitFilter(String? u) => unitFilter.value = u;

  /// Reads [items], the search and both filters — call inside an `Obx`.
  List<ScopeItemModel> get filteredItems => items
      .where((i) => statusFilter.value == null || i.status == statusFilter.value)
      .where((i) => unitFilter.value == null || i.unit == unitFilter.value)
      .where((i) => searchQuery.value.isEmpty || i.name.toLowerCase().contains(searchQuery.value))
      .toList();

  void openCreate() => Get.to(
        () => CreateScopeItemView(projectId: projectId),
        routeName: '/scope/create',
      );
}
