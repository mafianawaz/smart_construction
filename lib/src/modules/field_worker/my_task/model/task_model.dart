import 'package:flutter/material.dart';
import '../../../../utils/app_color.dart';

/// Work state of a task. Centralizing the label/color mapping here means
/// every chip, filter, and card stays in sync automatically.
enum TaskStatus { pending, inProgress, completed }

extension TaskStatusX on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.pending:
        return AppColors.primaryOrange;
      case TaskStatus.inProgress:
        return AppColors.blue;
      case TaskStatus.completed:
        return AppColors.darkGreen;
    }
  }
}

enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityX on TaskPriority {
  String get label {
    switch (this) {
      case TaskPriority.low:
        return 'LOW';
      case TaskPriority.medium:
        return 'MEDIUM';
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.urgent:
        return 'URGENT';
    }
  }

  Color get color {
    switch (this) {
      case TaskPriority.low:
        return AppColors.textMuted;
      case TaskPriority.medium:
        return AppColors.primaryOrangeDark;
      case TaskPriority.high:
        return AppColors.primaryOrangeDark;
      case TaskPriority.urgent:
        return AppColors.primaryOrangeDark;
    }
  }
}

/// A category tag (Structural, Quality Control, Equipment Repair, ...)
/// paired with the icon/color used for a task card's leading avatar.
class TaskCategory {
  final String label;
  final IconData icon;
  final Color color;

  const TaskCategory({required this.label, required this.icon, required this.color});
}

/// A single row in the task list / the record shown on Task Details.
class TaskItem {
  final String id;
  final String title;
  final TaskCategory category;
  final TaskStatus status;
  final TaskPriority priority;
  final String? assigneeName;
  final DateTime? createdDate;
  final DateTime? dueDate;
  final int attachmentsCount;
  final int subtasksDone;
  final int subtasksTotal;
  final int commentsCount;

  const TaskItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.priority,
    this.assigneeName,
    this.createdDate,
    this.dueDate,
    this.attachmentsCount = 0,
    this.subtasksDone = 0,
    this.subtasksTotal = 0,
    this.commentsCount = 0,
  });
}