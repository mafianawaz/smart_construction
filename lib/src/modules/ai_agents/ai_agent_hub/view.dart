import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'logic.dart';
import 'models/ai_agent_models.dart';
import 'widgets/agent_card.dart';
import 'widgets/ai_agents_empty_hub.dart';
import 'widgets/ai_agents_header.dart';
import 'widgets/ai_agents_palette.dart';
import 'widgets/ai_agents_tab_pills.dart';
import 'widgets/ai_info_banner.dart';
import 'widgets/ai_tab_placeholder.dart';
import 'widgets/orchestrator_card.dart';
import 'widgets/schedule_health_section.dart';

/// AI Agents hub.
///
/// Tabs: Today's digest (built) · Review queue · Flags (placeholders).
/// Digest states:
///  - no agents enabled  → empty hub with an "Enable agents" CTA
///  - agent locked       → its card shows progress toward the data threshold
class AiAgentsHubView extends StatelessWidget {
  const AiAgentsHubView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiAgentsLogic>(
      init: AiAgentsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: AppPrimaryBar(
            title: 'AI Agent Hub',
            showBackButton: true,
            centerTitle: true,
          ),
          body: logic.isLoading || logic.overview == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AiAgentsPalette.primary,
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(15),
                  children: [
                    AiAgentsHeader(onHomeTap: () => Get.back()),
                    const SizedBox(height: 14),
                    AiAgentsTabPills(
                      selected: logic.selectedTab,
                      reviewCount: logic.reviewCount,
                      flagCount: logic.flagCount,
                      onChanged: logic.selectTab,
                    ),
                    const SizedBox(height: 14),
                    ..._tabBody(logic),
                  ],
                ),
        );
      },
    );
  }

  List<Widget> _tabBody(AiAgentsLogic logic) {
    switch (logic.selectedTab) {
      case AiAgentsTab.digest:
        return _digest(logic);
      case AiAgentsTab.reviewQueue:
        return [
          AiTabPlaceholder(
            title: 'Review queue',
            message: '${logic.reviewCount} items are waiting for review. '
                'This tab is not designed yet.',
          ),
        ];
      case AiAgentsTab.flags:
        return [
          AiTabPlaceholder(
            title: 'Flags',
            message: '${logic.flagCount} open flags. '
                'This tab is not designed yet.',
          ),
        ];
    }
  }

  List<Widget> _digest(AiAgentsLogic logic) {
    final overview = logic.overview!;

    if (!logic.hasEnabledAgents) {
      return [AiAgentsEmptyHub(onEnableTap: logic.openAgentSettings)];
    }

    return [
      AiInfoBanner(message: overview.accuracyNote),
      const SizedBox(height: 12),
      OrchestratorCard(
        orchestrator: overview.orchestrator,
        pendingReviews: overview.pendingReviews,
        onDigestTap: () => logic.selectTab(AiAgentsTab.digest),
        onFlagsTap: logic.openFlags,
        onReviewQueueTap: logic.openReviewQueue,
      ),
      for (final agent in overview.agents) ...[
        const SizedBox(height: 12),
        AgentCard(agent: agent, onEnableTap: logic.openAgentSettings),
      ],
      const SizedBox(height: 20),
      ScheduleHealthSection(projects: overview.projects),
    ];
  }
}
