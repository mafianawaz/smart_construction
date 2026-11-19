import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/project_enums.dart';
import '../../models/takeoff_models.dart';

/// Owns the Plans & Takeoff tab (Plans / Addenda / Drawing Sets /
/// Reports). Put with `tag: projectId`.
class PlansTakeoffLogic extends GetxController {
  final String projectId;
  PlansTakeoffLogic(this.projectId);

  final subTab = PlansSubTab.plans.obs;
  onSubTabChange(PlansSubTab t) => subTab.value = t;

  // ---- Plans ------------------------------------------------------------

  final folders = <DocumentFolderModel>[].obs;

  /// "Plans" starts expanded, matching the reference.
  final expandedFolderIds = <String>{'plans'}.obs;
  final searchQuery = ''.obs;

  // ---- Addenda / Drawing sets --------------------------------------------

  final addenda = <AddendumModel>[].obs;
  final drawingSets = <DrawingSetModel>[].obs;

  // ---- Reports ----------------------------------------------------------

  final reportKind = ReportKind.takeoffQuantity.obs;
  final quantityOptions = <String>[].obs;
  final selectedQuantity = Rxn<String>();
  final reportItems = <TakeoffItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/documents
    folders.assignAll(ProjectsMockData.documentFolders(projectId));
    // API: GET /projects/{id}/addenda
    addenda.assignAll(ProjectsMockData.addenda(projectId));
    // API: GET /projects/{id}/drawing-sets
    drawingSets.assignAll(ProjectsMockData.drawingSets(projectId));
    _loadReport();
  }

  // ---- Plans ------------------------------------------------------------

  int get totalDocuments => folders.fold(0, (sum, f) => sum + f.count);

  void onSearch(value) => searchQuery.value = value.trim().toLowerCase();

  void toggleFolder(String id) {
    if (!expandedFolderIds.remove(id)) expandedFolderIds.add(id);
  }

  /// Folders as shown: unchanged with no search; otherwise only folders
  /// that still have a matching file, trimmed to those files. Reads
  /// [folders] and [searchQuery] — call inside an `Obx`.
  List<DocumentFolderModel> get visibleFolders {
    final q = searchQuery.value;
    if (q.isEmpty) return folders.toList();
    final result = <DocumentFolderModel>[];
    for (final f in folders) {
      final matches = f.files.where((d) => d.name.toLowerCase().contains(q)).toList();
      if (matches.isNotEmpty) result.add(f.copyWith(files: matches));
    }
    return result;
  }

  void uploadDocument() {
    Get.snackbar('Upload', 'Document upload is not wired up yet.');
  }

  void openTakeoffWebView() {
    Get.snackbar('Takeoff', 'Web view is not wired up yet.');
  }

  // ---- Reports ----------------------------------------------------------

  void setReportKind(ReportKind kind) {
    reportKind.value = kind;
    _loadReport();
  }

  void setQuantity(String? value) => selectedQuantity.value = value;

  // API: GET /projects/{id}/takeoff/reports/{kind}
  void _loadReport() {
    selectedQuantity.value = null;
    quantityOptions.assignAll(ProjectsMockData.reportQuantityOptions(projectId, reportKind.value));
    reportItems.assignAll(ProjectsMockData.reportItems(projectId, reportKind.value));
  }

  // API: GET /projects/{id}/takeoff/reports/{kind}/export
  void exportReport() {
    Get.snackbar('Export', 'Report export is not wired up yet.');
  }
}
