import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';
import 'create_submittal_view.dart';

/// Owns the Submittals tab: the All / Pending / Overdue strip, the two
/// filter pills and the list. Put with `tag: projectId`.
class SubmittalsLogic extends GetxController {
  final String projectId;
  SubmittalsLogic(this.projectId);

  RxList<SubmittalModel> get submittals => ProjectWorkStore.to.submittals(projectId);

  final view = SubmittalView.all.obs;
  void onViewChange(SubmittalView v) => view.value = v;

  /// null = "All Status" / "All Phase".
  final Rxn<SubmittalStatus> statusFilter = Rxn<SubmittalStatus>();
  final Rxn<SubmittalPhase> phaseFilter = Rxn<SubmittalPhase>();

  /// Call inside an `Obx`.
  List<SubmittalModel> get filtered => submittals
      .where((s) {
        switch (view.value) {
          case SubmittalView.all:
            return true;
          case SubmittalView.pending:
            return s.status == SubmittalStatus.pending || s.status == SubmittalStatus.underReview;
          case SubmittalView.overdue:
            return s.isOverdue;
        }
      })
      .where((s) => statusFilter.value == null || s.status == statusFilter.value)
      .where((s) => phaseFilter.value == null || s.phase == phaseFilter.value)
      .toList();

  void openCreate() => Get.to(
        () => CreateSubmittalView(projectId: projectId),
        routeName: '/submittals/create',
      );
}
