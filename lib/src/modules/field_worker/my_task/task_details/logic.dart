import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_color.dart';
import '../model/task_model.dart';

class SubtaskEntry {
  final String title;
  bool isDone;

  SubtaskEntry({required this.title, this.isDone = false});
}

/// Controller backing [TaskDetailView]. Holds the active tab
/// (Attachments / Subtasks / Discussion), the task record itself, and
/// the mutable subtask/comment lists — replace the mock task and the
/// add* methods with real API calls once available.
class TaskDetailLogic extends GetxController {
  int selectedTab = 0; // 0 attachments, 1 subtasks, 2 discussion

  void changeTab(int index) {
    selectedTab = index;
    update();
  }

  final TaskItem task = TaskItem(
    id: '1',
    title: 'test',
    category: const TaskCategory(
      label: 'Equipment Repair',
      icon: Icons.build,
      color: AppColors.darkGreen,
    ),
    status: TaskStatus.completed,
    priority: TaskPriority.medium,
    assigneeName: null,
    createdDate: DateTime(2026, 6, 25),
    dueDate: null,
  );

  final List<SubtaskEntry> subtasks = [];
  final List<CommentEntry> comments = [];

  final subtaskController = TextEditingController();
  final commentController = TextEditingController();

  int get attachmentsCount => 0;
  int get subtasksDone => subtasks.where((s) => s.isDone).length;
  int get subtasksTotal => subtasks.length;
  int get commentsCount => comments.length;

  void addSubtask() {
    final title = subtaskController.text.trim();
    if (title.isEmpty) return;
    subtasks.add(SubtaskEntry(title: title));
    subtaskController.clear();
    update();
  }

  void toggleSubtask(int index, bool? value) {
    subtasks[index].isDone = value ?? false;
    update();
  }

  void addComment() {
    final message = commentController.text.trim();
    if (message.isEmpty) return;
    comments.add(CommentEntry(authorName: 'You', timestamp: 'Just now', message: message));
    commentController.clear();
    update();
  }

  @override
  void onClose() {
    subtaskController.dispose();
    commentController.dispose();
    super.onClose();
  }
}

class CommentEntry {
  final String authorName;
  final String timestamp;
  final String message;

  CommentEntry({required this.authorName, required this.timestamp, required this.message});
}