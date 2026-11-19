import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/handover_banner.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_record_tile.dart';
import 'logic.dart';

/// Warranty tab — blue "Handover Pending" banner, the "Warranty &
/// Post-Construction" heading, Export + Log Case, three filter pills,
/// then the list or "No Warranty Cases".
class WarrantyView extends StatelessWidget {
  final String projectId;
  const WarrantyView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WarrantyLogic>(
      init: WarrantyLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HandoverBanner(
                tone: HandoverTone.info,
                title: 'Handover Pending',
                body: 'The close-out handover signoff has not been completed yet. '
                    'Warranty periods begin once handover is signed off.',
              ),
              const SizedBox(height: 14),
              const Text('Warranty & Post-Construction',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Track defects, warranty claims, and callbacks.',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Export',
                      icon: Icons.file_upload_outlined,
                      filled: false,
                      onPressed: logic.export,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProjectActionButton(
                      label: 'Log Case',
                      icon: Icons.add,
                      onPressed: logic.openLogCase,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Obx(() => RiskFilterPill<WarrantyStatus>(
                        allLabel: 'All Status',
                        value: logic.statusFilter.value,
                        options: WarrantyStatus.values,
                        labelOf: (s) => s.label,
                        onChanged: (v) => logic.statusFilter.value = v,
                        filled: true,
                      )),
                  Obx(() => RiskFilterPill<WarrantyType>(
                        allLabel: 'All Types',
                        value: logic.typeFilter.value,
                        options: WarrantyType.values,
                        labelOf: (t) => t.label,
                        onChanged: (v) => logic.typeFilter.value = v,
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
              Obx(() {
                final list = logic.filtered;
                if (list.isEmpty) {
                  return ProjectEmptyCard(
                    icon: Icons.shield_outlined,
                    message: logic.cases.isEmpty
                        ? 'No Warranty Cases'
                        : 'No warranty cases match the filters',
                  );
                }
                return Column(
                  children: [
                    for (final c in list)
                      ProjectRecordTile(
                        title: '${c.number} - ${c.title}',
                        lines: [
                          if (c.location != null) c.location!,
                          if (c.targetResolution != null)
                            'Target ${DateFormat('MMM d, y').format(c.targetResolution!)}',
                        ],
                        badges: [
                          ProjectBadge(
                              label: c.status.label,
                              background: c.status.background,
                              foreground: c.status.foreground),
                          ProjectBadge(
                              label: c.priority.label,
                              background: c.priority.background,
                              foreground: c.priority.foreground),
                          ProjectBadge(
                              label: c.type.label,
                              background: Colors.grey.shade100,
                              foreground: Colors.grey.shade700),
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
