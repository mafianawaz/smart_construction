import 'package:get/get.dart';

import 'data/ai_agents_mock_data.dart';
import 'models/ai_agent_models.dart';


/// Controller for the AI Agents hub.
///
/// Uses GetBuilder + update() on plain fields (same pattern as PricingLogic).
/// Create it with `GetBuilder<AiAgentsLogic>(init: AiAgentsLogic(), ...)`.
class AiAgentsLogic extends GetxController {
  AiAgentsOverview? overview;
  AiAgentsTab selectedTab = AiAgentsTab.digest;
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading = true;
    update();
    overview = await  AiAgentsMockData.fetchOverview();
    isLoading = false;
    update();
  }

  // ── derived state ──────────────────────────────────────────────────────

  bool get hasEnabledAgents => overview?.hasEnabledAgents ?? false;
  int get reviewCount => overview?.pendingReviews ?? 0;
  int get flagCount => overview?.openFlags ?? 0;

  // ── actions ────────────────────────────────────────────────────────────

  void selectTab(AiAgentsTab tab) {
    if (selectedTab == tab) return;
    selectedTab = tab;
    update();
  }

  void openFlags() => selectTab(AiAgentsTab.flags);
  void openReviewQueue() => selectTab(AiAgentsTab.reviewQueue);

  /// Opens AI Agents Settings (G-06).
  void openAgentSettings() {
    Get.snackbar('AI Agents Settings', 'Settings screen (G-06) is not built yet.');
  }
}
