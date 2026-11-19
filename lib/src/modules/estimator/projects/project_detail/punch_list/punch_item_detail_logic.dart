import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';
import 'punch_item_form_view.dart';

/// Owns the Punch Item detail screen. Reads the item from the store by id
/// so edits made in the form show up here when it pops. Short-lived, no
/// `tag`.
class PunchItemDetailLogic extends GetxController {
  final String projectId;
  final String itemId;
  PunchItemDetailLogic(this.projectId, this.itemId);

  final notesCtrl = TextEditingController();

  RxList<PunchItemModel> get _list => ProjectWorkStore.to.punchItems(projectId);

  /// Null if the item was deleted. Call inside an `Obx`.
  PunchItemModel? get item => _list.firstWhereOrNull((i) => i.id == itemId);

  @override
  void onInit() {
    super.onInit();
    notesCtrl.text = item?.updateNotes ?? '';
  }

  void _update(PunchItemModel Function(PunchItemModel) change) {
    final i = _list.indexWhere((x) => x.id == itemId);
    if (i != -1) _list[i] = change(_list[i]);
  }

  // API: PATCH /projects/{id}/punch-items/{itemId} { updateNotes }
  void onNotesChanged(String v) => _update((i) => i.copyWith(updateNotes: v));

  // API: PATCH /projects/{id}/punch-items/{itemId} { status }
  void setStatus(PunchStatus s) => _update((i) => i.copyWith(status: s));

  // API: POST /projects/{id}/punch-items/{itemId}/attachments
  // No file-picker package is confirmed in the app yet — see the notes file.
  void addPhotoOrFile() {
    Get.snackbar('Add Photo / File', 'File picker is not wired up yet.');
  }

  void edit() {
    final i = item;
    if (i == null) return;
    Get.to(() => PunchItemFormView(projectId: projectId, existing: i),
        routeName: '/punch-list/edit');
  }

  @override
  void onClose() {
    notesCtrl.dispose();
    super.onClose();
  }
}
