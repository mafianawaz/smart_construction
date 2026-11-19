import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/delay_model.dart';
import '../../models/project_enums.dart';

/// Owns the Delays tab. Put with `tag: projectId`.
class DelaysLogic extends GetxController {
  final String projectId;
  DelaysLogic(this.projectId);

  final delays = <DelayModel>[].obs;

  /// null = "All Statuses" / "All Reason".
  final Rxn<DelayStatus> statusFilter = Rxn<DelayStatus>();
  final Rxn<DelayReason> reasonFilter = Rxn<DelayReason>();

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/delays
    delays.assignAll(ProjectsMockData.delays(projectId));
  }

  void setStatusFilter(DelayStatus? s) => statusFilter.value = s;
  void setReasonFilter(DelayReason? r) => reasonFilter.value = r;

  /// Reads [delays] and both filters — call inside an `Obx`.
  List<DelayModel> get filteredDelays => delays
      .where((d) => statusFilter.value == null || d.status == statusFilter.value)
      .where((d) => reasonFilter.value == null || d.reason == reasonFilter.value)
      .toList();
}
