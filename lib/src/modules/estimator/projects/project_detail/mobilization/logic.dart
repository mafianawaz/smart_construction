import 'package:get/get.dart';

import '../../data/projects_mock_data.dart';
import '../../models/mobilization_model.dart';
import '../../models/project_enums.dart';

/// Owns the Site Mobilization tab (Checklist / Method Statements).
/// Put with `tag: projectId`.
class MobilizationLogic extends GetxController {
  final String projectId;
  MobilizationLogic(this.projectId);

  final subTab = MobilizationSubTab.checklist.obs;
  onSubTabChange(MobilizationSubTab t) => subTab.value = t;

  final checklist = <MobilizationChecklistItem>[].obs;
  final methodStatements = <MethodStatementModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // API: GET /projects/{id}/mobilization/checklist
    checklist.assignAll(ProjectsMockData.mobilizationChecklist(projectId));
    // API: GET /projects/{id}/mobilization/method-statements
    methodStatements.assignAll(ProjectsMockData.methodStatements(projectId));
  }

  // API: PATCH /projects/{id}/mobilization/checklist/{itemId} { isDone }
  void toggleChecklistItem(String id) {
    final i = checklist.indexWhere((c) => c.id == id);
    if (i == -1) return;
    checklist[i] = checklist[i].copyWith(isDone: !checklist[i].isDone);
  }
}
