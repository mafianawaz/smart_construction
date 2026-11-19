import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';
import 'create_transmittal_view.dart';

/// Owns the Document Transmittals tab: list plus the "All Status" pill.
/// Put with `tag: projectId`.
class TransmittalsLogic extends GetxController {
  final String projectId;
  TransmittalsLogic(this.projectId);

  RxList<TransmittalModel> get transmittals => ProjectWorkStore.to.transmittals(projectId);

  /// null = "All Status".
  final Rxn<TransmittalStatus> statusFilter = Rxn<TransmittalStatus>();

  /// Call inside an `Obx`.
  List<TransmittalModel> get filtered =>
      transmittals.where((t) => statusFilter.value == null || t.status == statusFilter.value).toList();

  void openCreate() => Get.to(
        () => CreateTransmittalView(projectId: projectId),
        routeName: '/transmittals/create',
      );
}
