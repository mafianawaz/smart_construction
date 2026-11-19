import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/project_action_button.dart';
import '../widgets/project_record_tile.dart';
import 'logic.dart';

/// Document Transmittals tab — subtitle, "+ Create Transmittal", the
/// "All Status" pill, then the list or "No transmittals found".
class TransmittalsView extends StatelessWidget {
  final String projectId;
  const TransmittalsView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransmittalsLogic>(
      init: TransmittalsLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Distribute vendor plans, drawings, and specs to subcontractors',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(height: 10),
              ProjectActionButton(
                  label: 'Create Transmittal', icon: Icons.add, onPressed: logic.openCreate),
              const SizedBox(height: 12),
              Obx(() => RiskFilterPill<TransmittalStatus>(
                    allLabel: 'All Status',
                    value: logic.statusFilter.value,
                    options: TransmittalStatus.values,
                    labelOf: (s) => s.label,
                    onChanged: (v) => logic.statusFilter.value = v,
                    filled: true,
                  )),
              const SizedBox(height: 12),
              Obx(() {
                final list = logic.filtered;
                if (list.isEmpty) {
                  return ProjectEmptyCard(
                    icon: Icons.send_outlined,
                    message: logic.transmittals.isEmpty
                        ? 'No transmittals found'
                        : 'No transmittals match the filter',
                  );
                }
                return Column(
                  children: [
                    for (final t in list)
                      ProjectRecordTile(
                        title: '${t.number} - ${t.subject}',
                        lines: [
                          if (t.documentType != null)
                            '${t.documentType!.label}${t.revisionNumber == null ? '' : ' · Rev ${t.revisionNumber}'}',
                          if (t.recipients.isNotEmpty) 'To: ${t.recipients.join(', ')}',
                        ],
                        badges: [
                          ProjectBadge(
                              label: t.status.label,
                              background: t.status.background,
                              foreground: t.status.foreground),
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
