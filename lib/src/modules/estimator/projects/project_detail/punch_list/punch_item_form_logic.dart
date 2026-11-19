import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/field_ops_mock_data.dart';
import '../../data/project_work_store.dart';
import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';

/// Owns the shared Add / Edit Punch Item form. Short-lived, no `tag`.
/// Pass [existing] to edit; resubmitting keeps the item's id, number,
/// status, notes and attachments.
class PunchItemFormLogic extends GetxController {
  final String projectId;
  final PunchItemModel? existing;
  PunchItemFormLogic(this.projectId, {this.existing});

  bool get isEditing => existing != null;

  final titleCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final assigneeNameCtrl = TextEditingController();
  final assigneeEmailCtrl = TextEditingController();

  final Rx<ProjectTrade> trade = ProjectTrade.general.obs;
  final Rx<PunchPriority> priority = PunchPriority.medium.obs;
  final Rxn<String> teamMember = Rxn<String>();
  final Rxn<DateTime> dueDate = Rxn<DateTime>();
  final isSaving = false.obs;

  List<String> get teamMemberOptions => FieldOpsMockData.teamMembers;

  @override
  void onInit() {
    super.onInit();
    final e = existing;
    if (e == null) return;
    titleCtrl.text = e.title;
    descriptionCtrl.text = e.description ?? '';
    locationCtrl.text = e.location ?? '';
    assigneeNameCtrl.text = e.assigneeName ?? '';
    assigneeEmailCtrl.text = e.assigneeEmail ?? '';
    trade.value = e.trade;
    priority.value = e.priority;
    dueDate.value = e.dueDate;
  }

  String? _clean(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  /// Picking a team member fills the manual name field if it is empty, so
  /// the item always has a readable assignee.
  void onTeamMemberChanged(String? v) {
    teamMember.value = v;
    if (v != null && v != 'Unassigned' && assigneeNameCtrl.text.trim().isEmpty) {
      assigneeNameCtrl.text = v;
    }
  }

  // API: POST /projects/{id}/punch-items  |  PATCH /projects/{id}/punch-items/{itemId}
  Future<bool> save() async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar('Missing title', 'Give this punch item a title first.');
      return false;
    }
    isSaving.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      final list = ProjectWorkStore.to.punchItems(projectId);
      final e = existing;
      final item = PunchItemModel(
        id: e?.id ?? 'punch_${DateTime.now().microsecondsSinceEpoch}',
        number: e?.number ?? 'PLI-${(list.length + 1).toString().padLeft(4, '0')}',
        title: titleCtrl.text.trim(),
        description: _clean(descriptionCtrl),
        location: _clean(locationCtrl),
        trade: trade.value,
        priority: priority.value,
        status: e?.status ?? PunchStatus.open,
        assigneeName: _clean(assigneeNameCtrl),
        assigneeEmail: _clean(assigneeEmailCtrl),
        dueDate: dueDate.value,
        createdAt: e?.createdAt ?? DateTime.now(),
        updateNotes: e?.updateNotes ?? '',
        attachmentCount: e?.attachmentCount ?? 0,
      );
      if (e == null) {
        list.insert(0, item);
      } else {
        final i = list.indexWhere((x) => x.id == e.id);
        if (i != -1) list[i] = item;
      }
      return true;
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    for (final c in [
      titleCtrl,
      descriptionCtrl,
      locationCtrl,
      assigneeNameCtrl,
      assigneeEmailCtrl,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
