import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';
import 'log_warranty_case_view.dart';

/// Owns the Warranty tab: cases (in `ProjectWorkStore`) and the three
/// filter pills. Put with `tag: projectId`.
class WarrantyLogic extends GetxController {
  final String projectId;
  WarrantyLogic(this.projectId);

  RxList<WarrantyCaseModel> get cases => ProjectWorkStore.to.warrantyCases(projectId);

  /// null = "All Status" / "All Types" / "All Priority".
  final Rxn<WarrantyStatus> statusFilter = Rxn<WarrantyStatus>();
  final Rxn<WarrantyType> typeFilter = Rxn<WarrantyType>();
  final Rxn<PunchPriority> priorityFilter = Rxn<PunchPriority>();

  /// Call inside an `Obx`.
  List<WarrantyCaseModel> get filtered => cases
      .where((c) => statusFilter.value == null || c.status == statusFilter.value)
      .where((c) => typeFilter.value == null || c.type == typeFilter.value)
      .where((c) => priorityFilter.value == null || c.priority == priorityFilter.value)
      .toList();

  void openLogCase() => Get.to(
        () => LogWarrantyCaseView(projectId: projectId),
        routeName: '/warranty/log-case',
      );

  // API: GET /projects/{id}/warranty-cases/export
  void export() {
    Get.snackbar('Export', 'Warranty case export is not wired up yet.');
  }
}
