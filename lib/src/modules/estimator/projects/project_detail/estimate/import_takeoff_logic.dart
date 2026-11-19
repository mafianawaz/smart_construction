import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../data/projects_mock_data.dart';
import '../../models/estimate_models.dart';
import '../../models/takeoff_models.dart';

/// Owns "Import Takeoff Quantities": pick takeoff categories, generate one
/// estimate line item per category. Short-lived, no `tag`.
class ImportTakeoffLogic extends GetxController {
  final String projectId;
  ImportTakeoffLogic(this.projectId);

  final categories = <TakeoffCategoryModel>[].obs;
  final selectedIds = <String>{}.obs;
  final isImporting = false.obs;

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/takeoff/categories
    categories.assignAll(ProjectsMockData.takeoffCategories(projectId));
  }

  void toggle(String id) {
    if (!selectedIds.remove(id)) selectedIds.add(id);
  }

  /// Drives the "Import N Categories" label.
  int get selectedCount => selectedIds.length;

  // API: POST /projects/{id}/estimate/import-takeoff { categoryIds }
  Future<void> importSelected() async {
    if (selectedIds.isEmpty) {
      Get.snackbar('Nothing selected', 'Select at least one takeoff category to import.');
      return;
    }
    isImporting.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      final lines = ProjectWorkStore.to.estimateLines(projectId);
      final picked = categories.where((c) => selectedIds.contains(c.id)).toList();
      for (final c in picked) {
        lines.add(EstimateLineItemModel(
          id: 'line_${DateTime.now().microsecondsSinceEpoch}_${c.id}',
          description: c.name,
          unit: c.unit,
          quantity: c.quantity,
        ));
      }
      Get.back();
      Get.snackbar('Takeoff imported',
          '${picked.length} line ${picked.length == 1 ? 'item' : 'items'} added to the estimate.');
    } finally {
      isImporting.value = false;
    }
  }
}
