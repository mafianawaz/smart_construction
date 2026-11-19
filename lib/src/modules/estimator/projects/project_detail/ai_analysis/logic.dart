import 'package:get/get.dart';

import '../../models/project_enums.dart';

/// Owns the AI Jobs Analysis tab: the four stat counters and which
/// section of the segmented strip is showing. The references show every
/// counter at 0 and every section empty, so there is no analysis model
/// yet. Put with `tag: projectId`.
class AiAnalysisLogic extends GetxController {
  final String projectId;
  AiAnalysisLogic(this.projectId);

  final section = AiAnalysisSection.overview.obs;
  void onSectionChange(AiAnalysisSection s) => section.value = s;

  // API: GET /projects/{id}/ai-analysis/summary
  final photosAnalyzed = 0.obs;
  final criticalIssues = 0.obs;
  final pendingReview = 0.obs;
  final analysisBatches = 0.obs;

  // API: POST /projects/{id}/ai-analysis/run
  void runAnalysis() {
    Get.snackbar('Run analysis', 'AI analysis is not wired up yet.');
  }
}
