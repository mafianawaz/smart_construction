import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/materials_models.dart';
import 'record_usage_view.dart';

/// Owns the Materials tab. Budgets come from the scope items
/// (unit price x total quantity), actuals from recorded usage.
/// Put with `tag: projectId`.
class MaterialsLogic extends GetxController {
  final String projectId;
  MaterialsLogic(this.projectId);

  /// Reads the scope items and usage lists — call inside an `Obx`.
  /// Scope items with no unit price have no budget and are left out;
  /// usage recorded against them still shows on their own screen later.
  List<MaterialBudgetRow> get budgetRows {
    final store = ProjectWorkStore.to;
    final usages = store.materialUsages(projectId);
    final rows = <MaterialBudgetRow>[];
    for (final item in store.scopeItems(projectId)) {
      final budget = item.budget;
      if (budget == null || budget <= 0) continue;
      final actual = usages
          .where((u) => u.scopeItemId == item.id)
          .fold<double>(0, (sum, u) => sum + u.cost);
      rows.add(MaterialBudgetRow(scopeItemName: item.name, budget: budget, actual: actual));
    }
    return rows;
  }

  void openRecordUsage() => Get.to(
        () => RecordUsageView(projectId: projectId),
        routeName: '/materials/record-usage',
      );
}
