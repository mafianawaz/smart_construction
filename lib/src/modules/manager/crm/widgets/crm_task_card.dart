import 'package:flutter/material.dart';

import '../models/crm_activity_models.dart';
import 'crm_activity_style.dart';
import 'crm_palette.dart';

/// Task row: checkbox, title (struck through when done), optional notes, a
/// wrap of meta chips (due / priority / organization / assignee) and delete.
class CrmTaskCard extends StatelessWidget {
  final CrmTaskModel task;

  /// Injected "now" so overdue styling matches `CrmLogic`.
  final DateTime now;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  const CrmTaskCard({
    super.key,
    required this.task,
    required this.now,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final overdue = task.isOverdue(now);
    final due = task.dueDate;
    final org = task.organizationName;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(4, 6, 4, 10),
      decoration: BoxDecoration(
        color: CrmPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CrmPalette.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: task.isDone,
            onChanged: (v) => onToggle(v ?? false),
            activeColor: CrmPalette.orange,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: task.isDone ? CrmPalette.textMuted : CrmPalette.text,
                      decoration:
                          task.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (task.notes.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      task.notes,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: CrmPalette.textMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 4,
                    children: [
                      if (due != null)
                        _Meta(
                          icon: Icons.calendar_today_outlined,
                          text: overdue
                              ? 'Overdue · ${crmShortDate(due)}'
                              : 'Due ${crmShortDate(due)}',
                          color: overdue ? CrmPalette.danger : CrmPalette.textMuted,
                        ),
                      _Meta(
                        icon: Icons.flag_outlined,
                        text: task.priority.label,
                        color: task.priority.color,
                      ),
                      if (org != null && org.isNotEmpty)
                        _Meta(
                          icon: Icons.business_outlined,
                          text: org,
                          color: CrmPalette.textMuted,
                        ),
                      _Meta(
                        icon: Icons.person_outline,
                        text: task.assigneeLabel,
                        color: CrmPalette.textMuted,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: 'Delete task',
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline,
              size: 19,
              color: CrmPalette.textFaint,
            ),
          ),
        ],
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _Meta({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }
}
