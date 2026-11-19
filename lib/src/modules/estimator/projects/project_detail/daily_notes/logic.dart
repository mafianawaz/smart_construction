import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/project_enums.dart';
import '../../models/quality_models.dart';
import '../../models/scope_models.dart';

/// Owns the Daily Notes tab. Notes live in `ProjectWorkStore` so they
/// survive tab switches. Put with `tag: projectId`.
class DailyNotesLogic extends GetxController {
  final String projectId;
  DailyNotesLogic(this.projectId);

  final notesCtrl = TextEditingController();

  /// "Materials Usage Tracking" — optionally ties the entry to a scope item.
  /// The reference shows only the closed dropdown, so listing the project's
  /// scope items is a guess (flagged in the notes file).
  final Rxn<ScopeItemModel> materialItem = Rxn<ScopeItemModel>();

  final filter = DailyNoteFilter.all.obs;
  void setFilter(DailyNoteFilter f) => filter.value = f;

  RxList<DailyNoteModel> get notes => ProjectWorkStore.to.dailyNotes(projectId);

  List<ScopeItemModel> get scopeItems => ProjectWorkStore.to.scopeItems(projectId).toList();

  /// Newest first. Reads [notes] and [filter] — call inside an `Obx`.
  List<DailyNoteModel> get filteredNotes {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfWeek = startOfToday.subtract(Duration(days: now.weekday - 1));
    final list = notes.where((n) {
      switch (filter.value) {
        case DailyNoteFilter.all:
          return true;
        case DailyNoteFilter.today:
          return !n.createdAt.isBefore(startOfToday);
        case DailyNoteFilter.thisWeek:
          return !n.createdAt.isBefore(startOfWeek);
        case DailyNoteFilter.withMaterials:
          return n.materialScopeItem != null;
      }
    }).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  // API: POST /projects/{id}/daily-notes
  void addEntry() {
    final text = notesCtrl.text.trim();
    if (text.isEmpty) {
      Get.snackbar('Nothing to add', "Write today's progress, issues or updates first.");
      return;
    }
    notes.insert(
      0,
      DailyNoteModel(
        id: 'dn_${DateTime.now().microsecondsSinceEpoch}',
        text: text,
        materialScopeItem: materialItem.value?.name,
        createdAt: DateTime.now(),
      ),
    );
    notesCtrl.clear();
    materialItem.value = null;
  }

  @override
  void onClose() {
    notesCtrl.dispose();
    super.onClose();
  }
}
