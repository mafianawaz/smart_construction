import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_empty_filter.dart';
import '../../../../widgets/custom_tabbar.dart';
import 'logic.dart';
import 'widgets/task_detail_widgets.dart';

/// Task Details screen — header, 2x2 info grid, stats row, and three
/// tabs (Attachments / Subtasks / Discussion). The comment bar at the
/// bottom is fixed to the Scaffold, not the tab content, since it's
/// shown regardless of which tab is active in the design.
class TaskDetailView extends StatelessWidget {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskDetailLogic>(
      init: TaskDetailLogic(),
      builder: (logic) {
        final task = logic.task;
        return Scaffold(
          appBar: const AppPrimaryBar(
            title: 'Task Details',
            centerTitle: true,
            showBackButton: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TaskDetailHeader(task: task),
                      const SizedBox(height: 16),
                      TaskInfoGrid(
                        fields: [
                          TaskInfoField(
                            icon: Icons.person_outline,
                            label: 'Assignee',
                            value: task.assigneeName ?? 'Unassigned',
                          ),
                          TaskInfoField(
                            icon: Icons.calendar_today_outlined,
                            label: 'Created',
                            value: task.createdDate != null
                                ? _formatDate(task.createdDate!)
                                : '—',
                          ),
                          TaskInfoField(
                            icon: Icons.watch_later_outlined,
                            label: 'Due Date',
                            value:
                            task.dueDate != null ? _formatDate(task.dueDate!) : '—',
                          ),
                          TaskInfoField(
                            icon: Icons.sell_outlined,
                            label: 'Category',
                            value: task.category.label,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      TaskStatsRow(
                        stats: [
                          TaskStat(
                            icon: Icons.attach_file,
                            label: '${logic.attachmentsCount} Attachments',
                          ),
                          TaskStat(
                            icon: Icons.checklist_outlined,
                            label: '${logic.subtasksDone}/${logic.subtasksTotal} Subtasks',
                          ),
                          TaskStat(
                            icon: Icons.chat_bubble_outline,
                            label: '${logic.commentsCount} Comments',
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      CustomTabBar(
                        tabs: [
                          CustomTabItem(
                            label: 'Attachments',
                            icon: Icons.attach_file,
                          ),
                          CustomTabItem(
                            label: 'Subtasks',
                            icon: Icons.checklist_outlined,
                          ),
                          CustomTabItem(
                            label: 'Discussion',
                            icon: Icons.chat_bubble_outline,
                          ),
                        ],
                        selectedIndex: logic.selectedTab,
                        onChanged: logic.changeTab,
                      ),
                      const SizedBox(height: 16),
                      if (logic.selectedTab == 0) _buildAttachmentsTab(),
                      if (logic.selectedTab == 1) _buildSubtasksTab(logic),
                      if (logic.selectedTab == 2) _buildDiscussionTab(logic),
                    ],
                  ),
                ),
              ),
              CommentInputBar(
                controller: logic.commentController,
                onSend: logic.addComment,
                onAttachTap: () {
                  // TODO: attach a file to the comment
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentsTab() {
    return const AppEmptyState(
      icon: Icons.file_upload_outlined,
      title: 'No attachments yet',
      message: 'Tap attachment to add files',
      showButton: false,
    );
  }

  Widget _buildSubtasksTab(TaskDetailLogic logic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubtaskInputRow(controller: logic.subtaskController, onAdd: logic.addSubtask),
        const SizedBox(height: 8),
        for (var i = 0; i < logic.subtasks.length; i++)
          SubtaskTile(
            title: logic.subtasks[i].title,
            isDone: logic.subtasks[i].isDone,
            onChanged: (value) => logic.toggleSubtask(i, value),
          ),
      ],
    );
  }

  Widget _buildDiscussionTab(TaskDetailLogic logic) {
    if (logic.comments.isEmpty) {
      return const AppEmptyState(
        icon: Icons.chat_bubble_outline,
        title: 'No Comments yet',
        message: 'Start a discussion about this task',
        showButton: false,
      );
    }
    return Column(
      children: [
        for (final comment in logic.comments)
          CommentTile(
            authorName: comment.authorName,
            timestamp: comment.timestamp,
            message: comment.message,
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}