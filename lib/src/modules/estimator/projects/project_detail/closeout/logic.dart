import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';

/// Owns the Project Closeout tab: the checklist (in `ProjectWorkStore`),
/// the completion figure and the Checklist Items / Closeout Package
/// strip. Put with `tag: projectId`.
class CloseoutLogic extends GetxController {
  final String projectId;
  CloseoutLogic(this.projectId);

  RxList<CloseoutItemModel> get items => ProjectWorkStore.to.closeoutItems(projectId);

  final section = CloseoutSection.checklistItems.obs;
  void onSectionChange(CloseoutSection s) => section.value = s;

  /// 0-100. Call inside an `Obx`.
  double get completionPercent {
    if (items.isEmpty) return 0;
    final done = items.where((i) => i.status == CloseoutItemStatus.complete).length;
    return done / items.length * 100;
  }

  int get completeCount => items.where((i) => i.status == CloseoutItemStatus.complete).length;

  // API: PATCH /projects/{id}/closeout/items/{itemId} { status }
  void toggleComplete(CloseoutItemModel item) {
    final i = items.indexWhere((x) => x.id == item.id);
    if (i == -1) return;
    final done = item.status == CloseoutItemStatus.complete;
    items[i] = item.copyWith(
      status: done ? CloseoutItemStatus.pending : CloseoutItemStatus.complete,
      signedOffBy: done ? null : 'You',
    );
  }

  // API: POST /projects/{id}/closeout/package
  void generatePackage() {
    Get.snackbar('Closeout package', 'Package generation is not wired up yet.');
  }
}
