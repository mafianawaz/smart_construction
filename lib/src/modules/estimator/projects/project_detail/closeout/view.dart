import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_docs_models.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_format.dart';
import 'logic.dart';

/// Closeout Package tab (app bar "Project Closeout") — subtitle, an
/// "Overall completion" card with a progress bar, the Checklist Items /
/// Closeout Package strip, then one card per checklist item (category
/// chip, status tag, title, description, sign-off line). Tapping a card
/// toggles it complete.
class CloseoutView extends StatelessWidget {
  final String projectId;
  const CloseoutView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CloseoutLogic>(
      init: CloseoutLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Project Closeout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(
                'Track all closeout deliverables, auto-pulled from project artifacts, '
                'and generate a closeout package with a table of contents.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              Obx(() => _CompletionCard(
                    percent: logic.completionPercent,
                    done: logic.completeCount,
                    total: logic.items.length,
                  )),
              const SizedBox(height: 12),
              Obx(() => ScrollSegmentToggle<CloseoutSection>(
                    values: CloseoutSection.values,
                    labelOf: (s) => s.label,
                    selected: logic.section.value,
                    onChanged: logic.onSectionChange,
                  )),
              const SizedBox(height: 12),
              Obx(() {
                if (logic.section.value == CloseoutSection.closeoutPackage) {
                  return PanelCard(
                    title: 'Closeout Package',
                    subtitle: 'Compile completed deliverables into one document.',
                    child: Column(
                      children: [
                        const PanelEmptyBody(
                          icon: Icons.folder_zip_outlined,
                          message: 'No closeout package generated yet',
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                          child: ProjectActionButton(
                            label: 'Generate Package',
                            icon: Icons.auto_awesome_outlined,
                            onPressed: logic.generatePackage,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                if (logic.items.isEmpty) {
                  return const ProjectEmptyCard(
                    icon: Icons.assignment_outlined,
                    message: 'No closeout checklist items for this project yet',
                  );
                }
                return Column(
                  children: [
                    for (final item in logic.items.toList())
                      _ItemCard(item: item, onTap: () => logic.toggleComplete(item)),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _CompletionCard extends StatelessWidget {
  final double percent;
  final int done;
  final int total;
  const _CompletionCard({required this.percent, required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overall completion',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('${projectNumber(percent.roundToDouble())}% of closeout items marked complete'
              ' ($done of $total)',
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(AppColors.primaryOrange),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final CloseoutItemModel item;
  final VoidCallback onTap;
  const _ItemCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProjectBadge(
                        label: item.category,
                        background: Colors.grey.shade100,
                        foreground: Colors.grey.shade700),
                    const Spacer(),
                    ProjectBadge(
                        label: item.status.label.toUpperCase(),
                        background: item.status.background,
                        foreground: item.status.foreground),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item.title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(item.description,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.verified_outlined, size: 12, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      item.signedOffBy == null ? 'No signoff' : 'Signed off by ${item.signedOffBy}',
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
