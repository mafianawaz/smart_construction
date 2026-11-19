import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';

import '../../models/field_ops_models.dart';
import '../../models/project_enums.dart';
import '../../widgets/project_badge.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/project_date_field.dart';
import '../widgets/project_format.dart';
import '../widgets/project_select_field.dart';
import 'logic.dart';

/// Labor tab — four stacked panels, as in the reference: Filters &
/// Sorting (Trade, Start/End Date, Employee search, Approval Status,
/// Sort By), Labor Hours (list or empty state), Project Default Labor
/// Rates and Employee Rate Overrides (both empty with a grey info box).
class LaborHoursView extends StatelessWidget {
  final String projectId;
  const LaborHoursView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LaborHoursLogic>(
      init: LaborHoursLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              _FiltersCard(logic: logic),
              PanelCard(
                title: 'Labor Hours',
                subtitle: 'Detailed labor hours for the selected filters',
                child: Obx(() {
                  final list = logic.filteredEntries;
                  if (list.isEmpty) {
                    return PanelEmptyBody(
                      icon: Icons.access_time,
                      message: logic.entries.isEmpty
                          ? 'No labor hours recorded'
                          : 'No labor hours match the filters',
                      hint: logic.entries.isEmpty
                          ? 'Approved timecards for this project will appear here.'
                          : null,
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < list.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
                        _LaborRow(entry: list[i]),
                      ],
                    ],
                  );
                }),
              ),
              const PanelCard(
                title: 'Project Default Labor Rates',
                subtitle: 'Override the organization labor rates for this project only. '
                    'Leave blank to use the organization defaults.',
                child: _InfoBox(
                  title: 'No project-specific rates set (optional)',
                  body: 'Add rates here to override the organization defaults for '
                      'every employee on this project.',
                ),
              ),
              const PanelCard(
                title: 'Employee Rate Overrides',
                subtitle: 'Set a different rate for a specific employee on this project. '
                    'Employee overrides take priority over project defaults.',
                child: _InfoBox(
                  title: 'No employee-specific rates set',
                  body: 'Employee overrides will appear here once added.',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
      );
}

class _FiltersCard extends StatelessWidget {
  final LaborHoursLogic logic;
  const _FiltersCard({required this.logic});

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      title: 'Filters & Sorting',
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _FieldLabel('Trade'),
            Obx(() => ProjectSelectField<ProjectTrade>(
                  allLabel: 'All Trades',
                  value: logic.trade.value,
                  options: ProjectTrade.values,
                  labelOf: (t) => t.label,
                  onChanged: (v) => logic.trade.value = v,
                )),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Obx(() => ProjectDateField(
                        label: 'Start Date',
                        hint: 'Pick a date',
                        value: logic.startDate.value,
                        onChanged: (d) => logic.startDate.value = d,
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Obx(() => ProjectDateField(
                        label: 'End Date',
                        hint: 'Pick a date',
                        value: logic.endDate.value,
                        onChanged: (d) => logic.endDate.value = d,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            CustomTextField(
              heading: 'Employee',
              hintText: 'Search by employee...',
              leftIconPath: AppIcons.search,
              onChange: logic.onEmployeeSearch,
            ),
            const SizedBox(height: 12),
            const _FieldLabel('Approval Status'),
            Obx(() => ProjectSelectField<TimeApprovalStatus>(
                  allLabel: 'All Statuses',
                  value: logic.approval.value,
                  options: TimeApprovalStatus.values,
                  labelOf: (s) => s.label,
                  onChanged: (v) => logic.approval.value = v,
                )),
            const SizedBox(height: 12),
            const _FieldLabel('Sort By'),
            Obx(() => ProjectSelectField<LaborSort>(
                  allLabel: LaborSort.dateNewest.label,
                  value: logic.sort.value,
                  options: LaborSort.values,
                  labelOf: (s) => s.label,
                  allowClear: false,
                  onChanged: (v) {
                    if (v != null) logic.sort.value = v;
                  },
                )),
            Obx(() => logic.hasActiveFilters
                ? Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: logic.clearFilters,
                      child: const Text('Clear filters', style: TextStyle(fontSize: 12)),
                    ),
                  )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class _LaborRow extends StatelessWidget {
  final LaborEntryModel entry;
  const _LaborRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.employee,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text('${entry.trade.label} · ${DateFormat('MMM d, y').format(entry.date)}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${projectNumber(entry.hours)} hrs',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              ProjectBadge(
                label: entry.status.label,
                background: entry.status.background,
                foreground: entry.status.foreground,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Grey rounded box inside the two rate panels.
class _InfoBox extends StatelessWidget {
  final String title;
  final String body;
  const _InfoBox({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(body, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
