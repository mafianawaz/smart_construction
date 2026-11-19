import 'package:get/get.dart';

import '../../data/project_work_store.dart';
import '../../models/portal_models.dart';

/// Owns the Project Vault tab: search, category + date-range filters and
/// the document list. Documents live in `ProjectWorkStore`. Put with
/// `tag: projectId`.
class ProjectVaultLogic extends GetxController {
  final String projectId;
  ProjectVaultLogic(this.projectId);

  RxList<VaultDocumentModel> get documents => ProjectWorkStore.to.vaultDocuments(projectId);

  final searchQuery = ''.obs;

  /// null = "All Categories".
  final Rxn<String> category = Rxn<String>();
  final Rxn<DateTime> startDate = Rxn<DateTime>();
  final Rxn<DateTime> endDate = Rxn<DateTime>();

  void onSearch(q) => searchQuery.value = q.trim().toLowerCase();

  /// Call inside an `Obx`.
  List<VaultDocumentModel> get filtered {
    DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
    return documents
        .where((d) => category.value == null || d.category == category.value)
        .where((d) => searchQuery.value.isEmpty || d.name.toLowerCase().contains(searchQuery.value))
        .where((d) => startDate.value == null || !day(d.uploadedAt).isBefore(day(startDate.value!)))
        .where((d) => endDate.value == null || !day(d.uploadedAt).isAfter(day(endDate.value!)))
        .toList();
  }

  // API: GET /projects/{id}/vault/export?format=zip|pdf&category&start&end
  void export() {
    if (filtered.isEmpty) {
      Get.snackbar('Nothing to export', 'There are no documents in the vault yet.');
      return;
    }
    Get.snackbar('Export PDF/ZIP', 'Vault export is not wired up yet.');
  }

  // API: GET /projects/{id}/vault/documents/{docId}/download
  void open(VaultDocumentModel doc) {
    Get.snackbar('Open', 'Document download is not wired up yet.');
  }
}
