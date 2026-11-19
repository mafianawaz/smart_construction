import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../logic.dart';
import '../models/crm_activity_models.dart';
import '../widgets/crm_action_button.dart';
import '../widgets/crm_blank_state.dart';
import '../widgets/crm_controls.dart';
import '../widgets/crm_section_header.dart';
import '../widgets/crm_task_card.dart';
import 'task_form_view.dart';

/// Tasks tab: "CRM Tasks" header with status filter + New Task, then either
/// the empty state or the task list.
class TasksTab extends StatelessWidget {
  final CrmLogic logic;

  const TasksTab({super.key, required this.logic});

  Future<void> _newTask() async {
    final result = await Get.to<CrmTaskModel>(
      () => TaskFormView(
        id: logic.newTaskId(),
        organizationNames: logic.organizations.map((o) => o.name).toList(),
        owners: logic.owners,
      ),
    );
    if (result != null) logic.addTask(result);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = logic.filteredTasks;
    final filter = logic.taskFilter;
    final now = logic.now;

    return ListView(
      children: [
        CrmSectionHeader(
          icon: Icons.check_box_outlined,
          title: 'CRM Tasks',
          count: tasks.length,
          actions: [
            SizedBox(
              width: 92,
              child: CrmDropdownPill<TaskFilter>(
                allLabel: 'All',
                options: TaskFilter.values,
                labelOf: (f) => f.label,
                value: filter,
                onChanged: logic.setTaskFilter,
                compact: true,
              ),
            ),
            CrmActionButton(label: 'New Task', icon: Icons.add, onTap: _newTask),
          ],
        ),
        const SizedBox(height: 12),
        if (tasks.isEmpty)
          CrmBlankState(
            icon: Icons.check,
            title: 'No tasks',
            message: filter == TaskFilter.completed
                ? 'Completed tasks will show up here.'
                : 'Create follow-up tasks to keep deals moving.',
            buttonLabel: 'New Task',
            onButton: _newTask,
          )
        else
          for (final task in tasks)
            CrmTaskCard(
              key: ValueKey(task.id),
              task: task,
              now: now,
              onToggle: (done) => logic.toggleTask(task.id, done),
              onDelete: () => logic.deleteTask(task.id),
            ),
      ],
    );
  }
}
