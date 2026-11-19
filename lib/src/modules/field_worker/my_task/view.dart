import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_icons.dart';
import '../my_work/widget/calendar_view.dart';
import 'logic.dart';
import 'task_details/view.dart';
import 'widget/task_card.dart';
import 'widget/task_filter.dart';
import 'widget/task_status_filter.dart';

/// Task list screen ("Manage manual tasks and track insights").
///
/// This is content-only — it's expected to sit inside whatever shell
/// already renders the app's bottom navigation (My Day / My Work /
/// My Task / Messages / More), so no Scaffold bottom bar is declared
/// here. Drop it straight into that shell's "My Task" tab body.
class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListLogic>(
      init: TaskListLogic(),
      builder: (logic) {
        final tasks = logic.filteredTasks;
        return Scaffold(
          appBar: SecondaryAppbar(
            isHome: false,
            title: 'Task',
            count: '0 tasks',
            subTitle: 'Manage manual tasks and track insights',
          ),
          body: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  hintText: 'Search tasks...',
                  leftIconPath: AppIcons.search,
                  controller: logic.searchController,
                  onChange: logic.updateSearch,
                ),
                const SizedBox(height: 12),
                Obx(()=> CustomToggle(
                    options: ['List', 'Calendar'],
                    isIconToggle: true,
                    toggleIcon: [AppIcons.table, AppIcons.calendar],
                    selectedIndex: logic.selectedIndex.value,
                    onChanged: logic.changeIndex
                )),
                const SizedBox(height: 12),
                Obx(() {
                  switch (logic.selectedIndex.value) {
                    case 0:
                      return  Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TaskFilterDropdown(label: 'All Priorities', onTap: () {}),
                                  const SizedBox(width: 8),
                                  TaskFilterDropdown(label: 'All Categories', onTap: () {}),
                                ],
                              ),
                              const SizedBox(height: 12),
                              TaskStatusFilterBar(
                                options: logic.statusOptions,
                                selectedIndex: logic.statusFilterIndex,
                                onChanged: logic.changeStatusFilter,
                              ),
                              const SizedBox(height: 12),
                              tasks.isEmpty
                                  ? const Center(
                                child: Text(
                                  'No tasks match this filter',
                                  style: TextStyle(color: AppColors.textMuted),
                                ),
                              )
                                  : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) {
                                  return TaskCard(
                                    task: tasks[index],
                                    onTap: () {
                                      Get.to(()=> TaskDetailView());
                                    },
                                    onMoreTap: () {
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    case 1:
                      return CalendarDemoScreen();
                    default:
                      return SizedBox();
                  }
                }),


              ],
            ),
          ),
        );
      },
    );
  }
}