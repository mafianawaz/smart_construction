import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../financials/widgets/panel_card.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_record_tile.dart';
import 'logic.dart';

/// RFIs tab — muted subtitle, orange "+ Create RFI", two filter pills and
/// the "RFI Tracking Console" panel (list or "No RFIs yet").
class RfisView extends StatelessWidget {
  final String projectId;
  const RfisView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RfisLogic>(
      init: RfisLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Requests for Information',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 10),
              ProjectActionButton(label: 'Create RFI', icon: Icons.add, onPressed: logic.openCreate),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Obx(() => RiskFilterPill<RfiStatus>(
                        allLabel: 'All Status',
                        value: logic.statusFilter.value,
                        options: RfiStatus.values,
                        labelOf: (s) => s.label,
                        onChanged: (v) => logic.statusFilter.value = v,
                        filled: true,
                      )),
                  Obx(() => RiskFilterPill<PunchPriority>(
                        allLabel: 'All Priority',
                        value: logic.priorityFilter.value,
                        options: PunchPriority.values,
                        labelOf: (p) => p.label,
                        onChanged: (v) => logic.priorityFilter.value = v,
                      )),
                ],
              ),
              const SizedBox(height: 12),
              PanelCard(
                title: 'RFI Tracking Console',
                child: Obx(() {
                  final list = logic.filteredRfis;
                  if (list.isEmpty) {
                    return PanelEmptyBody(
                      icon: Icons.description_outlined,
                      message: logic.rfis.isEmpty ? 'No RFIs yet' : 'No RFIs match the filters',
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        for (final r in list)
                          ProjectRecordTile(
                            title: '${r.number} - ${r.subject}',
                            lines: [
                              r.question,
                              if (r.dateRequired != null)
                                'Due ${DateFormat('MMM d, y').format(r.dateRequired!)}',
                            ],
                            badges: [
                              ProjectBadge(
                                  label: r.status.label,
                                  background: r.status.background,
                                  foreground: r.status.foreground),
                              ProjectBadge(
                                  label: r.priority.label,
                                  background: r.priority.background,
                                  foreground: r.priority.foreground),
                              if (r.category != RfiCategory.none)
                                ProjectBadge(
                                    label: r.category.label,
                                    background: Colors.grey.shade100,
                                    foreground: Colors.grey.shade700),
                            ],
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
