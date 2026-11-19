import 'package:get/get.dart';
import 'data/analytics_mock_data.dart';
import 'models/analytics_models.dart';


/// Controller for [AnalyticsView]. Loads the summary counts and the two
/// preview lists (recent pricing submissions, enrolled clients).
class AnalyticsLogic extends GetxController {
  final Rx<AnalyticsSummaryModel> summary = const AnalyticsSummaryModel.empty().obs;
  final RxList<AnalyticsPricingSubmission> recentSubmissions = <AnalyticsPricingSubmission>[].obs;
  final RxInt totalSubmissionCount = 0.obs;
  final RxList<AnalyticsClientPreview> enrolledClients = <AnalyticsClientPreview>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    summary.value = AnalyticsMockData.populatedSummary();
    recentSubmissions.assignAll(AnalyticsMockData.recentPricingSubmissions());
    totalSubmissionCount.value = AnalyticsMockData.totalPricingSubmissionCount();
    enrolledClients.assignAll(AnalyticsMockData.enrolledClientsPreview());
  }

  bool get hasPricingSubmissions => recentSubmissions.isNotEmpty;
  bool get hasEnrolledClients => enrolledClients.isNotEmpty;

  /// Flips a client's auto-approve toggle from the dashboard preview.
  // TODO(api): PATCH /api/vendor/enrolled-clients/{id}  { auto_approve }
  void toggleAutoApprove(AnalyticsClientPreview client, bool value) {
    final index = enrolledClients.indexOf(client);
    if (index == -1) return;
    enrolledClients[index] = AnalyticsClientPreview(
      id: client.id,
      organizationName: client.organizationName,
      projectName: client.projectName,
      autoApprove: value,
      isActive: client.isActive,
    );
  }
}
