import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_construction/src/modules/estimator/projects/models/project_enums.dart';
import 'package:smart_construction/src/utils/app_color.dart';

import '../../../models/schedule_model.dart';
import '../../../widgets/project_badge.dart';
import '../../../widgets/project_empty_card.dart';

/// Schedule -> Critical Path: the zero-float chain, in order, with an
/// orange arrow between steps. [tasks] must already be critical-path
/// tasks sorted by start (see `ScheduleLogic.criticalPathTasks`).
class CriticalPathSection extends StatelessWidget {
  final List<GanttTaskModel> tasks;
  final DateTime startDate;

  const CriticalPathSection({super.key, required this.tasks, required this.startDate});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Critical Path Chain',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        const SizedBox(height: 10),
        if (tasks.isEmpty)
          const ProjectEmptyCard(
            icon: Icons.account_tree_outlined,
            message: 'No critical path yet. Generate a schedule first.',
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.fieldBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < tasks.length; i++) ...[
                  _ChainItem(task: tasks[i], startDate: startDate, fmt: fmt),
                  if (i != tasks.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Icon(Icons.arrow_downward_rounded,
                          size: 14, color: AppColors.primaryOrange),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ChainItem extends StatelessWidget {
  final GanttTaskModel task;
  final DateTime startDate;
  final DateFormat fmt;

  const _ChainItem({required this.task, required this.startDate, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final start = startDate.add(Duration(days: task.startOffsetDays));
    final end = startDate.add(Duration(days: task.endOffsetDays - 1));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(task.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(
          '${fmt.format(start)} - ${fmt.format(end)} · Float: ${task.floatDays}d',
          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            ProjectBadge(
              label: task.status.label,
              background: task.status.background,
              foreground: task.status.foreground,
            ),
            ProjectBadge(
              label: '${task.durationDays}d',
              background: const Color(0xFFEDEDEF),
              foreground: Colors.grey.shade700,
            ),
          ],
        ),
      ],
    );
  }
}
