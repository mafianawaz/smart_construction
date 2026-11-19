import 'package:flutter/material.dart';

import '../../../../utils/app_color.dart';
import '../model/task_model.dart';
import 'pill_chip.dart';


/// A single row in the task list. Purely presentational — pass in a
/// [TaskItem] and callbacks, this widget doesn't know about filtering
/// or navigation.
class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;

  const TaskCard({super.key, required this.task, this.onTap, this.onMoreTap});

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: task.category.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(task.category.icon, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        task.category.label.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // InkWell(
                //   onTap: onMoreTap,
                //   child: const Icon(Icons.more_vert, size: 18, color: AppColors.textMuted),
                // ),
              ],
            ),
            const SizedBox(height: 10),
            PillChip(label: task.status.label, color: task.status.color, filled: true),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.primaryOrange.withOpacity(0.15),
                  child: Text(
                    (task.assigneeName?.isNotEmpty ?? false)
                        ? task.assigneeName![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  task.assigneeName ?? 'Unassigned',
                  style: const TextStyle(fontSize: 12, color: AppColors.textDark),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 12, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  'Due ${_formatDate(task.dueDate)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}