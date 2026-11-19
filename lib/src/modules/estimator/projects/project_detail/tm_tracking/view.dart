import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';

import '../../models/field_ops_models.dart';
import '../../widgets/project_badge.dart';
import '../financials/widgets/panel_card.dart';
import '../widgets/project_format.dart';
import 'logic.dart';

/// T&M Tracking tab — three stacked panels: T&M Work Tickets (empty),
/// Time Entries (date + hours + description + status tag) and T&M Daily
/// Sheets (Legacy) (empty).
class TmTrackingView extends StatelessWidget {
  final String projectId;
  const TmTrackingView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TmTrackingLogic>(
      init: TmTrackingLogic(projectId),
      tag: projectId,
      builder: (logic) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            children: [
              const PanelCard(
                title: 'T&M Work Tickets',
                child: PanelEmptyBody(
                  icon: Icons.description_outlined,
                  message: 'No T&M work tickets yet',
                ),
              ),
              PanelCard(
                title: 'Time Entries',
                child: Obx(() {
                  final entries = logic.sortedEntries;
                  if (entries.isEmpty) {
                    return const PanelEmptyBody(
                      icon: Icons.schedule,
                      message: 'No time entries yet',
                    );
                  }
                  return Column(
                    children: [
                      for (var i = 0; i < entries.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: Colors.grey.shade200),
                        _TimeEntryRow(entry: entries[i]),
                      ],
                    ],
                  );
                }),
              ),
              const PanelCard(
                title: 'T&M Daily Sheets (Legacy)',
                child: PanelEmptyBody(
                  icon: Icons.assignment_outlined,
                  message: 'No T&M sheets yet',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeEntryRow extends StatelessWidget {
  final TmTimeEntryModel entry;
  const _TimeEntryRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('MMM d, y').format(entry.date),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(entry.description,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                if (entry.detail != null)
                  Text(entry.detail!,
                      style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${projectNumber(entry.hours)} hours',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              ProjectBadge(
                label: entry.status.label.toUpperCase(),
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
