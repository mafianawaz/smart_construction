import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';
import 'create_rfi_view.dart';

/// Owns the RFIs tab: the list and its two filter pills. RFIs live in
/// `ProjectWorkStore` so the Create RFI form and the list stay in sync.
/// Put with `tag: projectId`.
class RfisLogic extends GetxController {
  final String projectId;
  RfisLogic(this.projectId);

  RxList<RfiModel> get rfis => ProjectWorkStore.to.rfis(projectId);

  /// null = "All Status" / "All Priority".
  final Rxn<RfiStatus> statusFilter = Rxn<RfiStatus>();
  final Rxn<PunchPriority> priorityFilter = Rxn<PunchPriority>();

  /// Call inside an `Obx`.
  List<RfiModel> get filteredRfis => rfis
      .where((r) => statusFilter.value == null || r.status == statusFilter.value)
      .where((r) => priorityFilter.value == null || r.priority == priorityFilter.value)
      .toList();

  void openCreate() => Get.to(
        () => CreateRfiView(projectId: projectId),
        routeName: '/rfis/create',
      );
}
