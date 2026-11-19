import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/project_enums.dart';
import '../../models/takeoff_models.dart';

/// Owns the Field Takeoff tab (Field View / Location Breakdown).
/// Put with `tag: projectId`.
class FieldTakeoffLogic extends GetxController {
  final String projectId;
  FieldTakeoffLogic(this.projectId);

  final subTab = FieldTakeoffSubTab.fieldView.obs;
  onSubTabChange(FieldTakeoffSubTab t) => subTab.value = t;

  final items = <TakeoffItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/takeoff/field-items
    items.assignAll(ProjectsMockData.fieldTakeoffItems(projectId));
  }

  /// Items grouped by location, in first-seen order. Reads [items] — call
  /// inside an `Obx`.
  Map<String, List<TakeoffItemModel>> get itemsByLocation {
    final grouped = <String, List<TakeoffItemModel>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.location, () => []).add(item);
    }
    return grouped;
  }
}
