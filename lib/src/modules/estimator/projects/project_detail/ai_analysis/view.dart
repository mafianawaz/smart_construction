import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../financials/widgets/panel_card.dart';
import 'logic.dart';

/// AI Jobs Analysis tab — muted subtitle, a 2x2 grid of stat cards
/// (Photos Analyzed / Critical Issues / Pending Review / Analysis
/// Batches), a segmented strip, then the section's panel(s):
///  - Overview: Safety Summary + Material Activity (with "Run analysis")
///  - Safety Issues: Safety Summary ("All Clear")
///  - AI Photos: Analyzed Photos ("No Photos")
///  - History: Analysis History ("No History")
class AiAnalysisView extends StatelessWidget {
  final String projectId;
  const AiAnalysisView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiAnalysisLogic>(
      init: AiAnalysisLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Safety monitoring and progress tracking',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 10),
              Obx(() => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 2.4,
                    children: [
                      _StatCard(
                          icon: Icons.photo_camera_outlined,
                          color: const Color(0xFF6B7280),
                          label: 'Photos Analyzed',
                          value: logic.photosAnalyzed.value),
                      _StatCard(
                          icon: Icons.gpp_maybe_outlined,
                          color: const Color(0xFF10B981),
                          label: 'Critical Issues',
                          value: logic.criticalIssues.value),
                      _StatCard(
                          icon: Icons.pending_actions_outlined,
                          color: const Color(0xFFF59E0B),
                          label: 'Pending Review',
                          value: logic.pendingReview.value),
                      _StatCard(
                          icon: Icons.layers_outlined,
                          color: const Color(0xFF3B82F6),
                          label: 'Analysis Batches',
                          value: logic.analysisBatches.value),
                    ],
                  )),
              const SizedBox(height: 12),
              Obx(() => ScrollSegmentToggle<AiAnalysisSection>(
                    values: AiAnalysisSection.values,
                    labelOf: (s) => s.label,
                    selected: logic.section.value,
                    onChanged: logic.onSectionChange,
                  )),
              const SizedBox(height: 12),
              Obx(() {
                switch (logic.section.value) {
                  case AiAnalysisSection.overview:
                    return Column(
                      children: [
                        const _SafetySummaryCard(),
                        PanelCard(
                          title: 'Material Activity',
                          child: Column(
                            children: [
                              const PanelEmptyBody(
                                icon: Icons.inventory_2_outlined,
                                message: 'No Material Activity',
                                hint: 'Run an analysis to detect material deliveries and usage.',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: TextButton(
                                  onPressed: logic.runAnalysis,
                                  child: Text('Run analysis',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primaryOrange)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  case AiAnalysisSection.safety:
                    return const _SafetySummaryCard();
                  case AiAnalysisSection.photos:
                    return const PanelCard(
                      title: 'Analyzed Photos',
                      child: PanelEmptyBody(
                          icon: Icons.image_not_supported_outlined, message: 'No Photos'),
                    );
                  case AiAnalysisSection.history:
                    return const PanelCard(
                      title: 'Analysis History',
                      child: PanelEmptyBody(icon: Icons.history, message: 'No History'),
                    );
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

class _SafetySummaryCard extends StatelessWidget {
  const _SafetySummaryCard();

  @override
  Widget build(BuildContext context) => const PanelCard(
        title: 'Safety Summary',
        child: PanelEmptyBody(
          icon: Icons.verified_user_outlined,
          message: 'All Clear',
          hint: 'No safety issues detected',
        ),
      );
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;

  const _StatCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: color.withAlpha(28),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                Text('$value',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
