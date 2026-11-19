import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_construction/src/utils/app_color.dart';
import 'package:smart_construction/src/utils/app_icons.dart';
import 'package:smart_construction/src/widgets/app_appbar.dart';
import 'package:smart_construction/src/widgets/app_empty_filter.dart';
import 'package:smart_construction/src/widgets/app_textfield.dart';
import 'package:smart_construction/src/widgets/custom_toggle_switch.dart';

import '../../field_worker/my_work/widget/calendar_view.dart';
import 'logic.dart';
import 'models/project_enums.dart';
import 'widgets/project_card.dart';

/// "All Projects" — Table / Calendar / Map toggle over a searchable,
/// filterable list of awarded projects.
class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProjectsLogic>(
      init: ProjectsLogic(),
      builder: (logic) {
        return Scaffold(
          appBar: SecondaryAppbar(
            title: 'All Projects',
            subTitle: 'View and manage all awarded construction Projects.',
            isHome: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Obx(() => CustomToggle(
                        options: const ['Table', 'Calendar', 'Map'],
                        isIconToggle: true,
                        toggleIcon: [AppIcons.table, AppIcons.calendar, AppIcons.map],
                        selectedIndex: logic.selectedView.value,
                        onChanged: logic.onViewChange,
                      )),
                  const SizedBox(height: 15),
                  Obx(() => logic.selectedView.value == 0
                      ? _TableSection(logic: logic)
                      : logic.selectedView.value == 1
                      ? CalendarDemoScreen()
                      : Column(
                         children: [
                           Image.asset(AppImages.map,fit: BoxFit.cover,),
                         ],
                  ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TableSection extends StatelessWidget {
  final ProjectsLogic logic;
  const _TableSection({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hintText: 'Search Projects...',
          leftIconPath: AppIcons.search,
          onChange: logic.onSearch,
        ),
        const SizedBox(height: 15),
        Obx(() {
          final list = logic.filteredProjects;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Showing ${list.length} Projects',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              _StatusFilterPill(logic: logic),
            ],
          );
        }),
        const SizedBox(height: 15),
        Obx(() {
          final list = logic.filteredProjects;
          if (list.isEmpty) {
            return const AppEmptyState(
              icon: Icons.search_off_outlined,
              title: 'No Projects Found',
              message: 'Try a different search or status filter.',
              showButton: false,
            );
          }
          return Column(
            children: [
              for (final project in list)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: ProjectCard(
                    project: project,
                    onTap: () => logic.openProject(project),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }
}

class _StatusFilterPill extends StatelessWidget {
  final ProjectsLogic logic;
  const _StatusFilterPill({required this.logic});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final current = logic.statusFilter.value;
      return PopupMenuButton<ProjectStatus?>(
        initialValue: current,
        onSelected: logic.setStatusFilter,
        itemBuilder: (context) => [
          const PopupMenuItem(value: null, child: Text('All Statuses')),
          for (final s in ProjectStatus.values)
            PopupMenuItem(value: s, child: Text(s.label)),
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(current?.label ?? 'All Statuses',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.white),
            ],
          ),
        ),
      );
    });
  }
}
