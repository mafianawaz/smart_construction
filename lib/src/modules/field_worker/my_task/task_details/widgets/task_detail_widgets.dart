import 'package:flutter/material.dart';
import '../../../../../utils/app_color.dart';
import '../../model/task_model.dart';
import '../../widget/pill_chip.dart';

/// Top block of the Task Details screen — status + priority pills,
/// the task title, and the category label underneath.
class TaskDetailHeader extends StatelessWidget {
  final TaskItem task;

  const TaskDetailHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PillChip(
              label: task.status.label.toUpperCase(),
              color: task.status.color,
            ),
            const SizedBox(width: 8),
            PillChip(label: task.priority.label, color: task.priority.color),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          task.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          task.category.label,
          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// Single labeled cell shown inside [TaskInfoGrid].
class TaskInfoField {
  final IconData icon;
  final String label;
  final String value;

  const TaskInfoField({
    required this.icon,
    required this.label,
    required this.value,
  });
}

/// 2-per-row grid of bordered info cells (Assignee, Created, Due Date,
/// Category, ...). Takes a flat [fields] list so it isn't locked to
/// exactly four entries.
class TaskInfoGrid extends StatelessWidget {
  final List<TaskInfoField> fields;
  final int columns;

  const TaskInfoGrid({super.key, required this.fields, this.columns = 2});

  List<List<TaskInfoField>> get _rows {
    final rows = <List<TaskInfoField>>[];
    for (var i = 0; i < fields.length; i += columns) {
      rows.add(
        fields.sublist(
          i,
          i + columns > fields.length ? fields.length : i + columns,
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final row in _rows) ...[
          Row(
            children: [
              for (final field in row) ...[
                Expanded(child: _cell(field)),
                if (field != row.last) const SizedBox(width: 10),
              ],
            ],
          ),
          if (row != _rows.last) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _cell(TaskInfoField field) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(field.icon, size: 15, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  field.value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One stat shown in [TaskStatsRow] (e.g. "0 Attachments").
class TaskStat {
  final IconData icon;
  final String label;

  const TaskStat({required this.icon, required this.label});
}

/// Muted icon+label row summarizing attachments / subtasks / comments
/// counts. Flat list input so it scales to however many stats a screen
/// wants to show.
class TaskStatsRow extends StatelessWidget {
  final List<TaskStat> stats;

  const TaskStatsRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final stat in stats) ...[
          Icon(stat.icon, size: 14, color: AppColors.textMuted),
          const SizedBox(width: 4),
          Text(
            stat.label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          if (stat != stats.last) const SizedBox(width: 16),
        ],
      ],
    );
  }
}

/// Text field + orange "+" button used to add a new subtask.
class SubtaskInputRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const SubtaskInputRow({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F7F9),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller,
              onSubmitted: (_) => onAdd(),
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Add subtask...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: onAdd,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}

/// One completed/incomplete subtask row shown once subtasks exist.
class SubtaskTile extends StatelessWidget {
  final String title;
  final bool isDone;
  final ValueChanged<bool?> onChanged;

  const SubtaskTile({
    super.key,
    required this.title,
    required this.isDone,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Checkbox(
            value: isDone,
            onChanged: onChanged,
            activeColor: AppColors.primaryOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: isDone ? AppColors.textMuted : AppColors.textDark,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One comment shown in the Discussion tab once comments exist.
class CommentTile extends StatelessWidget {
  final String authorName;
  final String timestamp;
  final String message;

  const CommentTile({
    super.key,
    required this.authorName,
    required this.timestamp,
    required this.message,
  });

  String get _initials {
    final parts = authorName.trim().split(' ');
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: AppColors.primaryOrange.withOpacity(0.15),
            child: Text(
              _initials,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryOrange,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      authorName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      timestamp,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed footer bar for adding a comment — attachment icon, text field,
/// and an orange send button. Stays mounted across all Task Details
/// tabs (it isn't part of the tab content itself).
class CommentInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback? onAttachTap;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onAttachTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            InkWell(
              onTap: onAttachTap,
              child: Container(
                width: 43,
                height: 43,
                decoration: const BoxDecoration(
                  color: const Color(0xFFF6F7F9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.attach_file,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => onSend(),
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Comment...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: onSend,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 43,
                height: 43,
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
