import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/app_color.dart';
import 'model/task_model.dart';
import 'widget/task_status_filter.dart';

/// Controller backing [TaskListView]. Owns search text, the selected
/// status filter, the List/Calendar view toggle, and the (mock) task
/// data — swap `_allTasks` for a repository call once the API is ready.
class TaskListLogic extends GetxController {
  final searchController = TextEditingController();
  String searchQuery = '';

  final selectedIndex = 0.obs;
  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  int statusFilterIndex = 0; // index into statusOptions

  static const categories = {
    'structural': TaskCategory(
      label: 'Structural',
      icon: Icons.build_outlined,
      color: AppColors.primaryOrangeDark,
    ),
    'quality': TaskCategory(
      label: 'Quality Control',
      icon: Icons.build_outlined,
      color: AppColors.primaryOrangeDark,
    ),
    'general': TaskCategory(
      label: 'General',
      icon: Icons.build_outlined,
      color: AppColors.primaryOrangeDark,
    ),
  };

  final List<TaskItem> _allTasks = [
    TaskItem(
      id: '1',
      title: 'Steel Alignment Check',
      category: categories['structural']!,
      status: TaskStatus.inProgress,
      priority: TaskPriority.medium,
      assigneeName: 'James Wilson',
      dueDate: DateTime(2026, 6, 18),
    ),
    TaskItem(
      id: '2',
      title: 'Concrete Pour Supervision',
      category: categories['quality']!,
      status: TaskStatus.pending,
      priority: TaskPriority.high,
      assigneeName: 'Mike Chen',
      dueDate: DateTime(2026, 6, 20),
    ),
    TaskItem(
      id: '3',
      title: 'test',
      category: categories['general']!,
      status: TaskStatus.completed,
      priority: TaskPriority.medium,
      assigneeName: 'Sarah Mitchell',
      dueDate: DateTime(2026, 6, 12),
    ),
  ];

  List<TaskStatusFilterOption> get statusOptions => [
    TaskStatusFilterOption(label: 'All', count: _allTasks.length),
    TaskStatusFilterOption(
      label: 'Pending',
      count: _allTasks.where((t) => t.status == TaskStatus.pending).length,
    ),
    TaskStatusFilterOption(
      label: 'In Progress',
      count: _allTasks.where((t) => t.status == TaskStatus.inProgress).length,
    ),
    TaskStatusFilterOption(
      label: 'Completed',
      count: _allTasks.where((t) => t.status == TaskStatus.completed).length,
    ),
  ];

  List<TaskItem> get filteredTasks {
    var tasks = _allTasks;

    if (statusFilterIndex == 1) {
      tasks = tasks.where((t) => t.status == TaskStatus.pending).toList();
    } else if (statusFilterIndex == 2) {
      tasks = tasks.where((t) => t.status == TaskStatus.inProgress).toList();
    } else if (statusFilterIndex == 3) {
      tasks = tasks.where((t) => t.status == TaskStatus.completed).toList();
    }

    if (searchQuery.trim().isNotEmpty) {
      final query = searchQuery.trim().toLowerCase();
      tasks = tasks.where((t) => t.title.toLowerCase().contains(query)).toList();
    }

    return tasks;
  }

  void updateSearch(value) {
    searchQuery = value;
    update();
  }

  void changeStatusFilter(int index) {
    statusFilterIndex = index;
    update();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}