import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/project_enums.dart';
import '../../models/risk_model.dart';
import 'add_risk_view.dart';

enum RiskViewMode { register, heatMap }

/// Owns the Risk Register + Heat Map for one project. Put with
/// `tag: project.id`.
class RiskRegisterLogic extends GetxController {
  final String projectId;
  RiskRegisterLogic(this.projectId);

  final viewMode = 0.obs;
  onViewModeChange(mode) => viewMode.value = mode;

  final risks = <RiskModel>[].obs;

  final Rx<RiskCategory?> categoryFilter = Rx<RiskCategory?>(null);
  final Rx<RiskStatus?> statusFilter = Rx<RiskStatus?>(null);
  final Rx<RiskSeverityBand?> severityFilter = Rx<RiskSeverityBand?>(null);

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/risks
    risks.assignAll(ProjectsMockData.risks(projectId));
  }

  void setCategoryFilter(RiskCategory? c) => categoryFilter.value = c;
  void setStatusFilter(RiskStatus? s) => statusFilter.value = s;
  void setSeverityFilter(RiskSeverityBand? s) => severityFilter.value = s;

  List<RiskModel> get filteredRisks => risks
      .where((r) => r.matchesFilters(
            category: categoryFilter.value,
            status: statusFilter.value,
            severity: severityFilter.value,
          ))
      .toList();

  /// Open risks only, as the Heat Map's subtitle says.
  List<RiskModel> get openRisksForMatrix =>
      risks.where((r) => r.status != RiskStatus.closed).toList();

  Future<void> addRisk() async {
    final created = await Get.to<RiskModel>(() => const AddRiskView(), routeName: '/risks/add');
    if (created != null) risks.insert(0, created);
  }
}
