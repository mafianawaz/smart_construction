import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../../widgets/project_list_tile.dart';
import '../risks/widgets/risk_filter_pill.dart';
import 'logic.dart';

/// Delays tab — description line, "All Statuses" (filled) and "All
/// Reason" (outlined) filter pills, then the delay list or its empty
/// state. Reuses the generic `RiskFilterPill` rather than a copy.
class DelaysView extends StatelessWidget {
  final String projectId;
  const DelaysView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DelaysLogic>(
      init: DelaysLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Track weather, scheduling, and contractor delays affecting this project',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => RiskFilterPill<DelayStatus>(
                          allLabel: 'All Statuses',
                          value: logic.statusFilter.value,
                          options: DelayStatus.values,
                          labelOf: (s) => s.label,
                          onChanged: logic.setStatusFilter,
                          filled: true,
                        )),
                    const SizedBox(width: 8),
                    Obx(() => RiskFilterPill<DelayReason>(
                          allLabel: 'All Reason',
                          value: logic.reasonFilter.value,
                          options: DelayReason.values,
                          labelOf: (r) => r.label,
                          onChanged: logic.setReasonFilter,
                        )),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Obx(() {
                final all = logic.delays.length;
                final list = logic.filteredDelays;
                if (list.isEmpty) {
                  return ProjectEmptyCard(
                    icon: Icons.schedule_outlined,
                    message: all == 0
                        ? 'No delays reported for this project yet.'
                        : 'No delays match the selected filters.',
                  );
                }
                final fmt = DateFormat('MMM d, y');
                return Column(
                  children: [
                    for (final d in list)
                      ProjectListTile(
                        icon: Icons.schedule_outlined,
                        title: d.title,
                        subtitle: '${d.reason.label} · ${fmt.format(d.startDate)}'
                            ' · ${d.daysLost} ${d.daysLost == 1 ? 'day' : 'days'}',
                        trailing: ProjectBadge(
                          label: d.status.label,
                          background: d.status.color.withAlpha(30),
                          foreground: d.status.color,
                        ),
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
