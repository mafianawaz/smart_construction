import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_record_tile.dart';
import 'logic.dart';

/// Submittals tab — subtitle, "+ Create Submittal", the All / Pending /
/// Overdue strip, the two pills (All Status, All Phase), then the list or
/// "No submittals yet".
class SubmittalsView extends StatelessWidget {
  final String projectId;
  const SubmittalsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubmittalsLogic>(
      init: SubmittalsLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Manage submittals for this project',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 10),
              ProjectActionButton(
                  label: 'Create Submittal', icon: Icons.add, onPressed: logic.openCreate),
              const SizedBox(height: 12),
              Obx(() => ScrollSegmentToggle<SubmittalView>(
                    values: SubmittalView.values,
                    labelOf: (v) => v.label,
                    selected: logic.view.value,
                    onChanged: logic.onViewChange,
                  )),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Obx(() => RiskFilterPill<SubmittalStatus>(
                        allLabel: 'All Status',
                        value: logic.statusFilter.value,
                        options: SubmittalStatus.values,
                        labelOf: (s) => s.label,
                        onChanged: (v) => logic.statusFilter.value = v,
                        filled: true,
                      )),
                  Obx(() => RiskFilterPill<SubmittalPhase>(
                        allLabel: 'All Phase',
                        value: logic.phaseFilter.value,
                        options: SubmittalPhase.values,
                        labelOf: (p) => p.label,
                        onChanged: (v) => logic.phaseFilter.value = v,
                      )),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                final list = logic.filtered;
                if (list.isEmpty) {
                  return ProjectEmptyCard(
                    icon: Icons.arrow_forward,
                    message: logic.submittals.isEmpty
                        ? 'No submittals yet'
                        : 'No submittals match the filters',
                  );
                }
                return Column(
                  children: [
                    for (final s in list)
                      ProjectRecordTile(
                        title: '${s.number} - ${s.subject}',
                        lines: [
                          [
                            s.type.label,
                            if (s.specSection != null) 'Spec ${s.specSection}',
                            if (s.documentCategory != null) s.documentCategory!,
                          ].join(' · '),
                          if (s.dateRequired != null)
                            'Required ${DateFormat('MMM d, y').format(s.dateRequired!)}',
                        ],
                        badges: [
                          ProjectBadge(
                              label: s.status.label,
                              background: s.status.background,
                              foreground: s.status.foreground),
                          ProjectBadge(
                              label: s.phase.label,
                              background: Colors.grey.shade100,
                              foreground: Colors.grey.shade700),
                          if (s.isOverdue)
                            const ProjectBadge(
                                label: 'Overdue',
                                background: Color(0x1ADC2626),
                                foreground: Color(0xFFDC2626)),
                        ],
                      ),
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
