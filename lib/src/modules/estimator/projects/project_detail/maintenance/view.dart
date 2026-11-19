import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../widgets/scroll_segment_toggle.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../../widgets/project_empty_card.dart';
import '../procurement/widgets/procurement_stat_tile.dart';
import '../risks/widgets/risk_filter_pill.dart';
import '../widgets/handover_banner.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_format.dart';
import '../widgets/project_record_tile.dart';
import 'logic.dart';

/// Maintenance tab — amber "Handover In Progress" banner, the Log /
/// Schedule / Cost Summary strip, then:
///  - Log: "All Types" pill, From / To dates, list or "No Maintenance Logs"
///  - Schedule: list or "No Recurring Schedules"
///  - Cost Summary: three stat tiles
class MaintenanceView extends StatelessWidget {
  final String projectId;
  const MaintenanceView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaintenanceLogic>(
      init: MaintenanceLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HandoverBanner(
                tone: HandoverTone.warning,
                title: 'Handover In Progress',
                body: 'Maintenance logging is available from handover onward. '
                    'Recurring schedules start once handover is signed off.',
              ),
              const SizedBox(height: 12),
              Obx(() => ScrollSegmentToggle<MaintenanceSection>(
                    values: MaintenanceSection.values,
                    labelOf: (s) => s.label,
                    selected: logic.section.value,
                    onChanged: logic.onSectionChange,
                  )),
              const SizedBox(height: 12),
              Obx(() {
                switch (logic.section.value) {
                  case MaintenanceSection.log:
                    return _LogSection(logic: logic);
                  case MaintenanceSection.schedule:
                    return _ScheduleSection(logic: logic);
                  case MaintenanceSection.costSummary:
                    return _CostSummarySection(logic: logic);
                }
              }),
            ],
          ),
        );
      },
    );
  }
}

class _LogSection extends StatelessWidget {
  final MaintenanceLogic logic;
  const _LogSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => RiskFilterPill<MaintenanceType>(
              allLabel: 'All Types',
              value: logic.typeFilter.value,
              options: MaintenanceType.values,
              labelOf: (t) => t.label,
              onChanged: (v) => logic.typeFilter.value = v,
              filled: true,
            )),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Obx(() => ProjectDateField(
                    label: 'From',
                    hint: 'dd/mm/yyyy',
                    format: 'dd/MM/yyyy',
                    value: logic.fromDate.value,
                    onChanged: (d) => logic.fromDate.value = d,
                  )),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() => ProjectDateField(
                    label: 'To',
                    hint: 'dd/mm/yyyy',
                    format: 'dd/MM/yyyy',
                    value: logic.toDate.value,
                    onChanged: (d) => logic.toDate.value = d,
                  )),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final list = logic.filteredLogs;
          if (list.isEmpty) {
            return ProjectEmptyCard(
              icon: Icons.build_circle_outlined,
              message: logic.logs.isEmpty
                  ? 'No Maintenance Logs'
                  : 'No maintenance logs match the filters',
            );
          }
          return Column(
            children: [
              for (final l in list)
                ProjectRecordTile(
                  title: l.title,
                  lines: [DateFormat('MMM d, y').format(l.date), projectMoney(l.cost)],
                  badges: [
                    ProjectBadge(
                        label: l.type.label,
                        background: Colors.grey.shade100,
                        foreground: Colors.grey.shade700),
                  ],
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _ScheduleSection extends StatelessWidget {
  final MaintenanceLogic logic;
  const _ScheduleSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (logic.schedules.isEmpty) {
        return const ProjectEmptyCard(
          icon: Icons.event_repeat_outlined,
          message: 'No Recurring Schedules',
        );
      }
      return Column(
        children: [
          for (final s in logic.schedules)
            ProjectRecordTile(
              title: s.title,
              lines: [
                s.frequency,
                if (s.nextDue != null) 'Next due ${DateFormat('MMM d, y').format(s.nextDue!)}',
              ],
            ),
        ],
      );
    });
  }
}

class _CostSummarySection extends StatelessWidget {
  final MaintenanceLogic logic;
  const _CostSummarySection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ProcurementStatTile(label: 'Total Logs', value: '${logic.logs.length}'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ProcurementStatTile(
                      label: 'Total Cost', value: projectMoney(logic.totalCost)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: ProcurementStatTile(
                    label: 'Active Schedules', value: '${logic.schedules.length}'),
              ),
            ),
          ],
        ));
  }
}
